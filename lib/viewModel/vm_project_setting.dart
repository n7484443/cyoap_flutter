import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

final projectSettingNameTextEditingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var index = ref.watch(currentEditGlobalVariableProvider);
  var name =
      ref.read(valueTypeWrapperListProvider.notifier).getEditTargetName(index)!;
  var value = ref
      .read(valueTypeWrapperListProvider.notifier)
      .getEditTargetValueTypeWrapper(index)!;
  var controller = TextEditingController(text: name);
  controller.addListener(() {
    EasyDebounce.debounce(
        'projectSettingNameTextEditingProvider', ConstList.debounceDuration,
        () {
      var newName = controller.text.trim();
      if (newName.isEmpty) {
        return;
      }
      ref
          .read(valueTypeWrapperListProvider.notifier)
          .editInitialValue(index, newName, value);
    });
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('projectSettingNameTextEditingProvider');
  });
  return controller;
});

final projectSettingValueTextEditingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  var index = ref.watch(currentEditGlobalVariableProvider);
  var name =
      ref.read(valueTypeWrapperListProvider.notifier).getEditTargetName(index)!;
  var value = ref
      .read(valueTypeWrapperListProvider.notifier)
      .getEditTargetValueTypeWrapper(index)!;
  var data = value.valueType;
  var text = data.type.isString ? '"${data.dataUnzip}"' : data.data;
  var controller = TextEditingController(text: text);
  controller.addListener(() {
    EasyDebounce.debounce(
        'projectSettingValueTextEditingProvider', ConstList.debounceDuration,
        () {
      var newValue = controller.text.trim();
      if (newValue.isEmpty) {
        return;
      }
      ref.read(valueTypeWrapperListProvider.notifier).editInitialValue(
          index,
          name,
          value.copyWith(valueType: getValueTypeFromStringInput(newValue)));
    });
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('projectSettingValueTextEditingProvider');
  });
  return controller;
});

final projectSettingDisplayNameTextEditingProvider =
    Provider.autoDispose<TextEditingController>((ref) {
      var index = ref.watch(currentEditGlobalVariableProvider);
      var name =
      ref.read(valueTypeWrapperListProvider.notifier).getEditTargetName(index)!;
      var value = ref
          .read(valueTypeWrapperListProvider.notifier)
          .getEditTargetValueTypeWrapper(index)!;
      var controller = TextEditingController(text: value.displayName);
      controller.addListener(() {
        EasyDebounce.debounce(
            'projectSettingDisplayNameTextEditingProvider', ConstList.debounceDuration,
                () {
              var newDisplayName = controller.text.trim();
              if (newDisplayName.isEmpty) {
                newDisplayName = name;
              }
              ref.read(valueTypeWrapperListProvider.notifier).editInitialValue(
                  index,
                  name,
                  value.copyWith(displayName: newDisplayName));
            });
      });
      ref.onDispose(() {
        controller.dispose();
        EasyDebounce.cancel('projectSettingDisplayNameTextEditingProvider');
      });
      return controller;
});

final currentEditGlobalVariableProvider = StateProvider.autoDispose<int>((ref) {
  return 0;
});

final valueTypeWrapperListProvider = StateNotifierProvider.autoDispose<
        ValueTypeWrapperListNotifier, List<(String, ValueTypeWrapper)>>(
    (ref) => ValueTypeWrapperListNotifier(
        ref, List.from(getPlatform.globalSetting)));

class ValueTypeWrapperListNotifier
    extends StateNotifier<List<(String, ValueTypeWrapper)>> {
  Ref ref;

  ValueTypeWrapperListNotifier(this.ref, super.state);

  void addInitialValue(String name, ValueTypeWrapper type) {
    int t = 0;
    var pos = state.indexWhere((element) => element.$1 == name);
    if (pos == -1) {
      state = [...state, (name, type)];
    } else {
      while (true) {
        pos =
            state.indexWhere((element) => element.$1 == (name + t.toString()));
        if (pos != -1) {
          t += 1;
        } else {
          state = [...state, ((name + t.toString()), type)];
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
    state = [...state]..insert(index, (name, value));
  }

  void save() {
    getPlatform.setGlobalSetting(state);
    VariableDataBase().updateVariableTiles();
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  }

  String? getEditTargetName(int index) {
    if (index != -1) {
      return state[index].$1;
    }
    return null;
  }

  ValueTypeWrapper? getEditTargetValueTypeWrapper(int index) {
    if (index != -1) {
      return state[index].$2;
    }
    return null;
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    var element = state.removeAt(oldIndex);
    state.insert(newIndex, element);
    state = [...state];
  }

  bool isDifferentFromOrigin() {
    if (state.length != getPlatform.globalSetting.length) {
      return true;
    }
    for (int i = 0; i < state.length; i++) {
      if (state[i].$1 != getPlatform.globalSetting[i].$1) {
        return true;
      }
      if (state[i].$2 != getPlatform.globalSetting[i].$2) {
        return true;
      }
    }
    return false;
  }
}
