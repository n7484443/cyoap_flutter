import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_core/preset/choice_node_preset.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/image_db.dart';

final variableFontProvider = StateProvider.autoDispose<String>((ref) {
  ref.listenSelf((String? previous, String next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(variableFont: next);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return getPlatform.designSetting.variableFont;
});
final colorBackgroundProvider = StateProvider.autoDispose<Color>((ref) {
  ref.listenSelf((previous, Color next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(colorBackground: next.value);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return Color(getPlatform.designSetting.colorBackground);
});

final colorSelectProvider = StateProvider.autoDispose<int>((ref) => 0);

final backgroundProvider = StateProvider.autoDispose<String?>((ref) {
  ref.listenSelf((previous, next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(backgroundImage: next);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return getPlatform.designSetting.backgroundImage;
});
final backgroundCurrentStateProvider = StateProvider.autoDispose<int>((ref) {
  var backgroundName = ref.watch(backgroundProvider);
  if (backgroundName == null) return -1;
  return ImageDB().getImageIndex(backgroundName);
});
final backgroundAttributeProvider =
    StateProvider.autoDispose<ImageAttribute>((ref) {
  ref.listenSelf((previous, ImageAttribute next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(backgroundAttribute: next);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return getPlatform.designSetting.backgroundAttribute;
});

final marginVerticalProvider = StateProvider.autoDispose<double>((ref) {
  ref.listenSelf((previous, double next) {
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(marginVertical: next);
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return getPlatform.designSetting.marginVertical;
});

final presetTestSelectProvider = StateProvider<bool>((ref) => false);

final presetProvider = Provider.family
    .autoDispose<ChoiceNodeDesignPreset, String>((ref, presetName) => ref
        .watch(presetListProvider)
        .firstWhere((element) => element.name == presetName,
            orElse: () => const ChoiceNodeDesignPreset(name: 'default')));

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
