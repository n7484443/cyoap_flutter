import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../main.dart';
import '../model/device_preference.dart';
import '../util/platform_specified_util/webp_converter.dart';

part 'vm_global_setting.g.dart';

@riverpod
class SaveAsWebp extends _$SaveAsWebp {
  @override
  FutureOr<bool> build() async {
    var out = await DevicePreference().getVariable('saveAsWebp');
    WebpConverter.instance?.saveAsWebp = out;
    return out;
  }

  Future<void> setVariable(bool value) async {
    state = AsyncData(value);
    WebpConverter.instance?.saveAsWebp = value;
    await DevicePreference().setVariable('saveAsWebp', value);
  }
}

final forceWideProvider =
    StateNotifierProvider<ForceWideStateNotifier, bool>((ref) {
  ref.listenSelf((previous, next) {
    DevicePreference().setVariable('forceWide', next);
  });
  return ForceWideStateNotifier();
});

class ForceWideStateNotifier extends StateNotifier<bool> {
  ForceWideStateNotifier() : super(true) {
    init();
  }

  void init() async {
    state = await DevicePreference()
        .getVariable('forceWide', isEmpty: !ConstList.isMobile());
  }

  void rev() {
    state = !state;
  }
}

final maximumSizeProvider = Provider<int>((ref) {
  if (ConstList.isMobile()) {
    return ref.watch(forceWideProvider) ? 12 : 6;
  }
  return 12;
});
