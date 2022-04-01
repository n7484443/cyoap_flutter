import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:flutter/material.dart';

import '../util/version.dart';
import 'choiceNode/choice_line.dart';
import 'choiceNode/generable_parser.dart';
import 'grammar/value_type.dart';

class AbstractPlatform {
  double scale = 1.0;
  String stringImageName;
  Color colorBackground;
  int flag;
  List<LineSetting> lineSettings = List.empty(growable: true);
  Map<String, ValueTypeWrapper> globalSetting = {};
  String version;

  String titleFont;
  String mainFont;

  bool isVisibleSource = false;

  void init() {
    checkDataCollect();
    if (getPlatformFileSystem().isEditable) {
      generateRecursiveParser();
    }
    updateSelectable();
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

  void addData(List<int> pos, ChoiceNodeBase node) {
    while (lineSettings.length <= pos[0]) {
      lineSettings.add(LineSetting(lineSettings.length));
    }
    lineSettings[pos[0]].addData(pos[1], node);
  }

  void addDataAll(List<LineSetting> lineList) {
    for (var lineSetting in lineList) {
      addLineSettingData(lineSetting);
    }
  }

  void removeData(List<int> pos) {
    var node = getChoiceNode(pos);
    node?.parent?.removeChildren(node);
    checkDataCollect();
  }

  ChoiceNodeBase? getChoiceNode(List<int> pos) {
    GenerableParserAndPosition child = lineSettings[pos[0]];
    for(var i = 1; i < pos.length; i++){
      if(child.children.length <= pos[i]) {
        return null;
      }
      child = child.children[pos[i]];
    }
    return child as ChoiceNodeBase?;
  }

  LineSetting? getLineSetting(int y) {
    if (lineSettings.length <= y) return null;
    return lineSettings[y];
  }

  void changeData(List<int> start, List<int> pos) {
    var node = getChoiceNode(start)!;
    removeData(start);
    addData(pos, node);
    checkDataCollect();
  }

  void changeDataFromList(List<int> start, List<int> pos) {
    var node = getChoiceNode(start)!;
    removeData(start);
    addData(pos, node);
    checkDataCollect();
  }

  void compress() {
    lineSettings.removeWhere((item) => item.children.isEmpty);
    checkDataCollect();
  }

  void checkDataCollect() {
    for (var line in lineSettings) {
      for (int x = 0; x < line.children.length; x++) {
        line.children[x].currentPos = x;
      }
    }
  }

  void setSelect(int posX, int posY) {
    getChoiceNode([posY, posX])?.selectNode();
    updateSelectable();
  }

  bool isSelect(int posX, int posY) {
    return getChoiceNode([posY, posX])?.status.isSelected() ?? false;
  }

  void updateSelectable() {
    VariableDataBase.instance.clear();

    VariableDataBase.instance.varMap.addAll(globalSetting);
    for (var lineSetting in lineSettings) {
      lineSetting.initValueTypeWrapper();

      for (var node in lineSetting.children) {
        if (node.status.isSelected()) {
          node.execute();
          if (node.isSelectableCheck) {
            lineSetting.execute();
          }
        }
      }
      for (var node in lineSetting.children) {
        var visible = node.isVisible();
        if (node.status != SelectableStatus.selected) {
          if (!visible) {
            node.status = SelectableStatus.hide;
          }
          (node as ChoiceNodeBase).updateSelectValueTypeWrapper();
        }
      }

      bool clickableLineTest = lineSetting.isClickable();

      for (var node in lineSetting.children) {
        var selectable = node.isClickable();
        if (node.isSelectableCheck) {
          if (node.status != SelectableStatus.selected &&
              node.status != SelectableStatus.hide) {
            selectable &= clickableLineTest;
            node.status =
                selectable ? SelectableStatus.open : SelectableStatus.closed;
          }
        } else {
          node.status = SelectableStatus.selected;
        }

        (node as ChoiceNodeBase).updateSelectValueTypeWrapper();
      }
    }
  }

  void generateRecursiveParser() {
    for(var lineSetting in lineSettings){
      lineSetting.generateParser();
    }
  }

  void setGlobalSetting(Map<String, ValueTypeWrapper> units) {
    globalSetting.clear();
    globalSetting.addAll(units);
    generateRecursiveParser();
    updateSelectable();
  }

  void doAllChoiceNode(void Function(ChoiceNodeBase node) action) {
    for (var lineSetting in lineSettings) {
      for (var node in lineSetting.children) {
        doAllChoiceNodeInner(node as ChoiceNodeBase, action);
      }
    }
  }

  void doAllChoiceNodeInner(
      ChoiceNodeBase nodeParent, void Function(ChoiceNodeBase node) action) {
    for (var node in nodeParent.children) {
      action(node as ChoiceNodeBase);
      doAllChoiceNodeInner(node, action);
    }
  }
}
