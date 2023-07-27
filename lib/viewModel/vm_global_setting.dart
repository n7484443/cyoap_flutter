import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../model/device_preference.dart';
import '../util/platform_specified_util/webp_converter.dart';

final saveAsWebpFutureProvider = FutureProvider<bool>((ref) async {
  var out = await DevicePreference().getVariable('saveAsWebp');
  ref.read(saveAsWebpProvider.notifier).state = out;
  return out;
});

final saveAsWebpProvider = StateProvider<bool>((ref) {
  ref.listenSelf((previous, next) {
    DevicePreference().setVariable('saveAsWebp', next);
    WebpConverter.instance?.saveAsWebp = next;
  });
  return true;
});

final forceWideProvider = StateNotifierProvider<ForceWideStateNotifier, bool>((ref) {
  ref.listenSelf((previous, next) {
    DevicePreference().setVariable('forceWide', next);
  });
  return ForceWideStateNotifier();
});

class ForceWideStateNotifier extends StateNotifier<bool>{
  ForceWideStateNotifier() : super(true){
    init();
  }

  void init() async{
    state = await DevicePreference().getVariable('forceWide', isEmpty: !ConstList.isMobile());
  }

  void rev(){
    state = !state;
  }
}

final maximumSizeProvider = Provider<int>((ref) {
  if(ConstList.isMobile()) {
    return ref.watch(forceWideProvider) ? 12 : 6;
  }
  return 12;
});