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

final projectSettingVisibleSwitchProvider = StateProvider.family
    .autoDispose<bool, int>((ref, index) => ref
    .read(valueTypeWrapperListProvider.notifier)
    .getEditTarget(index)!
    .item2
    .visible);

final valueTypeWrapperListProvider = StateNotifierProvider.autoDispose<
        ValueTypeWrapperListNotifier, List<Tuple2<String, ValueTypeWrapper>>>(
    (ref) =>
        ValueTypeWrapperListNotifier(ref, List.from(getPlatform.globalSetting)));

class ValueTypeWrapperListNotifier
    extends StateNotifier<List<Tuple2<String, ValueTypeWrapper>>> {
  Ref ref;

  ValueTypeWrapperListNotifier(this.ref, super.state);

  void addInitialValue(String name, ValueTypeWrapper type) {
    int t = 0;
    var pos = state.indexWhere((element) => element.item1 == name);
    if (pos == -1) {
      state = [...state, Tuple2(name, type)];
    } else {
      while (true) {
        pos = state.indexWhere((element) => element.item1 == (name + t.toString()));
        if (pos != -1) {
          t += 1;
        } else {
          state = [...state, Tuple2((name + t.toString()), type)];
          break;
        }
      }
    }
  }

  void deleteInitialValue(int index) {
    state = [...state]..removeAt(index);
  }

  void editInitialValue(int index, String name, ValueTypeWrapper value) {
    if (index != -1) {
      deleteInitialValue(index);
    }
    state = [...state]..insert(index, Tuple2(name, value));
  }

  void save() {
    getPlatform.setGlobalSetting(state);
    VariableDataBase().updateVariableTiles();
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  }

  Tuple2<String, ValueTypeWrapper>? getEditTarget(int index) {
    if (index != -1) {
      return state[index];
    }
    return null;
  }

  bool isDifferentFromOrigin() {
    if (state.length != getPlatform.globalSetting.length) {
      return true;
    }
    for(int i = 0; i < state.length; i++){
      if(state[i].item1 != getPlatform.globalSetting[i].item1){
        return true;
      }
      if(state[i].item2 != getPlatform.globalSetting[i].item2){
        return true;
      }
    }
    return false;
  }
}
