import 'dart:ui';

import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';

import '../grammar/analyser.dart';
import '../grammar/value_type.dart';
import '../variable_db.dart';
import 'choice_node.dart';
import 'generable_parser.dart';

class LineSetting extends GenerableParserAndPosition {
  int maxSelect;
  bool alwaysVisible;
  Color? backgroundColor;
  String? backgroundImageString;

  LineSetting(int currentPos,
      {this.alwaysVisible = true,
      this.maxSelect = -1,
      this.backgroundImageString}) {
    super.currentPos = currentPos;
    recursiveStatus = RecursiveStatus();
  }
  @override
  bool operator ==(Object other){
    return other is LineSetting &&
        super == other &&
        maxSelect == other.maxSelect &&
        alwaysVisible == other.alwaysVisible &&
        backgroundColor == other.backgroundColor &&
        backgroundImageString == other.backgroundImageString;
  }

  @override
  int get hashCode => Object.hash(maxSelect, alwaysVisible, backgroundColor, backgroundImageString, super.hashCode);

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map.addAll({
      'maxSelect': maxSelect,
      'alwaysVisible': alwaysVisible,
      'backgroundColor': backgroundColor?.value,
      'backgroundImageString': convertToWebp(backgroundImageString),
    });
    return map;
  }

  LineSetting.fromJson(Map<String, dynamic> json)
      : maxSelect = json['maxSelect'] ?? -1,
        alwaysVisible = json['alwaysVisible'] ?? true,
        backgroundColor = json['backgroundColor'] == null
            ? null
            : Color(json['backgroundColor']),
        backgroundImageString = json['backgroundImageString'] {
    super.currentPos = json['y'] ?? json['pos'];
    if (json.containsKey('children')) {
      children.addAll((json['children'] as List)
          .map((e) => ChoiceNode.fromJson(e))
          .toList());
    }
    recursiveStatus = RecursiveStatus.fromJson(json);
    for (var element in children) {
      element.parent = this;
    }
  }

  void addData(int x, ChoiceNode node) {
    node.currentPos = x;
    node.parent = this;
    if (x > children.length) {
      children.add(node);
    } else {
      children.insert(x, node);
    }
  }

  ChoiceNode? getData(int x) {
    if (children.length <= x) return null;
    return children[x] as ChoiceNode?;
  }

  String get valName => 'lineSetting_$currentPos';

  @override
  void generateParser() {
    recursiveStatus.executeCodeString = '$valName += 1';
    if (isNeedToCheck()) {
      recursiveStatus.conditionClickableString = '$valName < $maxSelect';
    } else {
      recursiveStatus.conditionClickableString = 'true';
    }
    super.generateParser();
  }

  bool isNeedToCheck() {
    return maxSelect > 0;
  }

  @override
  void initValueTypeWrapper() {
    if (isNeedToCheck()) {
      VariableDataBase().setValue(valName, ValueTypeWrapper(ValueType(0)));
    } else {
      VariableDataBase().deleteValue(valName);
    }

    for (var node in children) {
      node.initValueTypeWrapper();
    }
  }

  @override
  void checkClickable(bool parent, bool onlyWorkLine) {
    for (var child in children) {
      child.checkClickable(isClickable(), true);
    }
  }

  @override
  void execute() {
    for (var node in children) {
      node.execute();
      if (node.choiceStatus.isSelected() && node.isSelectableMode) {
        Analyser().run(recursiveStatus.executeCodeRecursive);
      }
    }
  }


}
