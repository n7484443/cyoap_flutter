import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/platform_system.dart';

const int designSamplePosition = -100;

class AbstractPlatform extends PlayablePlatform {
  void init() {
    checkDataCorrect();
    if (getPlatformFileSystem.isEditable) {
      generateRecursiveParser();
    }
    updateStatusAll();
  }

  AbstractPlatform();

  AbstractPlatform.none();
  AbstractPlatform.fromJson(super.json) : super.fromJson();

  Map<String, dynamic> toJson() {
    Map<String, dynamic> out = {
      'stringImageName': stringImageName,
      'globalSetting': globalSetting.map((e) => [e.$1, e.$2.toJson()]).toList(),
      'version': ConstList.version,
      'fileVersion': super.fileVersion,
    };
    out.addAll(designSetting.toJson());
    return out;
  }

  void addLineSettingData(ChoiceLine lineSetting) {
    while (lineSettings.length <= lineSetting.currentPos) {
      lineSettings.add(ChoiceLine(lineSettings.length));
    }
    lineSettings[lineSetting.currentPos] = lineSetting;
  }

  void addData(Pos pos, ChoiceNode node) {
    while (lineSettings.length <= pos.first) {
      lineSettings.add(ChoiceLine(lineSettings.length));
    }
    var parent = getNode(pos.removeLast())!;
    parent.addChildren(node, pos: pos.last);
    checkDataCorrect();
  }

  void insertData(ChoiceNode nodeA, ChoiceNode nodeB) {
    var parentA = nodeA.parent!;
    var parentB = nodeB.parent!;
    var posB = nodeB.currentPos;

    parentA.removeChildren(nodeA);
    parentB.addChildren(nodeA, pos: posB);
    checkDataCorrect();
  }

  void insertDataWithParent(ChoiceNode nodeA, Choice parentB) {
    var parentA = nodeA.parent!;

    parentA.removeChildren(nodeA);
    parentB.addChildren(nodeA);
    checkDataCorrect();
  }

  void addDataAll(List<ChoiceLine> lineList) {
    for (var lineSetting in lineList) {
      addLineSettingData(lineSetting);
    }
    checkDataCorrect();
  }
  
  void removeChoiceLine(int y) {
    lineSettings.removeAt(y);
    checkDataCorrect();
  }

  @override
  Choice? getNode(Pos pos) {
    if (pos.last == nonPositioned) {
      return createTempNode();
    }
    if (pos.length == 1) return lineSettings[pos.first];
    return getChoiceNode(pos);
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
    updateStatusAll();
  }

  void updateNodePresetNameAll(String before, String after) {
    for (var line in lineSettings) {
      for (var choice in line.children) {
        (choice as ChoiceNode).doAllChild((node) {
          if (node.choiceNodeOption.presetName == before) {
            node.choiceNodeOption =
                node.choiceNodeOption.copyWith(presetName: after);
          }
        });
      }
    }
  }

  void updateLinePresetNameAll(String before, String after) {
    for (var line in lineSettings) {
      if (line.choiceLineOption.presetName == before) {
        line.choiceLineOption =
            line.choiceLineOption.copyWith(presetName: after);
      }
    }
  }
}
