import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPresetTab = StateProvider<int>((ref) {
  ref.listenSelf((previous, next) {
    ref.read(currentPresetNameProvider.notifier).state = "default";
  });
  return 0;
});

final currentPresetNameProvider = StateProvider.autoDispose<String>((ref) => "default");
