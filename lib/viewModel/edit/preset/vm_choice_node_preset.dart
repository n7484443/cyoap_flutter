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

final choiceNodePresetCurrentEditProvider = Provider.autoDispose<ChoiceNodeDesignPreset?>((ref) {
  var name = ref.watch(currentPresetNameProvider);
  return ref.watch(choiceNodePresetProvider(name));
});

final choiceNodePresetProvider = Provider.family.autoDispose<ChoiceNodeDesignPreset, String>((ref, name) {
  var map = ref.watch(choiceNodePresetListProvider);
  return map[name] ?? map["default"] ?? const ChoiceNodeDesignPreset();
});

final choiceNodePresetCurrentTabProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

@riverpod
TextEditingController choiceNodePresetDistance(Ref ref, {required String position}) {
  ref.listen(currentPresetNameProvider, (previous, next) {
    ref.invalidateSelf();
  });
  EdgeValue getValue() {
    return ref.read(choiceNodePresetCurrentEditProvider)!.padding!;
  }

  var controller = TextEditingController(text: getValue().getValue(position).toString());
  controller.addListener(() {
    EasyDebounce.debounce('Choice Distance Input $position', ConstList.debounceDuration, () {
      EdgeValue distance = getValue();
      Map<String, double> values = {'top': distance.top, 'right': distance.right, 'bottom': distance.bottom, 'left': distance.left};
      values[position] = double.tryParse(controller.text) ?? 0.0;
      ChoiceNodeDesignPreset newValue =
          ref.read(choiceNodePresetCurrentEditProvider)!.copyWith.padding!(top: values['top']!, right: values['right']!, bottom: values['bottom']!, left: values['left']!);
      ref.read(choiceNodePresetListProvider.notifier).update(ref.watch(currentPresetNameProvider)!, newValue);
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Choice Distance Input $position');
    controller.dispose();
  });
  return controller;
}

@riverpod
TextEditingController choiceNodePresetRound(Ref ref, {required String position}) {
  ref.listen(currentPresetNameProvider, (previous, next) {
    ref.invalidateSelf();
  });
  VertexValue getValue() {
    return ref.read(choiceNodePresetCurrentEditProvider)!.round!;
  }

  var controller = TextEditingController(text: getValue().getValue(position).toString());
  controller.addListener(() {
    EasyDebounce.debounce('Choice Round Input $position', ConstList.debounceDuration, () {
      VertexValue round = getValue();
      Map<String, double> values = {'topLeft': round.topLeft, 'topRight': round.topRight, 'bottomLeft': round.bottomLeft, 'bottomRight': round.bottomRight};
      values[position] = double.tryParse(controller.text) ?? 0.0;
      ChoiceNodeDesignPreset newValue = ref.read(choiceNodePresetCurrentEditProvider)!.copyWith.round!(
          topLeft: values['topLeft']!, topRight: values['topRight']!, bottomLeft: values['bottomLeft']!, bottomRight: values['bottomRight']!);
      ref.read(choiceNodePresetListProvider.notifier).update(ref.watch(currentPresetNameProvider)!, newValue);
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Choice Round Input $position');
    controller.dispose();
  });
  return controller;
}

@riverpod
TextEditingController choiceNodePresetOutlineDistance(Ref ref, {required String position, required bool isSelected}) {
  ref.listen(currentPresetNameProvider, (previous, next) {
    ref.invalidateSelf();
  });
  EdgeValue getValue() {
    if (isSelected) {
      return ref.read(choiceNodePresetCurrentEditProvider)!.selectOutlineOption!.distance;
    } else {
      return ref.read(choiceNodePresetCurrentEditProvider)!.defaultOutlineOption!.distance;
    }
  }

  var controller = TextEditingController(text: getValue().getValue(position).toString());
  controller.addListener(() {
    EasyDebounce.debounce('Outline Distance Input $position $isSelected', ConstList.debounceDuration, () {
      EdgeValue distance = getValue();
      Map<String, double> values = {'top': distance.top, 'right': distance.right, 'bottom': distance.bottom, 'left': distance.left};
      values[position] = double.tryParse(controller.text) ?? 0.0;
      ChoiceNodeDesignPreset? newValue;
      if (isSelected) {
        newValue =
            ref.read(choiceNodePresetCurrentEditProvider)!.copyWith.selectOutlineOption?.distance(top: values['top']!, right: values['right']!, bottom: values['bottom']!, left: values['left']!);
      } else {
        newValue =
            ref.read(choiceNodePresetCurrentEditProvider)!.copyWith.defaultOutlineOption?.distance(top: values['top']!, right: values['right']!, bottom: values['bottom']!, left: values['left']!);
      }
      ref.read(choiceNodePresetListProvider.notifier).update(ref.watch(currentPresetNameProvider)!, newValue!);
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Outline Distance Input $position $isSelected');
    controller.dispose();
  });
  return controller;
}

@riverpod
TextEditingController choiceNodePresetOutlineRound(Ref ref, {required String position, required bool isSelected}) {
  ref.listen(currentPresetNameProvider, (previous, next) {
    ref.invalidateSelf();
  });
  VertexValue getValue() {
    if (isSelected) {
      return ref.read(choiceNodePresetCurrentEditProvider)!.selectOutlineOption!.round;
    } else {
      return ref.read(choiceNodePresetCurrentEditProvider)!.defaultOutlineOption!.round;
    }
  }

  var controller = TextEditingController(text: getValue().getValue(position).toString());
  controller.addListener(() {
    EasyDebounce.debounce('Outline Round Input $position $isSelected', ConstList.debounceDuration, () {
      VertexValue round = getValue();
      Map<String, double> values = {'topLeft': round.topLeft, 'topRight': round.topRight, 'bottomLeft': round.bottomLeft, 'bottomRight': round.bottomRight};
      values[position] = double.tryParse(controller.text) ?? 0.0;
      ChoiceNodeDesignPreset? newValue;
      if (isSelected) {
        newValue = ref
            .read(choiceNodePresetCurrentEditProvider)!
            .copyWith
            .selectOutlineOption
            ?.round(topLeft: values['topLeft']!, topRight: values['topRight']!, bottomLeft: values['bottomLeft']!, bottomRight: values['bottomRight']!);
      } else {
        newValue = ref
            .read(choiceNodePresetCurrentEditProvider)!
            .copyWith
            .defaultOutlineOption
            ?.round(topLeft: values['topLeft']!, topRight: values['topRight']!, bottomLeft: values['bottomLeft']!, bottomRight: values['bottomRight']!);
      }
      ref.read(choiceNodePresetListProvider.notifier).update(ref.watch(currentPresetNameProvider)!, newValue!);
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Outline Round Input $position $isSelected');
    controller.dispose();
  });
  return controller;
}

final choiceNodePresetCurrentEditOutlineWidthProvider = Provider.autoDispose<TextEditingController>((ref) {
  ref.listen(currentPresetNameProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(text: ref.read(choiceNodePresetCurrentEditProvider)!.defaultOutlineOption!.outlineWidth.toString());
  controller.addListener(() {
    EasyDebounce.debounce('Outline Width Input', ConstList.debounceDuration, () {
      ref
          .read(choiceNodePresetListProvider.notifier)
          .update(ref.watch(currentPresetNameProvider)!, ref.read(choiceNodePresetCurrentEditProvider)!.copyWith.defaultOutlineOption!(outlineWidth: double.tryParse(controller.text) ?? 0.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Outline Width Input');
    controller.dispose();
  });
  return controller;
});

final choiceNodePresetSelectedEditOutlineWidthProvider = Provider.autoDispose<TextEditingController>((ref) {
  ref.listen(currentPresetNameProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(text: ref.read(choiceNodePresetCurrentEditProvider)!.selectOutlineOption!.outlineWidth.toString());
  controller.addListener(() {
    EasyDebounce.debounce('Outline Width Input Selected', ConstList.debounceDuration, () {
      ref
          .read(choiceNodePresetListProvider.notifier)
          .update(ref.watch(currentPresetNameProvider)!, ref.read(choiceNodePresetCurrentEditProvider)!.copyWith.selectOutlineOption!(outlineWidth: double.tryParse(controller.text) ?? 0.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Outline Width Input Selected');
    controller.dispose();
  });
  return controller;
});

@riverpod
TextEditingController choiceNodePresetImageMaxHeightRatio(Ref ref) {
  ref.listen(currentPresetNameProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(text: ref.read(choiceNodePresetCurrentEditProvider)!.imageMaxHeightRatio.toString());
  controller.addListener(() {
    EasyDebounce.debounce('ImageMaxHeightRatio Input', ConstList.debounceDuration, () {
      ref
          .read(choiceNodePresetListProvider.notifier)
          .update(ref.watch(currentPresetNameProvider)!, ref.read(choiceNodePresetCurrentEditProvider)!.copyWith(imageMaxHeightRatio: double.tryParse(controller.text)?.clamp(0.01, 5.0) ?? 1.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('ImageMaxHeightRatio Input');
    controller.dispose();
  });
  return controller;
}

final choiceNodePresetCurrentEditElevationProvider = Provider.autoDispose<TextEditingController>((ref) {
  ref.listen(currentPresetNameProvider, (previous, next) {
    ref.invalidateSelf();
  });
  var controller = TextEditingController(text: ref.read(choiceNodePresetCurrentEditProvider)!.elevation.toString());
  controller.addListener(() {
    EasyDebounce.debounce('Elevation Input', ConstList.debounceDuration, () {
      ref
          .read(choiceNodePresetListProvider.notifier)
          .update(ref.watch(currentPresetNameProvider)!, ref.read(choiceNodePresetCurrentEditProvider)!.copyWith(elevation: double.tryParse(controller.text) ?? 0.0));
    });
  });
  ref.onDispose(() {
    EasyDebounce.cancel('Elevation Input');
    controller.dispose();
  });
  return controller;
});
final choiceNodePresetTestSelectProvider = StateProvider<bool>((ref) => false);

final choiceNodePresetListProvider = StateNotifierProvider.autoDispose<ChoiceNodePresetListNotifier, Map<String, ChoiceNodeDesignPreset>>((ref) {
  ref.listenSelf((previous, next) {
    if (previous == null || previous == next) return;
    getPlatform.designSetting = getPlatform.designSetting.copyWith(choiceNodePresetMap: next);
    ref.read(currentProjectChangedProvider.notifier).changed(needUpdateCode: false);
  });
  return ChoiceNodePresetListNotifier(ref);
});

class ChoiceNodePresetListNotifier extends StateNotifier<Map<String, ChoiceNodeDesignPreset>> {
  Ref ref;

  ChoiceNodePresetListNotifier(this.ref) : super({...getPlatform.designSetting.choiceNodePresetMap});

  void rename(String before, String after) {
    var removed = state.remove(before);
    if (removed != null) {
      state[after] = removed;
      state = {...state};
    }
    getPlatform.updateNodePresetNameAll(before, after);
    ref.invalidate(choiceNodeDesignSettingProvider);
  }

  void create() {
    var name = 'preset_new'.i18n;
    var rename = getCloneName(name, (considerName) {
      return state.containsKey(considerName);
    });
    state = {...state, rename: const ChoiceNodeDesignPreset()};
  }

  void delete(String name) {
    if (name != "default") {
      state.remove(name);
      state = {...state};
      getPlatform.updateNodePresetNameAll(name, "default");
    }
  }

  void clone(String name) {
    var original = state[name];
    var newName = getCloneName(name, (considerName) {
      return state.containsKey(considerName);
    });
    var clone = original!.copyWith();
    state = {...state, newName: clone};
  }

  void update(String name, ChoiceNodeDesignPreset newValue) {
    state[name] = newValue;
    state = {...state};
  }
}
