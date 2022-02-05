import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/util/tuple.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class VMGlobalSetting extends GetxController{
  final TextEditingController controllerGlobal = TextEditingController();

  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerValue = TextEditingController();

  bool isChanged = false;

  List<Tuple<String, ValueTypeVisible>> initialValueList = List.empty(growable: true);

  @override
  void onInit(){
    initialValueList.clear();
    initialValueList.addAll(PlatformSystem.getPlatform().globalSetting);
    super.onInit();
  }

  ValueType getType(String input){
    if(input.startsWith("\"") && input.endsWith("\"")){
      return ValueType(input.replaceAll("\"", ""));
    }else if(int.tryParse(input) != null){
      return ValueType(int.parse(input));
    }else if(double.tryParse(input) != null){
      return ValueType(double.parse(input));
    }else{
      return ValueType(input.toLowerCase().trim() == 'true');
    }
  }

  void addInitialValue(String name, ValueTypeVisible type){
    initialValueList.add(Tuple(name, type));
    update();
    isChanged = true;
  }

  void deleteInitialValue(int index){
    initialValueList.removeAt(index);
    update();
    isChanged = true;
  }

  void editInitialValue(int index){
    if(index != -1){
      deleteInitialValue(index);
    }
    addInitialValue(controllerName.text, ValueTypeVisible(getType(controllerValue.text), true));
    controllerName.clear();
    controllerValue.clear();
    isChanged = true;
  }

  void loadInitialValue(int index){
    if(index != -1){
      controllerName.text = initialValueList[index].data1;
      var data = initialValueList[index].data2.valueType.data;

      controllerValue.text = data is String ? '"$data"' : data.toString();
    }
  }

  void save(){
    PlatformSystem.getPlatform().setGlobalSetting(initialValueList);
    isChanged = false;
  }
}