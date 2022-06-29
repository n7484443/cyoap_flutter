import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';

import '../grammar/analyser.dart';
import '../grammar/value_type.dart';
import '../variable_db.dart';
import 'choice_node.dart';
import 'generable_parser.dart';

class LineSetting extends GenerableParserAndPosition {
  int maxSelect;
  bool alwaysVisible;

  LineSetting(int currentPos,
      {this.alwaysVisible = true, this.maxSelect = -1}) {
    super.currentPos = currentPos;
    recursiveStatus = RecursiveStatus();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map.addAll({
      'maxSelect': maxSelect,
      'alwaysVisible': alwaysVisible,
    });
    return map;
  }

  LineSetting.fromJson(Map<String, dynamic> json)
      : maxSelect = json['maxSelect'] ?? -1,
        alwaysVisible = json['alwaysVisible'] ?? true {
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

  String getClickableString() {
    return 'lineSetting_$currentPos < $maxSelect';
  }

  String getExecuteString() {
    return 'lineSetting_$currentPos += 1';
  }

  bool isNeedToCheck() {
    return maxSelect > 0;
  }

  @override
  void generateParser() {
    if (isNeedToCheck()) {
      var conditionClickableRecursiveParsed =
          Analyser().analyseSingleLine(getClickableString());
      var executeCodeRecursiveParsed =
          Analyser().analyseCodes(getExecuteString());
      recursiveStatus.conditionClickableRecursive =
          conditionClickableRecursiveParsed;
      recursiveStatus.executeCodeRecursive = executeCodeRecursiveParsed;
    } else {
      recursiveStatus.conditionClickableRecursive = null;
      recursiveStatus.executeCodeRecursive = null;
    }

    for (var node in children) {
      node.generateParser();
    }
  }

  @override
  void initValueTypeWrapper() {
    if (isNeedToCheck()) {
      VariableDataBase().setValue(
          'lineSetting_$currentPos', ValueTypeWrapper(ValueType(0), false));
    } else {
      VariableDataBase().deleteValue('lineSetting_$currentPos');
    }

    for (var node in children) {
      node.initValueTypeWrapper();
    }
  }

  @override
  void execute() {
    Analyser().run(recursiveStatus.executeCodeRecursive);
  }
}
