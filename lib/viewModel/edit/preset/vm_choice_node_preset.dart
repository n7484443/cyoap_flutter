import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/viewModel/edit/preset/vm_preset.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../main.dart';
import '../../../model/platform_system.dart';
import '../../../util/easy_clone.dart';
import '../../choice/vm_choice_node.dart';
import '../vm_draggable_nested_map.dart';

final choiceNodePresetCurrentEditProvider =
    Provider.autoDispose<ChoiceNodeDesignPreset>((ref) {
  var list = ref.watch(choiceNodePresetListProvider);
  var index = ref.watch(currentPresetIndexProvider);
  if (index >= list.length) {
    return const ChoiceNodeDesignPreset(name: 'default');
  }
  return list[index];
});

final choiceNodePresetCurrentTabProvider =
    StateProvider.autoDispose<int>((ref) {
  return 0;
});

final choiceNodePresetCurrentEditOutlinePaddingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(
      text: ref
          .read(choiceNodePresetCurrentEditProvider)
          .defaultOutlineOption!
          .outlinePadding
          .toString());
  controller.addListener(() {
    EasyDebounce.debounce('Outline Padding Input', ConstList.debounceDuration,
        () {
      ref.read(choiceNodePresetListProvider.notifier).updateIndex(
          ref.watch(currentPresetIndexProvider),
          ref
                  .read(choiceNodePresetCurrentEditProvider)
                  .copyWith
                  .defaultOutlineOption!(
              outlinePadding: double.tryParse(controller.text) ?? 0.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Outline Padding Input');
    controller.dispose();
  });
  return controller;
});

final choiceNodePresetSelectedEditOutlinePaddingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(
      text: ref
          .read(choiceNodePresetCurrentEditProvider)
          .selectOutlineOption!
          .outlinePadding
          .toString());
  controller.addListener(() {
    EasyDebounce.debounce(
        'Outline Padding Input Selected', ConstList.debounceDuration, () {
      ref.read(choiceNodePresetListProvider.notifier).updateIndex(
          ref.watch(currentPresetIndexProvider),
          ref
                  .read(choiceNodePresetCurrentEditProvider)
                  .copyWith
                  .selectOutlineOption!(
              outlinePadding: double.tryParse(controller.text) ?? 0.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Outline Padding Input Selected');
    controller.dispose();
  });
  return controller;
});

final choiceNodePresetCurrentEditOutlineWidthProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(
      text: ref
          .read(choiceNodePresetCurrentEditProvider)
          .defaultOutlineOption!
          .outlineWidth
          .toString());
  controller.addListener(() {
    EasyDebounce.debounce('Outline Width Input', ConstList.debounceDuration,
        () {
      ref.read(choiceNodePresetListProvider.notifier).updateIndex(
          ref.watch(currentPresetIndexProvider),
          ref
                  .read(choiceNodePresetCurrentEditProvider)
                  .copyWith
                  .defaultOutlineOption!(
              outlineWidth: double.tryParse(controller.text) ?? 0.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Outline Width Input');
    controller.dispose();
  });
  return controller;
});

final choiceNodePresetSelectedEditOutlineWidthProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(
      text: ref
          .read(choiceNodePresetCurrentEditProvider)
          .selectOutlineOption!
          .outlineWidth
          .toString());
  controller.addListener(() {
    EasyDebounce.debounce(
        'Outline Width Input Selected', ConstList.debounceDuration, () {
      ref.read(choiceNodePresetListProvider.notifier).updateIndex(
          ref.watch(currentPresetIndexProvider),
          ref
                  .read(choiceNodePresetCurrentEditProvider)
                  .copyWith
                  .selectOutlineOption!(
              outlineWidth: double.tryParse(controller.text) ?? 0.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Outline Width Input Selected');
    controller.dispose();
  });
  return controller;
});

final choiceNodePresetCurrentEditElevationProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(
      text: ref.read(choiceNodePresetCurrentEditProvider).elevation.toString());
  controller.addListener(() {
    EasyDebounce.debounce('Elevation Input', ConstList.debounceDuration, () {
      ref.read(choiceNodePresetListProvider.notifier).updateIndex(
          ref.watch(currentPresetIndexProvider),
          ref
              .read(choiceNodePresetCurrentEditProvider)
              .copyWith(elevation: double.tryParse(controller.text) ?? 0.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Elevation Input');
    controller.dispose();
  });
  return controller;
});
final choiceNodePresetTestSelectProvider = StateProvider<bool>((ref) => false);

final choiceNodePresetProvider = Provider.family
    .autoDispose<ChoiceNodeDesignPreset, String>((ref, presetName) => ref
        .watch(choiceNodePresetListProvider)
        .firstWhere((element) => element.name == presetName,
            orElse: () => const ChoiceNodeDesignPreset(name: 'default')));

final choiceNodePresetCurrentEditRoundProvider =
    Provider.autoDispose.family<TextEditingController, int>((ref, index) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(
      text: ref
          .read(choiceNodePresetCurrentEditProvider)
          .roundEdge![index]
          .toString());
  controller.addListener(() {
    EasyDebounce.debounce('Round Input $index', ConstList.debounceDuration, () {
      var round = double.tryParse(controller.text) ?? 0.0;
      var currentRound = [
        ...ref.read(choiceNodePresetCurrentEditProvider).roundEdge!
      ];
      currentRound[index] = round;
      ref.read(choiceNodePresetListProvider.notifier).updateIndex(
          ref.watch(currentPresetIndexProvider),
          ref
              .read(choiceNodePresetCurrentEditProvider)
              .copyWith(roundEdge: currentRound));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Round Input $index');
    controller.dispose();
  });
  return controller;
});

final choiceNodePresetCurrentEditPaddingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(
      text: ref
          .read(choiceNodePresetCurrentEditProvider)
          .paddingAround![0]
          .toString());
  controller.addListener(() {
    EasyDebounce.debounce('Padding Input', ConstList.debounceDuration, () {
      var padding = double.tryParse(controller.text) ?? 0.0;
      ref.read(choiceNodePresetListProvider.notifier).updateIndex(
          ref.watch(currentPresetIndexProvider),
          ref
              .read(choiceNodePresetCurrentEditProvider)
              .copyWith(paddingAround: [padding, padding, padding, padding]));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Padding Input');
    controller.dispose();
  });
  return controller;
});

final choiceNodePresetListProvider = StateNotifierProvider.autoDispose<
    ChoiceNodePresetListNotifier, List<ChoiceNodeDesignPreset>>((ref) {
  ref.listenSelf((previous, next) {
    if (previous == null || previous == next) return;
    getPlatform.designSetting =
        getPlatform.designSetting.copyWith(choiceNodePresetList: next);
    ref
        .read(currentProjectChangedProvider.notifier)
        .changed(needUpdateCode: false);
  });
  return ChoiceNodePresetListNotifier(ref);
});

class ChoiceNodePresetListNotifier
    extends StateNotifier<List<ChoiceNodeDesignPreset>> {
  Ref ref;

  ChoiceNodePresetListNotifier(this.ref)
      : super([...getPlatform.designSetting.choiceNodePresetList]);

  void rename(int index, String after) {
    var before = state[index].name;
    updateIndex(index, state[index].copyWith(name: after));
    getPlatform.updateNodePresetNameAll(before!, after);
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
    var name = 'preset_new'.i18n;
    var rename = getCloneName(name, (considerName) {
      return state.any((preset) => preset.name == considerName);
    });
    state = [...state, ChoiceNodeDesignPreset(name: rename)];
  }

  void deleteName(String name) {
    if (state.length >= 2) {
      state.removeWhere((preset) => preset.name == name);
      state = [...state];
      getPlatform.updateNodePresetNameAll(name, state.first.name!);
    }
  }

  void deleteIndex(int index) {
    if (state.length >= 2) {
      var removed = state.removeAt(index);
      state = [...state];
      getPlatform.updateNodePresetNameAll(removed.name!, state.first.name!);
    }
  }

  void cloneIndex(index) {
    var original = state[index];
    var newName = getCloneName(original.name!, (considerName) {
      return state.any((preset) => preset.name == considerName);
    });
    var clone = original.copyWith(name: newName);
    state = [...state, clone];
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
