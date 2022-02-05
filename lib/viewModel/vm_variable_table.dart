import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class VMVariableTable extends GetxController {
  List<String> getNodeNameList(){
    List<String> nodeNameList = List.empty(growable: true);
    var nodes = PlatformSystem.getPlatform().choiceNodes;
    for(var t in nodes){
      for(var node in t){
        nodeNameList.add(node.title);
      }
    }
    return nodeNameList;
  }

  List<String> getVariableList(){
    List<String> variableList = List.empty(growable: true);
    if(PlatformSystem.getPlatform().isEditable){
      for(var key in VariableDataBase.instance.varMap.keys){
        variableList.add('$key | ${VariableDataBase.instance.varMap[key]?.data.runtimeType}');
      }
    }else{
      for(var key in VariableDataBase.instance.varMap.keys){
        variableList.add('$key | ${VariableDataBase.instance.varMap[key]?.data}');
      }
    }
    return variableList;
  }

  bool isEditable() {
    return PlatformSystem.getPlatform().isEditable;
  }
}