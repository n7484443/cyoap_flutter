import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class VMVariableTable extends GetxController {
  List<String> nodeNameList = List.empty(growable: true);
  List<String> variableList = List.empty(growable: true);

  @override
  void onInit(){
    updateLists();
    VariableDataBase.instance.viewModel = this;
    super.onInit();
  }

  void updateLists(){
    nodeNameList.clear();
    variableList.clear();

    var nodes = PlatformSystem.getPlatform().choiceNodes;
    for(var t in nodes){
      for(var node in t){
        nodeNameList.add(node.title);
      }
    }

    if(isEditable()){
      for(var key in VariableDataBase.instance.varMap.keys){
        variableList.add('$key | ${VariableDataBase.instance.varMap[key]?.data.runtimeType}');
      }
    }else{
      for(var key in VariableDataBase.instance.varMap.keys){
        if(PlatformSystem.getPlatform().globalSetting[key]?.visible ?? false){
          variableList.add('$key | ${VariableDataBase.instance.varMap[key]?.data}');
        }
      }
    }
    update();
  }

  List<String> getNodeNameList(){
    return nodeNameList;
  }

  List<String> getVariableList(){
    return variableList;
  }

  bool isEditable() {
    return PlatformSystem.getPlatform().isEditable;
  }
}