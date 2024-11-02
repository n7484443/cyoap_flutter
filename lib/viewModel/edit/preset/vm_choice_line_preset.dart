import 'package:cyoap_core/preset/line_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice.dart';
import 'package:cyoap_flutter/viewModel/edit/preset/vm_preset.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/platform_system.dart';
import '../../../util/easy_clone.dart';
import '../vm_draggable_nested_map.dart';

final choiceLinePresetCurrentEditProvider = Provider.autoDispose<ChoiceLineDesignPreset?>((ref) {
  var name = ref.watch(currentPresetNameProvider);
  return ref.watch(choiceLinePresetProvider(name));
});

final choiceLinePresetProvider = Provider.family.autoDispose<ChoiceLineDesignPreset, String>((ref, presetName){
  var map = ref.watch(choiceLinePresetListProvider);
  return map[presetName] ?? map["default"] ?? const ChoiceLineDesignPreset();
});

final choiceLinePresetListProvider = StateNotifierProvider.autoDispose<ChoiceLinePresetListNotifier, Map<String, ChoiceLineDesignPreset>>((ref) {
  ref.listenSelf((previous, next) {
    if (previous == null || previous == next) return;
    getPlatform.designSetting = getPlatform.designSetting.copyWith(choiceLinePresetMap: next);
    ref.read(currentProjectChangedProvider.notifier).changed(needUpdateCode: false);
  });
  return ChoiceLinePresetListNotifier(ref);
});

class ChoiceLinePresetListNotifier extends StateNotifier<Map<String, ChoiceLineDesignPreset>> {
  Ref ref;

  ChoiceLinePresetListNotifier(this.ref) : super({...getPlatform.designSetting.choiceLinePresetMap});

  void rename(String before, String after) {
    var removed = state.remove(before);
    if (removed != null) {
      state[after] = removed;
      state = {...state};
    }
    getPlatform.updateLinePresetNameAll(before, after);
    ref.read(currentChoicePageProvider.notifier).refresh();
  }

  void create() {
    var name = 'preset_new'.i18n;
    var rename = name;
    var i = 0;
    while (state[rename] != null) {
      rename = '$name $i';
      i++;
    }
    state = {...state, rename: const ChoiceLineDesignPreset()};
  }

  void delete(String name) {
    if (state.length >= 2) {
      state.remove(name);
      state = {...state};
      getPlatform.updateLinePresetNameAll(name, "default");
    }
  }

  void clone(String name) {
    var original = state[name]!;
    var newName = getCloneName(name, (considerName) {
      return state.containsKey(considerName);
    });
    var clone = original.copyWith();
    state = {...state, newName: clone};
  }

  void update(String name, ChoiceLineDesignPreset newValue) {
    state[name] = newValue;
    state = {...state};
  }
}
