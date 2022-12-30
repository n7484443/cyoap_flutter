import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPresetTab = StateProvider<int>((ref){
  ref.listenSelf((previous, next) {
    ref.read(currentPresetIndexProvider.notifier).state = 0;
  });
  return 0;
});

final currentPresetIndexProvider =
StateProvider.autoDispose<int>((ref) => 0);