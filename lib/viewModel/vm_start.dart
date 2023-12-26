import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/device_preference.dart';
import '../model/platform_file_system.dart';
import '../model/platform_system.dart';
import '../util/check_update.dart';

final needUpdateStateProvider = StateProvider<String?>((ref) {
  return null;
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
    DevicePreference().setFrequentPathFromData(state);
  }

  Future<void> updateFromData() async {
    state = await DevicePreference().frequentPathFromData;
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

  Future<LoadProjectState> openProject() async {
    getPlatformFileSystem.clear();
    var index = ref.read(pathListSelectedProvider);
    if (ConstList.isWeb()) {
      return await PlatformSystem()
          .openPlatformZipForWeb(ref.watch(pathListFileProvider));
    }
    if (index == -1 || index >= state.length) {
      return LoadProjectState(ProjectState.cyoapError);
    }
    var path = state[index];

    if (path.endsWith('.zip')) {
      var file = File(path);
      if (!await file.exists()) {
        state.removeAt(index);
        state = [...state];
        await updateFromState();
        return LoadProjectState(ProjectState.nonExist);
      }
      return await PlatformSystem().openPlatformZip(file);
    } else if (path.endsWith('.json')) {
      var file = File(path);
      if (!await file.exists()) {
        return LoadProjectState(ProjectState.nonExist);
      }
      return await PlatformSystem().openPlatformJson(file, ref);
    } else {
      var dir = Directory(path);
      if (!await dir.exists()) {
        return LoadProjectState(ProjectState.nonExist);
      }
      return await PlatformSystem().openPlatformFolder(path);
    }
  }

  Future<void> removeFrequentPath(
      int index, Future<bool?> Function() dialog) async {
    if (ConstList.isMobile()) {
      if (!(await dialog() ?? false)) {
        return;
      }
      DevicePreference().removeFolder(state[index]);
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
