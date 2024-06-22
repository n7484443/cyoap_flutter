import 'package:cyoap_flutter/viewModel/vm_start.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../main.dart';
import '../util/platform_specified_util/webp_converter.dart';

part 'vm_global_setting.g.dart';

@riverpod
class SaveAsWebp extends _$SaveAsWebp {
  @override
  bool build() {
    var data = ref.watch(devicePreferenceStateProvider)['saveAsWebp'];
    WebpConverter.instance?.saveAsWebp = data;
    return data;
  }

  void rev() {
    WebpConverter.instance?.saveAsWebp = !state;
    ref.read(devicePreferenceStateProvider.notifier).update('saveAsWebp', !state);
  }
}

@riverpod
class ForceWide extends _$ForceWide {
  @override
  bool build() {
    var data = ref.watch(devicePreferenceStateProvider)['forceWide'];
    return data;
  }

  void rev() {
    ref.read(devicePreferenceStateProvider.notifier).update('forceWide', !state);
  }
}

@riverpod
class ClipboardMaximumCapacity extends _$ClipboardMaximumCapacity {
  @override
  int build() {
    return ref.watch(devicePreferenceStateProvider)['clipboardMaximumCapacity'];
  }

  void setVariable(int value) {
    ref.read(devicePreferenceStateProvider.notifier).update('clipboardMaximumCapacity', value);
  }
}

@riverpod
int maximumSize(MaximumSizeRef ref) {
  if (ConstList.isMobile()) {
    return ref.watch(forceWideProvider) ? 12 : 6;
  }
  return 12;
}