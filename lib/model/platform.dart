import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/generable_parser.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/design_setting.dart';
import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/model/platform_system.dart';

class AbstractPlatform {
  String? stringImageName;
  List<LineSetting> lineSettings = List.empty(growable: true);
  Map<String, ValueTypeWrapper> globalSetting = {};

  PlatformDesignSetting designSetting = PlatformDesignSetting();

  void init() {
    checkDataCorrect();
    if (getPlatformFileSystem.isEditable) {
      generateRecursiveParser();
    }
    updateStatusAll();
  }

  AbstractPlatform();

  AbstractPlatform.none();

  AbstractPlatform.fromJson(Map<String, dynamic> json)
      : stringImageName = json['stringImageName'] ?? '',
        globalSetting = (json['globalSetting'] as Map)
            .map((k, v) => MapEntry(k, ValueTypeWrapper.fromJson(v))),
        designSetting = PlatformDesignSetting.fromJson(json);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> out = {
      'stringImageName': stringImageName,
      'globalSetting': globalSetting,
    };
    out.addAll(designSetting.toJson());
    return out;
  }

  void addLineSettingData(LineSetting lineSetting) {
    while (lineSettings.length <= lineSetting.currentPos) {
      lineSettings.add(LineSetting(lineSettings.length));
    }
    lineSettings[lineSetting.currentPos] = lineSetting;
  }

  void addData(Pos pos, ChoiceNode node) {
    while (lineSettings.length <= pos.first) {
      lineSettings.add(LineSetting(lineSettings.length));
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
      ChoiceNode nodeA, GenerableParserAndPosition parentB) {
    var parentA = nodeA.parent!;

    parentA.removeChildren(nodeA);
    parentB.addChildren(nodeA);
    checkDataCorrect();
  }

  void addDataAll(List<LineSetting> lineList) {
    for (var lineSetting in lineList) {
      addLineSettingData(lineSetting);
    }
    checkDataCorrect();
  }

  GenerableParserAndPosition? getNode(Pos pos) {
    if (pos.first == designSamplePosition0) {
      return ChoiceNode(
        1,
        true,
        "디자인",
        "[{\"insert\":\"레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
        "noImage",
      )..currentPos = -1;
    }
    if (pos.first == designSamplePosition1) {
      return ChoiceNode(
        1,
        false,
        "디자인(바깥 라운드 X, 카드 모드 X)",
        "[{\"insert\":\"레이아웃과 폰트, 디자인, 크기 등을 조정하고 확인할 수 있습니다.\\n\"}]",
        "noImage",
      )
        ..isRound = false
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

  GenerableParserAndPosition? getGenerableParserAndPosition(Pos pos) {
    if (pos.first >= lineSettings.length) return null;
    GenerableParserAndPosition child = lineSettings[pos.first];
    for (var i = 1; i < pos.length; i++) {
      if (child.children.length <= pos.data[i]) {
        return null;
      } else if (pos.data[i] < 0) {
        return null;
      }
      child = child.children[pos.data[i]];
    }
    return child;
  }

  ChoiceNode? getChoiceNode(Pos pos) {
    return getGenerableParserAndPosition(pos) as ChoiceNode?;
  }

  LineSetting? getLineSetting(int y) {
    if (lineSettings.length <= y) return null;
    return lineSettings[y];
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

  void updateStatusAll({int startLine = 0}) {
    VariableDataBase().clear();
    VariableDataBase().varMapGlobal.addAll(globalSetting);
    var t = Stopwatch()..start();
    for (var i = startLine; i < lineSettings.length; i++) {
      var lineSetting = lineSettings[i];
      lineSetting.initValueTypeWrapper();
      lineSetting.execute();
      lineSetting.checkVisible(true);
      lineSetting.checkClickable(true, true);
      VariableDataBase().clearLocalVariable();
    }
    print(t.elapsedMicroseconds);
    t.reset();
    t.stop();
  }

  void generateRecursiveParser() {
    for (var lineSetting in lineSettings) {
      lineSetting.generateParser();
    }
  }

  void setGlobalSetting(Map<String, ValueTypeWrapper> units) {
    globalSetting = Map.from(units);
    generateRecursiveParser();
    updateStatusAll();
  }
}
