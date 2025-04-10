import 'dart:collection';

import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'clipboard.dart';

const int designSamplePosition = -100;

class EditablePlatform extends PlayablePlatform {
  Clipboard clipboard;

  ListQueue<Color> lastColorList = ListQueue.from(List.filled(10, Colors.black));

  void addLastColor(Color color) {
    if (lastColorList.contains(color)) {
      lastColorList.remove(color);
    } else {
      lastColorList.removeLast();
    }
    lastColorList.addFirst(color);
  }

  Map<int, Color> getLastColor(Color color) {
    var lastColorMap = getPlatform.lastColorList.toList().asMap();
    return lastColorMap.map((key, value) => MapEntry(key == 0 ? 50 : key * 100, value));
  }

  void init() {
    checkDataCorrect();
    if (getPlatformFileSystem.isEditable) {
      generateRecursiveParser();
    }
    updateStatus();
  }

  EditablePlatform.none()
      : clipboard = Clipboard(ConstList.clipboardMaximumCapacity),
        super();

  EditablePlatform.fromJson(Map<String, dynamic> json)
      : clipboard = Clipboard.fromJson(json['clipboard'] ?? {}),
        super.fromJson(json) {
    if (json['lastColorList'] != null) {
      lastColorList = ListQueue.from((json['lastColorList'] as List).map((e) => Color(e)).toList());
    } else {
      lastColorList = ListQueue.from(List.filled(10, Colors.black));
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> out = {
      'stringImageName': stringImageName,
      'globalSetting': globalSetting.map((e) => [e.$1, e.$2.toJson()]).toList(),
      'currentFileVersion': super.currentFileVersion,
      'lastColorList': lastColorList.map((e) => e.value).toList(),
      'clipboard': clipboard.toJson(),
    };
    out.addAll(designSetting.toJson());
    return out;
  }

  void addLineSettingData(ChoiceLine choiceLine, int y) {
    while (choicePage.choiceLines.length <= y) {
      choicePage.addChild(this, ChoiceLine());
    }
    choiceLine.parent = choicePage;
    choicePage.choiceLines[y] = choiceLine;
  }

  void addData(Pos pos, Choice node) {
    Choice parent = choicePage;
    for (int i = 1; i < pos.data.length - 1; i++) {
      while (parent.children.length <= pos.data[i]) {
        if (i == 1) {
          parent.addChild(this, ChoiceLine());
        } else {
          parent.addChild(this, ChoiceNode.empty());
        }
      }
      parent = parent.children[pos.data[i]];
    }
    parent.addChild(this, node, pos: pos.last);
    checkDataCorrect();
  }

  void insertData(Choice a, Choice b) {
    var parentA = a.parent!;
    var parentB = b.parent!;
    var posB = b.currentPos;

    parentA.removeChildren(a);
    parentB.addChild(this, a, pos: posB);
    checkDataCorrect();
  }

  void insertDataWithParent(Choice a, Choice parentB) {
    a.parent?.removeChildren(a);
    parentB.addChild(this, a);
    checkDataCorrect();
  }

  void addDataAll(List<(ChoiceLine, int)> lineList) {
    for (var (lineSetting, y) in lineList) {
      addLineSettingData(lineSetting, y);
    }
    checkDataCorrect();
  }

  void removeChoiceLine(int y) {
    choicePage.choiceLines.removeAt(y);
    checkDataCorrect();
  }

  @override
  Choice? getChoice(Pos pos) {
    if (pos.last == nonPositioned) {
      return createTempNode();
    }
    return super.getChoice(pos);
  }

  ChoiceNode createTempNode() {
    return ChoiceNode.empty()..width = 3;
  }

  ChoiceNode removeData(Pos pos) {
    var node = getChoiceNode(pos)!;
    node.parent!.removeChildren(node);
    checkDataCorrect();
    return node;
  }

  void setGlobalSetting(List<(String, ValueTypeWrapper)> units) {
    clearGlobalSetting();
    for (var unit in units) {
      addGlobalSetting(unit.$1, unit.$2);
    }
    generateRecursiveParser();
    updateStatus();
  }

  void updateNodePresetNameAll(String before, String after) {
    for (var line in choicePage.choiceLines) {
      for (var choice in line.children) {
        (choice as ChoiceNode).recursiveFunction((node) {
          if ((node as ChoiceNode).choiceNodeOption.presetName == before) {
            node.choiceNodeOption = node.choiceNodeOption.copyWith(presetName: after);
          }
          return true;
        });
      }
    }
  }

  void updateLinePresetNameAll(String before, String after) {
    for (var line in choicePage.choiceLines) {
      if (line.choiceLineOption.presetName == before) {
        line.choiceLineOption = line.choiceLineOption.copyWith(presetName: after);
      }
    }
  }
}
