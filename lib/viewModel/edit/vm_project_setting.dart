import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/edit/vm_draggable_nested_map.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../main.dart';

part 'vm_project_setting.g.dart';

@riverpod
TextEditingController projectSettingNameTextEditing(ProjectSettingNameTextEditingRef ref) {
  var index = ref.watch(currentEditGlobalVariableProvider)!;
  var name = ref.read(valueTypeWrapperListProvider.notifier).getEditTargetName(index)!;
  var controller = TextEditingController(text: name);
  controller.addListener(() {
    EasyDebounce.debounce('projectSettingNameTextEditingProvider', ConstList.debounceDuration, () {
      var newName = controller.text.trim();
      if (newName.isEmpty) {
        return;
      }
      ref.read(valueTypeWrapperListProvider.notifier).editInitialValue(index, name: newName);
    });
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('projectSettingNameTextEditingProvider');
  });
  return controller;
}

@riverpod
TextEditingController projectSettingValueTextEditing(ProjectSettingValueTextEditingRef ref) {
  var index = ref.watch(currentEditGlobalVariableProvider)!;
  var value = ref.read(valueTypeWrapperListProvider.notifier).getEditTargetValueTypeWrapper(index)!;
  var data = value.valueType;
  var text = data.type.isString ? '"${data.dataUnzip}"' : data.data;
  var controller = TextEditingController(text: text);
  controller.addListener(() {
    EasyDebounce.debounce('projectSettingValueTextEditingProvider', ConstList.debounceDuration, () {
      var newValue = controller.text.trim();
      if (newValue.isEmpty) {
        return;
      }
      var value = ref.read(valueTypeWrapperListProvider.notifier).getEditTargetValueTypeWrapper(index)!;
      ref.read(valueTypeWrapperListProvider.notifier).editInitialValue(index, value: value.copyWith(valueType: getValueTypeFromStringInput(newValue)));
    });
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('projectSettingValueTextEditingProvider');
  });
  return controller;
}

@riverpod
TextEditingController projectSettingDisplayNameTextEditing(ProjectSettingDisplayNameTextEditingRef ref) {
  var index = ref.watch(currentEditGlobalVariableProvider)!;
  var value = ref.read(valueTypeWrapperListProvider.notifier).getEditTargetValueTypeWrapper(index)!;
  var controller = TextEditingController(text: value.displayName);
  controller.addListener(() {
    EasyDebounce.debounce('projectSettingDisplayNameTextEditingProvider', ConstList.debounceDuration, () {
      var newDisplayName = controller.text.trim();
      if (newDisplayName.isEmpty) {
        newDisplayName = ref.read(valueTypeWrapperListProvider.notifier).getEditTargetName(index)!;
      }
      var value = ref.read(valueTypeWrapperListProvider.notifier).getEditTargetValueTypeWrapper(index)!;
      ref.read(valueTypeWrapperListProvider.notifier).editInitialValue(index, value: value.copyWith(displayName: newDisplayName));
    });
  });
  ref.onDispose(() {
    controller.dispose();
    EasyDebounce.cancel('projectSettingDisplayNameTextEditingProvider');
  });
  return controller;
}

final currentEditGlobalVariableProvider = StateProvider.autoDispose<int?>((ref) {
  return null;
});

@riverpod
class ValueTypeWrapperList extends _$ValueTypeWrapperList {
  @override
  List<(String, ValueTypeWrapper)> build() {
    return List.from(getPlatform.globalSetting);
  }

  void addInitialValue(String name, ValueTypeWrapper type) {
    int t = 0;
    var pos = state.indexWhere((element) => element.$1 == name);
    if (pos == -1) {
      state = [...state, (name, type)];
    } else {
      while (true) {
        pos = state.indexWhere((element) => element.$1 == (name + t.toString()));
        if (pos != -1) {
          t += 1;
        } else {
          state = [...state, ((name + t.toString()), type)];
          break;
        }
      }
    }
    save();
  }

  void deleteInitialValue(int index) {
    state.removeAt(index);
    state = [...state];
    save();
  }

  void editInitialValue(int index, {String? name, ValueTypeWrapper? value}) {
    ValueTypeWrapper newValue = value ?? state[index].$2;
    String newName = name ?? state[index].$1;
    state[index] = (newName, newValue);
    state = [...state];
    save();
  }

  void save() {
    getPlatform.setGlobalSetting(state);
    VariableDataBase().updateVariableTiles();
    ref.read(currentProjectChangedProvider.notifier).changed(needUpdateCode: true);
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
    save();
  }

  void swap(int indexA, int indexB) {
    var elementA = state[indexA];
    var elementB = state[indexB];
    state[indexA] = elementB;
    state[indexB] = elementA;
    state = [...state];
    save();
  }
}

enum FilterType { showVisible, hideVisible, showAll }

final globalVariableFilterProvider = StateProvider<FilterType>((ref) {
  return FilterType.showAll;
});

@riverpod
List<int> globalVariableFilteredList(GlobalVariableFilteredListRef ref) {
  var filterType = ref.watch(globalVariableFilterProvider);
  var list = ref.watch(valueTypeWrapperListProvider);
  List<int> output = [];
  for (int i = 0; i < list.length; i++) {
    switch (filterType) {
      case FilterType.showVisible:
        if (list[i].$2.visible) {
          output.add(i);
        }
        break;

      case FilterType.hideVisible:
        if (!list[i].$2.visible) {
          output.add(i);
        }
        break;

      case FilterType.showAll:
        output.add(i);
        break;
    }
  }
  return output;
}
