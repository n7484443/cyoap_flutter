import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPresetTab = StateProvider<int>((ref) => 0);

final currentPresetIndexProvider =
StateProvider.autoDispose<int>((ref) => 0);