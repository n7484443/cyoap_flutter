import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VMGlobalSetting extends GetxController {
  final TextEditingController controllerGlobal = TextEditingController();

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerValue = TextEditingController();
  final TextEditingController controllerDisplayName = TextEditingController();

  bool isChanged = false;
  bool visibleSwitch = true;

  Map<String, ValueTypeWrapper> initialValueList = {};

  @override
  void onInit() {
    initialValueList.clear();
    initialValueList.addAll(getPlatform.globalSetting);

    super.onInit();
  }

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
    if (!initialValueList.containsKey(name)) {
      initialValueList.putIfAbsent(name, () => type);
    } else {
      while (true) {
        if (initialValueList.containsKey(name + t.toString())) {
          t += 1;
        } else {
          initialValueList.putIfAbsent(name + t.toString(), () => type);
          break;
        }
      }
    }
    update();
    isChanged = true;
  }

  void deleteInitialValue(int index) {
    initialValueList.remove(getKey(index));
    update();
    isChanged = true;
  }

  void editInitialValue(int index) {
    if (index != -1) {
      deleteInitialValue(index);
    }
    addInitialValue(
        controllerName.text,
        ValueTypeWrapper(getType(controllerValue.text), visibleSwitch,
            displayName: controllerDisplayName.text));
    controllerName.clear();
    controllerValue.clear();
    controllerDisplayName.clear();
    isChanged = true;
  }

  void loadInitialValue(int index) {
    if (index != -1) {
      var key = getKey(index);
      var wrapper = initialValueList[key]!;
      var data = wrapper.valueType.data;

      controllerName.text = key;
      controllerValue.text = data is String ? '"$data"' : data.toString();
      controllerDisplayName.text = wrapper.displayName;
    }
  }

  String getKey(int index) {
    return initialValueList.keys.elementAt(index);
  }

  ValueTypeWrapper? getValue(int index) {
    return initialValueList[getKey(index)];
  }

  void save() {
    getPlatform.setGlobalSetting(initialValueList);
    var vmDraggable = Get.find<VMDraggableNestedMap>();
    vmDraggable.titleFont.value = getPlatform.titleFont;
    vmDraggable.mainFont.value = getPlatform.mainFont;
    Get.find<VMVariableTable>().update();
    isChanged = false;
  }

  bool isVisible(int index) {
    if (index == -1) {
      return true;
    }
    return initialValueList[getKey(index)]!.visible;
  }

  void setVisible(int index, bool value) {
    visibleSwitch = value;
    if (index == -1) {
    } else {
      initialValueList[getKey(index)]!.visible = value;
    }
    update();
  }

  void setTitleFont(String font) {
    getPlatform.titleFont = font;
    update();
    isChanged = true;
  }

  void setMainFont(String font) {
    getPlatform.mainFont = font;
    update();
    isChanged = true;
  }

  void updateColor(Color color) {
    getPlatform.colorBackground = color;
    Get.find<VMDraggableNestedMap>().update();
  }
}
