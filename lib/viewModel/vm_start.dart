import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/image_db.dart';
import '../model/opening_file_folder.dart';
import '../model/platform_system.dart';
import '../util/check_update.dart';

final needUpdateStateProvider = StateProvider<bool>((ref) {
  return false;
});

final versionProvider = FutureProvider<String>((ref) async {
  var needUpdate = await CheckUpdate.needUpdateCheck();
  ref.read(needUpdateStateProvider.notifier).update((state) => needUpdate);
  return ConstList.version;
});

final pathListProvider = StateNotifierProvider<PathListNotifier, List<String>>(
    (ref) => PathListNotifier(ref));

final pathListSelectedProvider = StateProvider<int>((ref) => -1);

final isLoadingStateProvider = StateProvider<bool>((ref) => ConstList.isWeb() ? false : true);

class PathListNotifier extends StateNotifier<List<String>> {
  Ref ref;
  List<Future<void>> isAdded = List.empty(growable: true);
  PathListNotifier(this.ref) : super([]);

  Future<bool> addDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      ProjectPath().addFrequentPath(selectedDirectory);
      state = List.from(ProjectPath().pathList);
      return true;
    }
    return false;
  }

  Future<int> addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip', 'json'],
    );
    if (result != null) {
      if (ConstList.isWeb()) {
        isAdded
            .add(PlatformSystem().openPlatformZipForWeb(result.files.single));
        state = [...state, result.files.single.name];
      } else {
        ProjectPath().addFrequentPath(result.files.single.path!);
        state = [...ProjectPath().pathList];
      }
      return 0;
    }
    return -1;
  }

  Future<bool> openProject() async {
    ImageDB().clearImageCache();
    var selected = ref.read(pathListSelectedProvider);
    if (selected >= 0) {
      await Future.wait(isAdded);

      isAdded.clear();
      if (ConstList.isWeb()) {
        return true;
      }
      var path = state[selected];
      if (path.isNotEmpty) {
        if (path.endsWith('.zip')) {
          var file = File(path);
          if (!await file.exists()) {
            return false;
          }
          await PlatformSystem().openPlatformZip(file);
        } else if (path.endsWith('.json')) {
          var file = File(path);
          if (!await file.exists()) {
            return false;
          }
          await PlatformSystem().openPlatformJson(file);
        } else {
          var dir = Directory(path);
          if (!await dir.exists()) {
            return false;
          }
          await PlatformSystem().openPlatformFolder(path);
        }
        return true;
      }
    } else if (ConstList.isWeb()) {
      await PlatformSystem().openPlatformVoid();
      return true;
    }
    return false;
  }

  Future<void> removeFrequentPath(
      int index, Future<bool?> Function() dialog) async {
    if (!ConstList.isMobile()) {
      await ProjectPath().removeFrequentPath(index);
      state = List.from(ProjectPath().pathList);
      await updatePathList();
    } else {
      if (await dialog() ?? false) {
        await ProjectPath().removeFrequentPath(index);
        await updatePathList();
      }
    }
  }

  Future<void> updatePathList() async {
    state = List.from(await ProjectPath().frequentPathFromData);
  }

  set select(int index) {
    if (index == ref.read(pathListSelectedProvider)) {
      ref.read(pathListSelectedProvider.notifier).state = -1;
    } else {
      ref.read(pathListSelectedProvider.notifier).state = index;
    }
  }
}
