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
    .autoDispose<ChoiceNodeDesignPreset, String>((ref, presetName) => ref
        .watch(presetListProvider)
        .firstWhere((element) => element.name == presetName,
            orElse: () => const ChoiceNodeDesignPreset(name: 'default')));

final presetCurrentEditIndexProvider = StateProvider<int>((ref) => 0);
final presetCurrentEditProvider = Provider<ChoiceNodeDesignPreset>((ref){
  var list = ref.watch(presetListProvider);
  var index = ref.watch(presetCurrentEditIndexProvider);
  if (index >= list.length) {
    return const ChoiceNodeDesignPreset(name: 'default');
  }
  return list[index];
});

final presetListProvider =
    StateNotifierProvider<PresetListNotifier, List<ChoiceNodeDesignPreset>>(
        (ref) => PresetListNotifier());

class PresetListNotifier extends StateNotifier<List<ChoiceNodeDesignPreset>> {
  PresetListNotifier()
      : super([...getPlatform.designSetting.choiceNodePresetList]);

  void updateName(String name, ChoiceNodeDesignPreset preset) {
    int index = state.indexWhere((preset) => preset.name == name);
    updateIndex(index, preset);
  }

  void updateIndex(int index, ChoiceNodeDesignPreset preset) {
    state.removeAt(index);
    state.insert(index, preset);
    state = [...state];
  }

  void create() {
    var name = '새 프리셋';
    var rename = name;
    var i = 0;
    while (state.any((preset) => preset.name == rename)) {
      rename = '$name $i';
      i++;
    }
    state = [...state, ChoiceNodeDesignPreset(name: rename)];
  }

  void deleteName(String name) {
    state.removeWhere((preset) => preset.name == name);
    state = [...state];
  }

  void deleteIndex(int index) {
    state.removeAt(index);
    state = [...state];
  }

  void reorder(int oldIndex, int newIndex) {
    if(oldIndex < newIndex){
      newIndex -= 1;
    }
    var preset = state.removeAt(oldIndex);
    state.insert(newIndex, preset);
    state = [...state];
  }
}
