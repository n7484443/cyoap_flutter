import 'package:cyoap_flutter/model/choiceNode/generable_parser.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VMVariableTable extends GetxController {
  @override
  void onInit() {
    VariableDataBase.instance.viewModel = this;
    super.onInit();
  }

  List<Widget> get nodeList {
    var nodeList = List<Widget>.empty(growable: true);
    var iconCheckBox = const Icon(Icons.check_box);
    var iconCheckBoxBlank = const Icon(Icons.check_box_outline_blank);
    getPlatform().doAllChoiceNode((node) {
      if (isEditable()) {
        nodeList.add(ListTile(
          title: Text(node.title),
        ));
      } else if (node.isSelectable) {
        nodeList.add(ListTile(
          title: Text(node.title),
          trailing: node.status.isSelected() ? iconCheckBox : iconCheckBoxBlank,
        ));
      }
    });
    return nodeList;
  }

  List<Widget> get variableList {
    var variableList = List<Widget>.empty(growable: true);
    for (var key in VariableDataBase.instance.varMap.keys) {
      var values = VariableDataBase.instance.varMap[key];
      if (values == null) continue;
      if (values.visible && !values.isFromNode) {
        if (isEditable()) {
          if (values.displayName.isEmpty) {
            variableList.add(ListTile(
              title: Text(key),
              trailing: Text(values.valueType.data.runtimeType.toString()),
            ));
          } else {
            variableList.add(ListTile(
              title: Text(key),
              subtitle: Text(values.displayName),
              trailing: Text(values.valueType.data.runtimeType.toString()),
            ));
          }
        } else {
          var name = values.displayName.isEmpty ? key : values.displayName;
          variableList.add(ListTile(
            title: Text(name),
            trailing: Text(values.valueType.data.toString()),
          ));
        }
      }
    }
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
