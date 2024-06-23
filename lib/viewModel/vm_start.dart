import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../main.dart';
import '../model/device_preference.dart';
import '../model/device_preference_util.dart';
import '../model/platform_file_system.dart';
import '../model/platform_system.dart';
import '../util/check_update.dart';

part 'vm_start.g.dart';

final needUpdateStateProvider = StateProvider<String?>((ref) {
  return null;
});

final versionProvider = FutureProvider<String>((ref) async {
  var needUpdate = await CheckUpdate.needUpdateCheck();
  ref.read(needUpdateStateProvider.notifier).update((state) => needUpdate);
  return ConstList.version;
});

final pathListSelectedProvider = StateProvider<int>((ref) => -1);
final pathListFileProvider = StateProvider<PlatformFile?>((ref) => null);

final loadProjectStateProvider = StateProvider<String>((ref) => '');

@riverpod
class DevicePreferenceState extends _$DevicePreferenceState {
  @override
  Map<String, dynamic> build() {
    return DevicePreference().data;
  }

  void update(String name, dynamic value) {
    DevicePreference().data[name] = value;
    state = Map.from(DevicePreference().data);
    DevicePreference().save();
  }
}

@riverpod
class FrequentlyUsedPath extends _$FrequentlyUsedPath {
  @override
  List<String> build() {
    return ref.watch(devicePreferenceStateProvider)['cyoap_frequent_path'];
  }

  void addPath(String newString) {
    state = [...state, newString];
    ref
        .read(devicePreferenceStateProvider.notifier)
        .update('cyoap_frequent_path', state);
  }

  void deletePath(int index) {
    state.removeAt(index);
    state = [...state];
    ref
        .read(devicePreferenceStateProvider.notifier)
        .update('cyoap_frequent_path', state);
  }

  Future<bool> addDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      return false;
    }
    addPath(selectedDirectory);
    return true;
  }

  Future<int> addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip', 'json'],
    );
    if (result == null) return -1;

    var data = result.files.single;
    if (ConstList.isWeb()) {
      addPath(data.name);
      ref.read(pathListFileProvider.notifier).state = data;
    } else {
      addPath(data.path!);
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
        deletePath(index);
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
      DevicePreferenceUtil().removeFolder(state[index]);
    }
    deletePath(index);
  }

  set select(int index) {
    if (index == ref.read(pathListSelectedProvider)) {
      ref.read(pathListSelectedProvider.notifier).state = -1;
    } else {
      ref.read(pathListSelectedProvider.notifier).state = index;
    }
  }
}
