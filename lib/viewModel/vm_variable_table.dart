import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../util/tuple.dart';

class VMVariableTable extends GetxController {
  List<Tuple<String, bool>> nodeNameList = List.empty(growable: true);
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
      for(var node in t.data1){
        nodeNameList.add(Tuple(node.title, isEditable() ? true : node.select));
      }
    }

    for(var key in VariableDataBase.instance.varMap.keys) {
      var values = VariableDataBase.instance.varMap[key];
      if (values == null) continue;
      if (values.visible && !values.isFromNode) {
        if (isEditable()) {
          variableList.add(
              '$key | ${values.valueType.data.runtimeType}');
        } else {
          variableList.add(
              '$key | ${values.valueType.data}');
        }
      }
    }
    update();
  }

  List<Tuple<String, bool>> getNodeNameList(){
    return nodeNameList;
  }

  List<String> getVariableList(){
    return variableList;
  }

  bool isEditable() {
    return PlatformSystem.getPlatform().isEditable;
  }
}