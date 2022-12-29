import 'package:cyoap_core/preset/choice_node_preset.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/platform_system.dart';
import '../vm_choice_node.dart';
import '../vm_draggable_nested_map.dart';

final presetCurrentEditIndexProvider =
StateProvider.autoDispose<int>((ref) => 0);
final presetCurrentEditProvider =
Provider.autoDispose<ChoiceNodeDesignPreset>((ref) {
  var list = ref.watch(presetListProvider);
  var index = ref.watch(presetCurrentEditIndexProvider);
  if (index >= list.length) {
    return const ChoiceNodeDesignPreset(name: 'default');
  }
  return list[index];
});

final presetCurrentEditElevationProvider =
Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text: ref.watch(presetCurrentEditProvider).elevation.toString());
  controller.addListener(() {
    EasyDebounce.debounce('Elevation Input', const Duration(milliseconds: 500),
            () {
          ref.read(presetListProvider.notifier).updateIndex(
              ref.watch(presetCurrentEditIndexProvider),
              ref
                  .read(presetCurrentEditProvider)
                  .copyWith(elevation: double.tryParse(controller.text) ?? 0.0));
        });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Elevation Input');
    controller.dispose();
  });
  return controller;
});
final presetTestSelectProvider = StateProvider<bool>((ref) => false);

final presetProvider = Provider.family
    .autoDispose<ChoiceNodeDesignPreset, String>((ref, presetName) => ref
    .watch(presetListProvider)
    .firstWhere((element) => element.name == presetName,
    orElse: () => const ChoiceNodeDesignPreset(name: 'default')));

final presetCurrentEditRoundProvider =
Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text: ref.watch(presetCurrentEditProvider).round.toString());
  controller.addListener(() {
    EasyDebounce.debounce('Round Input', const Duration(milliseconds: 500), () {
      ref.read(presetListProvider.notifier).updateIndex(
          ref.watch(presetCurrentEditIndexProvider),
          ref
              .read(presetCurrentEditProvider)
              .copyWith(round: double.tryParse(controller.text) ?? 0.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Round Input');
    controller.dispose();
  });
  return controller;
});

final presetListProvider = StateNotifierProvider.autoDispose<PresetListNotifier,
    List<ChoiceNodeDesignPreset>>((ref) {
  ref.listenSelf((previous, next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(choiceNodePresetList: next);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return PresetListNotifier(ref);
});

class PresetListNotifier extends StateNotifier<List<ChoiceNodeDesignPreset>> {
  Ref ref;

  PresetListNotifier(this.ref)
      : super([...getPlatform.designSetting.choiceNodePresetList]);

  void rename(int index, String after) {
    var before = state[index].name;
    updateIndex(index, state[index].copyWith(name: after));
    getPlatform.updatePresetNameAll(before, after);
    ref.invalidate(choiceNodeDesignSettingProvider);
  }

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
    if (state.length >= 2) {
      state.removeWhere((preset) => preset.name == name);
      state = [...state];
      getPlatform.updatePresetNameAll(name, state.first.name);
    }
  }

  void deleteIndex(int index) {
    if (state.length >= 2) {
      var removed = state.removeAt(index);
      state = [...state];
      getPlatform.updatePresetNameAll(removed.name, state.first.name);
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
