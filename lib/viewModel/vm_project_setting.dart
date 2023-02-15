import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

final projectSettingNameTextEditingProvider =
    Provider.family.autoDispose<TextEditingController, int>((ref, index) {
  var controller = TextEditingController(
      text: ref
          .read(valueTypeWrapperListProvider.notifier)
          .getEditTarget(index)!
          .item1);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final projectSettingValueTextEditingProvider =
    Provider.family.autoDispose<TextEditingController, int>((ref, index) {
  var data = ref
      .read(valueTypeWrapperListProvider.notifier)
      .getEditTarget(index)!
      .item2
      .valueType;
  var text = data.type.isString ? '"${data.dataUnzip}"' : data.data;
  var controller = TextEditingController(text: text);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final projectSettingDisplayNameTextEditingProvider =
    Provider.family.autoDispose<TextEditingController, int>((ref, index) {
  var controller = TextEditingController(
      text: ref
          .read(valueTypeWrapperListProvider.notifier)
          .getEditTarget(index)!
          .item2
          .displayName);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final valueTypeWrapperListProvider = StateNotifierProvider.autoDispose<
        ValueTypeWrapperListNotifier, Map<String, ValueTypeWrapper>>(
    (ref) =>
        ValueTypeWrapperListNotifier(ref, Map.from(getPlatform.globalSetting)));

final projectSettingVisibleSwitchProvider = StateProvider.family
    .autoDispose<bool, int>((ref, index) => ref
        .read(valueTypeWrapperListProvider.notifier)
        .getEditTarget(index)!
        .item2
        .visible);

class ValueTypeWrapperListNotifier
    extends StateNotifier<Map<String, ValueTypeWrapper>> {
  Ref ref;

  ValueTypeWrapperListNotifier(this.ref, super.state);

  void addInitialValue(String name, ValueTypeWrapper type) {
    int t = 0;
    if (!state.containsKey(name)) {
      state = Map.from(state)..putIfAbsent(name, () => type);
    } else {
      while (true) {
        if (state.containsKey(name + t.toString())) {
          t += 1;
        } else {
          state = Map.from(state)..putIfAbsent(name + t.toString(), () => type);
          break;
        }
      }
    }
  }

  void deleteInitialValue(int index) {
    state = Map.from(state)..remove(getKey(index));
  }

  void editInitialValue(int index, String name, ValueTypeWrapper value) {
    if (index != -1) {
      deleteInitialValue(index);
    }
    addInitialValue(name, value);
  }

  String getKey(int index) {
    return state.keys.elementAt(index);
  }

  ValueTypeWrapper? getValue(String key) {
    return state[key];
  }

  void save() {
    getPlatform.setGlobalSetting(state);
    VariableDataBase().updateVariableTiles();
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  }

  Tuple2<String, ValueTypeWrapper>? getEditTarget(int index) {
    if (index != -1) {
      var key = getKey(index);
      return Tuple2(key, getValue(key)!);
    }
    return null;
  }

  bool isDifferentFromOrigin() {
    if (state.length != getPlatform.globalSetting.length) {
      return true;
    }
    for (var key in state.keys) {
      if (!getPlatform.globalSetting.containsKey(key)) {
        return true;
      }
      if (state[key] != getPlatform.globalSetting[key]) {
        return true;
      }
    }
    return false;
  }
}
