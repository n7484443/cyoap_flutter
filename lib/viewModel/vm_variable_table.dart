import 'package:cyoap_flutter/model/choiceNode/generable_parser.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/viewModel/vm_code_editor.dart';
import 'package:cyoap_flutter/viewModel/vm_make_platform.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/choiceNode/choice_node.dart';

class VMVariableTable extends GetxController {
  var isVisibleSource = false.obs;
  var isDebugMode = false.obs;
  var isVisibleHideVariable = false;

  @override
  void onInit() {
    VariableDataBase().viewModel = this;
    super.onInit();
    isDebugMode.listen((p0) {
      update();
    });
  }

  void addStringToEditor(String input) {
    if (makePlatform.currentIndex.value == 2) {
      var vmCodeEditor = Get.find<VMCodeEditor>();
      if (vmCodeEditor.lastFocus != null) {
        vmCodeEditor.insertText(vmCodeEditor.lastFocus!, input.trim());
      }
    }
  }

  List<Widget> get nodeList {
    var nodeList = List<Widget>.empty(growable: true);
    var iconCheckBox = const Icon(Icons.check_box);
    var iconCheckBoxBlank = const Icon(Icons.check_box_outline_blank);
    if (isEditable) {
      for (var line in getPlatform.lineSettings) {
        List<Widget> subWidgetList = List.empty(growable: true);
        for (var child in line.children) {
          (child as ChoiceNode).doAllChild((node) {
            subWidgetList.add(
              ListTile(
                title: Text(node.title),
                onTap: () => addStringToEditor(node.title.replaceAll(" ", "")),
              ),
            );
          });
        }
        nodeList.add(ExpansionTile(
          title: Text("lineSetting_${line.currentPos}"),
          children: subWidgetList,
        ));
      }
    } else {
      getPlatform.doAllChoiceNode((node) {
        if (!node.isVisible()) {
          return;
        } else if (node.isSelectableMode) {
          nodeList.add(ListTile(
            title: Text(node.title),
            trailing:
                node.status.isSelected() ? iconCheckBox : iconCheckBoxBlank,
          ));
        }
      });
    }
    return nodeList;
  }

  List<Widget> get variableList {
    var variableList = List<Widget>.empty(growable: true);
    for (var key in VariableDataBase().varMap.keys) {
      var values = VariableDataBase().varMap[key]!;

      if (isEditable) {
        if (isVisibleHideVariable || (!isVisibleHideVariable && values.visible)) {
          variableList.add(ListTile(
            title: Text(key),
            subtitle: values.displayName.isEmpty ? null : Text(values.displayName),
            trailing: Text(values.valueType.data.runtimeType.toString()),
            onTap: () => addStringToEditor(key),
          ));
        }
      } else if (isDebugMode.value || values.visible) {
        var name = values.displayName.isEmpty ? key : values.displayName;
        variableList.add(ListTile(
          title: Text(name),
          trailing: Text(values.valueType.data.toString()),
        ));
      }
    }
    return variableList;
  }
}
