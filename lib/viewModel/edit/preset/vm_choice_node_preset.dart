import 'package:cyoap_core/preset/node_preset.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/viewModel/edit/preset/vm_preset.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../main.dart';
import '../../../model/platform_system.dart';
import '../../../util/easy_clone.dart';
import '../../choice/vm_choice_node.dart';
import '../vm_draggable_nested_map.dart';

part 'vm_choice_node_preset.g.dart';

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

@riverpod
TextEditingController choiceNodePresetDistance(ChoiceNodePresetDistanceRef ref,
    {required String position}) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  EdgeValue getValue() {
    return ref.read(choiceNodePresetCurrentEditProvider).padding!;
  }

  var controller =
      TextEditingController(text: getValue().getValue(position).toString());
  controller.addListener(() {
    EasyDebounce.debounce(
        'Choice Distance Input $position', ConstList.debounceDuration, () {
      EdgeValue distance = getValue();
      Map<String, double> values = {
        'top': distance.top,
        'right': distance.right,
        'bottom': distance.bottom,
        'left': distance.left
      };
      values[position] = double.tryParse(controller.text) ?? 0.0;
      ChoiceNodeDesignPreset newValue =
          ref.read(choiceNodePresetCurrentEditProvider).copyWith.padding!(
              top: values['top']!,
              right: values['right']!,
              bottom: values['bottom']!,
              left: values['left']!);
      ref
          .read(choiceNodePresetListProvider.notifier)
          .updateIndex(ref.watch(currentPresetIndexProvider), newValue);
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Choice Distance Input $position');
    controller.dispose();
  });
  return controller;
}

@riverpod
TextEditingController choiceNodePresetRound(ChoiceNodePresetRoundRef ref,
    {required String position}) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  VertexValue getValue() {
    return ref.read(choiceNodePresetCurrentEditProvider).round!;
  }

  var controller =
      TextEditingController(text: getValue().getValue(position).toString());
  controller.addListener(() {
    EasyDebounce.debounce(
        'Choice Round Input $position', ConstList.debounceDuration, () {
      VertexValue round = getValue();
      Map<String, double> values = {
        'topLeft': round.topLeft,
        'topRight': round.topRight,
        'bottomLeft': round.bottomLeft,
        'bottomRight': round.bottomRight
      };
      values[position] = double.tryParse(controller.text) ?? 0.0;
      ChoiceNodeDesignPreset newValue =
          ref.read(choiceNodePresetCurrentEditProvider).copyWith.round!(
              topLeft: values['topLeft']!,
              topRight: values['topRight']!,
              bottomLeft: values['bottomLeft']!,
              bottomRight: values['bottomRight']!);
      ref
          .read(choiceNodePresetListProvider.notifier)
          .updateIndex(ref.watch(currentPresetIndexProvider), newValue);
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Choice Round Input $position');
    controller.dispose();
  });
  return controller;
}

@riverpod
TextEditingController choiceNodePresetOutlineDistance(
  ChoiceNodePresetOutlineDistanceRef ref, {
  required String position,
  required bool isSelected,
}) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  EdgeValue getValue() {
    if (isSelected) {
      return ref
          .read(choiceNodePresetCurrentEditProvider)
          .selectOutlineOption!
          .distance;
    } else {
      return ref
          .read(choiceNodePresetCurrentEditProvider)
          .defaultOutlineOption!
          .distance;
    }
  }

  var controller =
      TextEditingController(text: getValue().getValue(position).toString());
  controller.addListener(() {
    EasyDebounce.debounce('Outline Distance Input $position $isSelected',
        ConstList.debounceDuration, () {
      EdgeValue distance = getValue();
      Map<String, double> values = {
        'top': distance.top,
        'right': distance.right,
        'bottom': distance.bottom,
        'left': distance.left
      };
      values[position] = double.tryParse(controller.text) ?? 0.0;
      ChoiceNodeDesignPreset? newValue;
      if (isSelected) {
        newValue = ref
            .read(choiceNodePresetCurrentEditProvider)
            .copyWith
            .selectOutlineOption
            ?.distance(
                top: values['top']!,
                right: values['right']!,
                bottom: values['bottom']!,
                left: values['left']!);
      } else {
        newValue = ref
            .read(choiceNodePresetCurrentEditProvider)
            .copyWith
            .defaultOutlineOption
            ?.distance(
                top: values['top']!,
                right: values['right']!,
                bottom: values['bottom']!,
                left: values['left']!);
      }
      ref
          .read(choiceNodePresetListProvider.notifier)
          .updateIndex(ref.watch(currentPresetIndexProvider), newValue!);
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Outline Distance Input $position $isSelected');
    controller.dispose();
  });
  return controller;
}

@riverpod
TextEditingController choiceNodePresetOutlineRound(
  ChoiceNodePresetOutlineRoundRef ref, {
  required String position,
  required bool isSelected,
}) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  VertexValue getValue() {
    if (isSelected) {
      return ref
          .read(choiceNodePresetCurrentEditProvider)
          .selectOutlineOption!
          .round;
    } else {
      return ref
          .read(choiceNodePresetCurrentEditProvider)
          .defaultOutlineOption!
          .round;
    }
  }

  var controller =
      TextEditingController(text: getValue().getValue(position).toString());
  controller.addListener(() {
    EasyDebounce.debounce(
        'Outline Round Input $position $isSelected', ConstList.debounceDuration,
        () {
      VertexValue round = getValue();
      Map<String, double> values = {
        'topLeft': round.topLeft,
        'topRight': round.topRight,
        'bottomLeft': round.bottomLeft,
        'bottomRight': round.bottomRight
      };
      values[position] = double.tryParse(controller.text) ?? 0.0;
      ChoiceNodeDesignPreset? newValue;
      if (isSelected) {
        newValue = ref
            .read(choiceNodePresetCurrentEditProvider)
            .copyWith
            .selectOutlineOption
            ?.round(
                topLeft: values['topLeft']!,
                topRight: values['topRight']!,
                bottomLeft: values['bottomLeft']!,
                bottomRight: values['bottomRight']!);
      } else {
        newValue = ref
            .read(choiceNodePresetCurrentEditProvider)
            .copyWith
            .defaultOutlineOption
            ?.round(
                topLeft: values['topLeft']!,
                topRight: values['topRight']!,
                bottomLeft: values['bottomLeft']!,
                bottomRight: values['bottomRight']!);
      }
      ref
          .read(choiceNodePresetListProvider.notifier)
          .updateIndex(ref.watch(currentPresetIndexProvider), newValue!);
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Outline Round Input $position $isSelected');
    controller.dispose();
  });
  return controller;
}

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

@riverpod
TextEditingController choiceNodePresetImageMaxHeightRatio(ChoiceNodePresetImageMaxHeightRatioRef ref) {
  ref.listen(currentPresetIndexProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(
      text: ref.read(choiceNodePresetCurrentEditProvider).imageMaxHeightRatio.toString());
  controller.addListener(() {
    EasyDebounce.debounce('ImageMaxHeightRatio Input', ConstList.debounceDuration, () {
      ref.read(choiceNodePresetListProvider.notifier).updateIndex(
          ref.watch(currentPresetIndexProvider),
          ref
              .read(choiceNodePresetCurrentEditProvider)
              .copyWith(imageMaxHeightRatio: double.tryParse(controller.text)?.clamp(0.01, 5.0) ?? 1.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('ImageMaxHeightRatio Input');
    controller.dispose();
  });
  return controller;
}

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

// final choiceNodePresetCurrentEditRoundProvider =
//     Provider.autoDispose.family<TextEditingController, String>((ref, key) {
//   ref.listen(currentPresetIndexProvider, (previous, next) {
//     ref.invalidateSelf();
//   });
//   var controller = TextEditingController(
//       text: ref
//           .read(choiceNodePresetCurrentEditProvider)
//           .round?.getValue(key)
//           .toString());
//   controller.addListener(() {
//     EasyDebounce.debounce('Round Input $key', ConstList.debounceDuration, () {
//       var round = double.tryParse(controller.text) ?? 0.0;
//       var currentRound = [
//         ...ref.read(choiceNodePresetCurrentEditProvider).roundEdge!
//       ];
//       currentRound[index] = round;
//       ref.read(choiceNodePresetListProvider.notifier).updateIndex(
//           ref.watch(currentPresetIndexProvider),
//           ref
//               .read(choiceNodePresetCurrentEditProvider)
//               .copyWith(roundEdge: currentRound));
//     });
//   });
//   ref.onDispose(() {
//     EasyDebounce.cancel('Round Input $key');
//     controller.dispose();
//   });
//   return controller;
// });
//
// final choiceNodePresetCurrentEditPaddingProvider =
//     Provider.autoDispose<TextEditingController>((ref) {
//   ref.listen(currentPresetIndexProvider, (previous, next) {
//     ref.invalidateSelf();
//   });
//   var controller = TextEditingController(
//       text: ref
//           .read(choiceNodePresetCurrentEditProvider)
//           .paddingAround![0]
//           .toString());
//   controller.addListener(() {
//     EasyDebounce.debounce('Padding Input', ConstList.debounceDuration, () {
//       var padding = double.tryParse(controller.text) ?? 0.0;
//       ref.read(choiceNodePresetListProvider.notifier).updateIndex(
//           ref.watch(currentPresetIndexProvider),
//           ref
//               .read(choiceNodePresetCurrentEditProvider)
//               .copyWith(paddingAround: [padding, padding, padding, padding]));
//     });
//   });
//   ref.onDispose(() {
//     EasyDebounce.cancel('Padding Input');
//     controller.dispose();
//   });
//   return controller;
// });

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
