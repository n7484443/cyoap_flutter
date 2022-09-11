import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/opening_file_folder.dart';
import '../util/platform_specified_util/webp_converter.dart';

final saveAsWebpFutureProvider = FutureProvider<bool>((ref) async {
  var out = await ProjectPath().getSaveAsWebp();
  ref.read(saveAsWebpProvider.notifier).state = out;
  ref.listen(saveAsWebpProvider, (previous, bool next) {
    ProjectPath().setSaveAsWebp(next);
    WebpConverter.instance?.saveAsWebp = next;
  });
  return out;
});

final saveAsWebpProvider = StateProvider<bool>((ref) => true);
