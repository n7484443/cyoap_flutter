import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_flutter/model/platform_system.dart';

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

  AbstractPlatform.fromJson(Map<String, dynamic> json) {
    stringImageName = json['stringImageName'] ?? '';
    globalSetting = (json['globalSetting'] as Map)
        .map((k, v) => MapEntry(k, ValueTypeWrapper.fromJson(v)));
    designSetting = PlatformDesignSetting.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> out = {
      'stringImageName': stringImageName,
      'globalSetting': globalSetting,
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

  void insertDataWithParent(
      ChoiceNode nodeA, Choice parentB) {
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

  @override
  Choice? getNode(Pos pos) {
    if (pos.first == designSamplePosition0) {
      return ChoiceNode(
        1,
        "디자인",
        "[{\"insert\":\"레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
        "noImage",
      )..currentPos = -1;
    }
    if (pos.first == designSamplePosition1) {
      return ChoiceNode(
        1,
        "디자인(바깥 라운드 X, 카드 모드 X)",
        "[{\"insert\":\"레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
        "noImage",
      )
        ..choiceNodeDesign = ChoiceNodeDesign(isRound: false, isCard: false)
        ..currentPos = -2
        ..select = 1;
    }
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

  void compress() {
    lineSettings.removeWhere((item) => item.children.isEmpty);
    checkDataCorrect();
  }

  void checkDataCorrect() {
    for (int i = 0; i < lineSettings.length; i++) {
      var line = lineSettings[i];
      line.currentPos = i;
      for (int x = 0; x < line.children.length; x++) {
        line.children[x].currentPos = x;
      }
    }
  }

  void setGlobalSetting(Map<String, ValueTypeWrapper> units) {
    globalSetting = Map.from(units);
    generateRecursiveParser();
    updateStatusAll();
  }
}
