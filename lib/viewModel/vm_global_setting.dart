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
        .watch(vmGlobalSettingProvider.notifier)
        .getKey(ref.watch(editIndex));
    return Tuple2(key, ref.watch(vmGlobalSettingProvider)[key]!);
  }
  return null;
});

final globalSettingNameTextEditingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller =
      TextEditingController(text: ref.read(initialValueWrapperProvider)!.item1);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final globalSettingValueTextEditingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var data = ref.read(initialValueWrapperProvider)!.item2.valueType.data;
  data = data is String ? '"$data"' : data.toString();
  var controller = TextEditingController(text: data);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final globalSettingDisplayNameTextEditingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var controller = TextEditingController(
      text: ref.read(initialValueWrapperProvider)!.item2.displayName);
  ref.onDispose(() => controller.dispose());
  return controller;
});

final vmGlobalSettingProvider = StateNotifierProvider.autoDispose<
        VMGlobalSetting, Map<String, ValueTypeWrapper>>(
    (ref) => VMGlobalSetting(ref.read, Map.from(getPlatform.globalSetting)));

final globalSettingChangedProvider =
    StateProvider.autoDispose<bool>((ref) => false);

final globalSettingVisibleSwitchProvider = StateProvider.autoDispose<bool>(
    (ref) => ref.read(initialValueWrapperProvider)!.item2.visible);

class VMGlobalSetting extends StateNotifier<Map<String, ValueTypeWrapper>> {
  Reader read;

  VMGlobalSetting(this.read, super.state);

  ValueType getType(String input) {
    if (input.startsWith("\"") && input.endsWith("\"")) {
      return ValueType(input.replaceAll("\"", ""));
    } else if (int.tryParse(input) != null) {
      return ValueType(int.parse(input));
    } else if (double.tryParse(input) != null) {
      return ValueType(double.parse(input));
    } else {
      return ValueType(input.toLowerCase().trim() == 'true');
    }
  }

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
    read(globalSettingChangedProvider.notifier).state = true;
  }

  void deleteInitialValue(int index) {
    state = Map.from(state)..remove(getKey(index));
    read(globalSettingChangedProvider.notifier).state = true;
  }

  void editInitialValue(int index) {
    if (index != -1) {
      deleteInitialValue(index);
    }
    addInitialValue(
        read(globalSettingNameTextEditingProvider).text,
        ValueTypeWrapper(
            getType(read(globalSettingValueTextEditingProvider).text),
            visible: read(globalSettingVisibleSwitchProvider),
            displayName:
                read(globalSettingDisplayNameTextEditingProvider).text));
    read(globalSettingChangedProvider.notifier).state = true;
  }

  String getKey(int index) {
    return state.keys.elementAt(index);
  }

  void save() {
    getPlatform.setGlobalSetting(state);
    print(getPlatform.globalSetting);
    VariableDataBase().updateVariableTiles();
    read(globalSettingChangedProvider.notifier).state = false;
  }
}
