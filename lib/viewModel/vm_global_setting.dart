import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/device_preference.dart';
import '../util/platform_specified_util/webp_converter.dart';

final saveAsWebpFutureProvider = FutureProvider<bool>((ref) async {
  var out = await DevicePreference().getSaveAsWebp();
  ref.read(saveAsWebpProvider.notifier).state = out;
  return out;
});

final saveAsWebpProvider = StateProvider<bool>((ref) {
  ref.listenSelf((previous, next) {
    DevicePreference().setSaveAsWebp(next);
    WebpConverter.instance?.saveAsWebp = next;
  });
  return true;
});
