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
final pathListFileProvider = StateProvider<PlatformFile?>((ref) => null);

final isLoadingStateProvider =
    StateProvider<bool>((ref) => ConstList.isWeb() ? false : true);
final loadProjectStateProvider = StateProvider<String>((ref) => '');

class PathListNotifier extends StateNotifier<List<String>> {
  Ref ref;

  PathListNotifier(this.ref) : super([]);

  Future<void> updateFromState() async {
    ProjectPath().setFrequentPathFromData(state);
  }

  Future<void> updateFromData() async {
    state = await ProjectPath().frequentPathFromData;
  }

  Future<bool> addDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      state = [...state, selectedDirectory];
      updateFromState();
      return true;
    }
    return false;
  }

  Future<int> addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip', 'json'],
    );
    if (result == null) return -1;

    var data = result.files.single;
    if (ConstList.isWeb()) {
      ref.read(pathListFileProvider.notifier).state = data;
      state = [data.name];
    } else {
      state = [...state, data.path!];
      updateFromState();
    }
    return 0;
  }

  Future<bool> openProject(void Function() dialog) async {
    ImageDB().clearImageCache();
    var index = ref.read(pathListSelectedProvider);
    if (ConstList.isWeb()) {
      PlatformSystem().openPlatformZipForWeb(ref.watch(pathListFileProvider));
      return true;
    }
    if (index == -1 || index >= state.length) {
      return false;
    }
    var path = state[index];
    if (path.endsWith('.zip')) {
      var file = File(path);
      if (!await file.exists()) {
        state.removeAt(index);
        state = [...state];
        updateFromState();
        return false;
      }
      await PlatformSystem().openPlatformZip(file);
      return true;
    }
    if (path.endsWith('.json')) {
      dialog();
      var file = File(path);
      if (!await file.exists()) {
        return false;
      }
      await PlatformSystem().openPlatformJson(file, ref);
      return true;
    }
    var dir = Directory(path);
    if (!await dir.exists()) {
      return false;
    }
    await PlatformSystem().openPlatformFolder(path);
    return true;
  }

  Future<void> removeFrequentPath(
      int index, Future<bool?> Function() dialog) async {
    if (ConstList.isMobile()) {
      if (!(await dialog() ?? false)) {
        return;
      }
      ProjectPath().removeFolder(state[index]);
    }
    state.removeAt(index);
    state = [...state];
    updateFromState();
  }

  set select(int index) {
    if (index == ref.read(pathListSelectedProvider)) {
      ref.read(pathListSelectedProvider.notifier).state = -1;
    } else {
      ref.read(pathListSelectedProvider.notifier).state = index;
    }
  }
}
