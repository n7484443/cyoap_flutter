import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/util/color_util.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../util/version.dart';
import '../viewModel/vm_draggable_nested_map.dart';
import 'choiceNode/choice_line.dart';
import 'choiceNode/generable_parser.dart';
import 'grammar/value_type.dart';

class AbstractPlatform {
  String stringImageName;
  Color colorBackground;
  int flag;
  List<LineSetting> lineSettings = List.empty(growable: true);
  Map<String, ValueTypeWrapper> globalSetting = {};
  String version;

  String titleFont;
  String mainFont;

  void init() {
    checkDataCollect();
    if (getPlatformFileSystem.isEditable) {
      generateRecursiveParser();
    }
    updateStatusAll();
  }

  bool versionCheckWithPlatform(String versionProgram) {
    return versionCheck(versionProgram, version) >= 0;
  }

  AbstractPlatform(
    this.stringImageName,
    this.colorBackground,
    this.flag,
    this.version, {
    this.titleFont = "notoSans",
    this.mainFont = "notoSans",
  });

  AbstractPlatform.none()
      : stringImageName = '',
        colorBackground = Colors.white,
        flag = 0,
        version = ConstList.version,
        titleFont = "notoSans",
        mainFont = "notoSans";

  AbstractPlatform.fromJson(Map<String, dynamic> json)
      : stringImageName = json['stringImageName'] ?? '',
        colorBackground =
            (json['colorBackground'] != null && json['colorBackground'] is int)
                ? Color(json['colorBackground'])
                : Colors.white,
        flag = json['flag'] ?? 0,
        globalSetting = (json['globalSetting'] as Map)
            .map((k, v) => MapEntry(k, ValueTypeWrapper.fromJson(v))),
        version = json['version'] ?? ConstList.version,
        titleFont = json['titleFont'] ?? 'notoSans',
        mainFont = json['mainFont'] ?? 'notoSans';

  Map<String, dynamic> toJson() => {
        'stringImageName': stringImageName,
        'colorBackground': colorBackground.value,
        'flag': flag,
        'globalSetting': globalSetting,
        'version': version,
        'titleFont': titleFont,
        'mainFont': mainFont,
      };

  void addLineSettingData(LineSetting lineSetting) {
    while (lineSettings.length <= lineSetting.currentPos) {
      lineSettings.add(LineSetting(lineSettings.length));
    }
    lineSettings[lineSetting.currentPos] = lineSetting;
  }

  void addData(List<int> pos, ChoiceNode node) {
    while (lineSettings.length <= pos.first) {
      lineSettings.add(LineSetting(lineSettings.length));
    }
    var parent = VMChoiceNode.getNode(List.from(pos)..removeLast())!;
    parent.addChildren(node, pos: pos.last);
    checkDataCollect();
  }
  void insertData(ChoiceNode nodeA, ChoiceNode nodeB) {
    var parentA = nodeA.parent!;
    var parentB = nodeB.parent!;
    var posB = nodeB.currentPos;

    parentA.removeChildren(nodeA);
    parentB.addChildren(nodeA, pos: posB);
    checkDataCollect();
  }
  void insertDataWithParent(ChoiceNode nodeA, GenerableParserAndPosition parentB) {
    var parentA = nodeA.parent!;

    parentA.removeChildren(nodeA);
    parentB.addChildren(nodeA);
    checkDataCollect();
  }

  void addDataAll(List<LineSetting> lineList) {
    for (var lineSetting in lineList) {
      addLineSettingData(lineSetting);
    }
    checkDataCollect();
  }

  void removeData(List<int> pos) {
    var node = getChoiceNode(pos)!;
    node.parent!.removeChildren(node);
    checkDataCollect();
  }

  GenerableParserAndPosition? getGenerableParserAndPosition(List<int> pos) {
    if (pos.first >= lineSettings.length) return null;
    GenerableParserAndPosition child = lineSettings[pos.first];
    for (var i = 1; i < pos.length; i++) {
      if (child.children.length <= pos[i]) {
        return null;
      } else if (pos[i] < 0) {
        return null;
      }
      child = child.children[pos[i]];
    }
    return child;
  }

  ChoiceNode? getChoiceNode(List<int> pos) {
    return getGenerableParserAndPosition(pos) as ChoiceNode?;
  }

  LineSetting? getLineSetting(int y) {
    if (lineSettings.length <= y) return null;
    return lineSettings[y];
  }

  void compress() {
    lineSettings.removeWhere((item) => item.children.isEmpty);
    checkDataCollect();
  }

  void checkDataCollect() {
    for (int i = 0; i < lineSettings.length; i++) {
      var line = lineSettings[i];
      line.currentPos = i;
      for (int x = 0; x < line.children.length; x++) {
        line.children[x].currentPos = x;
      }
    }
  }

  void setSelect(List<int> pos) {
    getChoiceNode(pos)?.selectNode();
  }

  bool isSelect(List<int> pos) {
    return getChoiceNode(pos)?.status.isSelected() ?? false;
  }

  void updateStatusAll() {
    VariableDataBase().clear();
    VariableDataBase().varMap.addAll(globalSetting);

    for (var lineSetting in lineSettings) {
      lineSetting.initValueTypeWrapper();

      for (var node in lineSetting.children) {
        node.execute();
        if (node.status.isSelected() && node.isSelectableCheck) {
          lineSetting.execute();
        }
      }
      for (var node in lineSetting.children) {
        node.checkVisible(true);
      }
      bool clickableLineTest = lineSetting.isClickable();
      for (var node in lineSetting.children) {
        node.checkClickable(clickableLineTest, true);
      }
    }
    if(Get.isRegistered<VMDraggableNestedMap>()){
      Get.find<VMDraggableNestedMap>().update();
    }
  }

  void generateRecursiveParser() {
    for (var lineSetting in lineSettings) {
      lineSetting.generateParser();
    }
  }

  void setGlobalSetting(Map<String, ValueTypeWrapper> units) {
    globalSetting.clear();
    globalSetting.addAll(units);
    generateRecursiveParser();
    updateStatusAll();
  }

  void doAllChoiceNode(void Function(ChoiceNode node) action) {
    for (var lineSetting in lineSettings) {
      for (var node in lineSetting.children) {
        doAllChoiceNodeInner(node as ChoiceNode, action);
      }
    }
  }

  void doAllChoiceNodeInner(
      ChoiceNode nodeParent, void Function(ChoiceNode node) action) {
    action(nodeParent);
    if (nodeParent.children.isNotEmpty) {
      for (var node in nodeParent.children) {
        doAllChoiceNodeInner(node as ChoiceNode, action);
      }
    }
  }
}

TextStyle get titleFont => ConstList.getFont(getPlatform.titleFont);
TextStyle get mainFont => ConstList.getFont(getPlatform.mainFont);
Color get baseNodeColor => getPlatform.colorBackground.lighten();