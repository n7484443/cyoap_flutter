import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../model/variable_db.dart';

final editIndex = StateProvider.autoDispose<int>((ref) => -1);

final initialValueWrapperProvider =
    Provider.autoDispose<Tuple2<String, ValueTypeWrapper>?>((ref) {
  if (ref.watch(editIndex) != -1) {
    var key = ref
        .watch(valueTypeWrapperListProvider.notifier)
        .getKey(ref.watch(editIndex));
    return Tuple2(key, ref.watch(valueTypeWrapperListProvider)[key]!);
  }
  return null;
});

final projectSettingNameTextEditingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller =
      TextEditingController(text: ref.read(initialValueWrapperProvider)!.item1);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final projectSettingValueTextEditingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var data = ref.read(initialValueWrapperProvider)!.item2.valueType;
  var text = data.type.isString ? '"${data.dataUnzip}"' : data.data;
  var controller = TextEditingController(text: text);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final projectSettingDisplayNameTextEditingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text: ref.read(initialValueWrapperProvider)!.item2.displayName);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final valueTypeWrapperListProvider = StateNotifierProvider.autoDispose<
        ValueTypeWrapperListNotifier, Map<String, ValueTypeWrapper>>(
    (ref) => ValueTypeWrapperListNotifier(
        ref.read, Map.from(getPlatform.globalSetting)));

final projectSettingChangedProvider = StateProvider<bool>((ref) => false);

final projectSettingVisibleSwitchProvider = StateProvider.autoDispose<bool>(
    (ref) => ref.read(initialValueWrapperProvider)!.item2.visible);

class ValueTypeWrapperListNotifier
    extends StateNotifier<Map<String, ValueTypeWrapper>> {
  Reader read;

  ValueTypeWrapperListNotifier(this.read, super.state);

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
    read(projectSettingChangedProvider.notifier).state = true;
  }

  void deleteInitialValue(int index) {
    state = Map.from(state)..remove(getKey(index));
    read(projectSettingChangedProvider.notifier).state = true;
  }

  void editInitialValue(int index) {
    if (index != -1) {
      deleteInitialValue(index);
    }
    addInitialValue(
        read(projectSettingNameTextEditingProvider).text,
        ValueTypeWrapper(
            getValueTypeFromStringInput(
                read(projectSettingValueTextEditingProvider).text),
            visible: read(projectSettingVisibleSwitchProvider),
            displayName:
                read(projectSettingDisplayNameTextEditingProvider).text));
    read(projectSettingChangedProvider.notifier).state = true;
  }

  String getKey(int index) {
    return state.keys.elementAt(index);
  }

  void save() {
    getPlatform.setGlobalSetting(state);
    VariableDataBase().updateVariableTiles();
    read(projectSettingChangedProvider.notifier).state = false;
  }
}
