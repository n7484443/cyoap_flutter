import 'dart:ui';

import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_core/preset/choice_node_preset.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/image_db.dart';

final variableFontProvider = StateProvider.autoDispose<String>(
    (ref) => getPlatform.designSetting.variableFont);
final colorBackgroundProvider = StateProvider.autoDispose<Color>(
    (ref) => Color(getPlatform.designSetting.colorBackground));

final colorSelectProvider = StateProvider.autoDispose<int>((ref) => 0);

final backgroundProvider = StateProvider.autoDispose<String?>(
    (ref) => getPlatform.designSetting.backgroundImage);
final backgroundCurrentStateProvider = StateProvider.autoDispose<int>((ref) {
  var backgroundName = ref.watch(backgroundProvider);
  if (backgroundName == null) return -1;
  return ImageDB().getImageIndex(backgroundName);
});
final backgroundAttributeProvider = StateProvider.autoDispose<ImageAttribute>(
    (ref) => getPlatform.designSetting.backgroundAttribute);

final marginVerticalProvider = StateProvider.autoDispose<double>(
    (ref) => getPlatform.designSetting.marginVertical);

final presetProvider = Provider.family
    .autoDispose<ChoiceNodeDesignPreset, String>(
        (ref, presetName) => ref.watch(presetListProvider)[presetName] ?? ChoiceNodeDesignPreset());

final presetCurrentEditNameProvider = StateProvider<String>((ref) => 'default');
final presetCurrentEditProvider = Provider<ChoiceNodeDesignPreset>((ref) =>
    ref.watch(presetListProvider)[ref.watch(presetCurrentEditNameProvider)]!);

final presetListProvider = StateNotifierProvider<PresetListNotifier,
    Map<String, ChoiceNodeDesignPreset>>((ref) => PresetListNotifier());

class PresetListNotifier
    extends StateNotifier<Map<String, ChoiceNodeDesignPreset>> {
  PresetListNotifier() : super({'default' : ChoiceNodeDesignPreset()});

  void update(String name, ChoiceNodeDesignPreset preset) {
    state.remove(name);
    state = {...state, name: preset};
  }
}
