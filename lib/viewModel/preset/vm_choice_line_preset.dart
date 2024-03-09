import 'package:cyoap_core/preset/line_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice.dart';
import 'package:cyoap_flutter/viewModel/preset/vm_preset.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/platform_system.dart';
import '../vm_draggable_nested_map.dart';

final choiceLinePresetCurrentEditProvider =
    Provider.autoDispose<ChoiceLineDesignPreset>((ref) {
  var list = ref.watch(choiceLinePresetListProvider);
  var index = ref.watch(currentPresetIndexProvider);
  if (index >= list.length) {
    return const ChoiceLineDesignPreset(name: 'default');
  }
  return list[index];
});

final choiceLinePresetProvider = Provider.family
    .autoDispose<ChoiceLineDesignPreset, String>((ref, presetName) => ref
        .watch(choiceLinePresetListProvider)
        .firstWhere((element) => element.name == presetName,
            orElse: () => const ChoiceLineDesignPreset(name: 'default')));

final choiceLinePresetListProvider = StateNotifierProvider.autoDispose<
    ChoiceLinePresetListNotifier, List<ChoiceLineDesignPreset>>((ref) {
  ref.listenSelf((previous, next) {
    if(previous == null || previous == next) return;
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(choiceLinePresetList: next);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return ChoiceLinePresetListNotifier(ref);
});

class ChoiceLinePresetListNotifier
    extends StateNotifier<List<ChoiceLineDesignPreset>> {
  Ref ref;

  ChoiceLinePresetListNotifier(this.ref)
      : super([...getPlatform.designSetting.choiceLinePresetList]);

  void rename(int index, String after) {
    var before = state[index].name;
    updateIndex(index, state[index].copyWith(name: after));
    getPlatform.updateLinePresetNameAll(before, after);
    ref.read(currentChoicePageProvider.notifier).refresh();
  }

  void updateName(String name, ChoiceLineDesignPreset preset) {
    int index = state.indexWhere((preset) => preset.name == name);
    updateIndex(index, preset);
  }

  void updateIndex(int index, ChoiceLineDesignPreset preset) {
    state.removeAt(index);
    state.insert(index, preset);
    state = [...state];
  }

  void create() {
    var name = 'preset_new'.i18n;
    var rename = name;
    var i = 0;
    while (state.any((preset) => preset.name == rename)) {
      rename = '$name $i';
      i++;
    }
    state = [...state, ChoiceLineDesignPreset(name: rename)];
  }

  void deleteName(String name) {
    if (state.length >= 2) {
      state.removeWhere((preset) => preset.name == name);
      state = [...state];
      getPlatform.updateLinePresetNameAll(name, state.first.name);
    }
  }

  void deleteIndex(int index) {
    if (state.length >= 2) {
      var removed = state.removeAt(index);
      state = [...state];
      getPlatform.updateLinePresetNameAll(removed.name, state.first.name);
    }
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var preset = state.removeAt(oldIndex);
    state.insert(newIndex, preset);
    state = [...state];
  }
}
