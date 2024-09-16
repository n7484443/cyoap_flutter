import 'dart:async';

import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_start.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../main.dart';
import '../util/platform_specified_util/platform_specified.dart';

part 'vm_global_setting.g.dart';

@riverpod
class SaveAsWebp extends _$SaveAsWebp {
  @override
  bool build() {
    var data = ref.watch(devicePreferenceStateProvider)['save_as_webp'];
    PlatformUtil().platform.webpConverter.saveAsWebp = data;
    return data;
  }

  void rev() {
    PlatformUtil().platform.webpConverter.saveAsWebp = !state;
    ref
        .read(devicePreferenceStateProvider.notifier)
        .update('save_as_webp', !state);
  }
}

@riverpod
class ForceWide extends _$ForceWide {
  @override
  bool build() {
    var data = ref.watch(devicePreferenceStateProvider)['force_wide'];
    return data;
  }

  void rev() {
    ref
        .read(devicePreferenceStateProvider.notifier)
        .update('force_wide', !state);
  }
}

@riverpod
class ClipboardMaximumCapacity extends _$ClipboardMaximumCapacity {
  @override
  int build() {
    return ref
        .watch(devicePreferenceStateProvider)['clipboard_maximum_capacity'];
  }

  void setVariable(int value) {
    ref
        .read(devicePreferenceStateProvider.notifier)
        .update('clipboard_maximum_capacity', value);
  }
}

@riverpod
class BackupFrequency extends _$BackupFrequency {
  @override
  int build() {
    return ref.watch(devicePreferenceStateProvider)['backup_frequency'];
  }

  void setVariable(int value) {
    ref
        .read(devicePreferenceStateProvider.notifier)
        .update('backup_frequency', value);
  }
}

@riverpod
class BackupTimer extends _$BackupTimer {
  @override
  Timer? build() {
    ref.keepAlive();
    return null;
  }

  void start() {
    print("Start Backup");
    if (getPlatformFileSystem.openAsFile) {
      return;
    }
    int min = ref.read(backupFrequencyProvider);
    state = Timer.periodic(Duration(minutes: min), (timer) {
      backup();
    });
  }

  void stop() {
    print("Stop Backup");
    state?.cancel();
  }

  void backup() {
    print("Backup");
    getPlatformFileSystem.saveBackup();
  }
}

@riverpod
int maximumSize(MaximumSizeRef ref) {
  if (ConstList.isMobile()) {
    return ref.watch(forceWideProvider) ? 12 : 6;
  }
  return 12;
}
