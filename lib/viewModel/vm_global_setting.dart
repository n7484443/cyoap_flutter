import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/opening_file_folder.dart';
import '../util/platform_specified_util/webp_converter.dart';

final saveAsWebpFutureProvider = FutureProvider<bool>((ref) async {
  var out = await ProjectPath().getSaveAsWebp();
  ref.read(saveAsWebpProvider.notifier).state = out;
  return out;
});

final saveAsWebpProvider = StateProvider<bool>((ref){
  ref.listenSelf((previous, next) {
    ProjectPath().setSaveAsWebp(next);
    WebpConverter.instance?.saveAsWebp = next;
  });
  return true;
});
