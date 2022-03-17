import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:get/get.dart';

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

    var nodes = getPlatform().choiceNodes;
    for(var t in nodes){
      for(var node in t){
        nodeNameList.add(Tuple(node.title, isEditable() ? true : node.select));
      }
    }

    for(var key in VariableDataBase.instance.varMap.keys) {
      var values = VariableDataBase.instance.varMap[key];
      if (values == null) continue;
      if (values.visible && !values.isFromNode) {
        if (isEditable()) {
          if (values.displayName.isEmpty) {
            variableList.add('$key | ${values.valueType.data.runtimeType}');
          } else {
            variableList.add(
                '$key | ${values.valueType.data.runtimeType} | ${values.displayName}');
          }
        } else {
          var name = values.displayName.isEmpty ? key : values.displayName;
          variableList.add('$name | ${values.valueType.data}');
        }
      }
    }
    print(variableList);
    update();
  }

  List<Tuple<String, bool>> getNodeNameList(){
    return nodeNameList;
  }

  List<String> getVariableList(){
    return variableList;
  }

  bool isEditable() {
    return getPlatform().isEditable;
  }

  void setSourceVisible(bool value) {
    getPlatform().isVisibleSource = value;
    Get.find<VMDraggableNestedMap>().update();
    update();
  }

  bool getSourceVisible() => getPlatform().isVisibleSource;
}