import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';

import '../grammar/analyser.dart';
import '../grammar/recursive_parser.dart';
import '../grammar/value_type.dart';
import '../variable_db.dart';
import 'choice_node.dart';
import 'generable_parser.dart';

class LineSetting extends GenerableParserAndPosition {
  int maxSelect;

  LineSetting(int currentPos, {this.maxSelect = -1}) {
    super.currentPos = currentPos;
    recursiveStatus = RecursiveStatus();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map.addAll({
      'maxSelect': maxSelect,
      //Todo remove after some version
      'clickableRecursive': recursiveStatus.conditionClickableRecursive,
    });
    //Todo remove after some version
    if (recursiveStatus.executeCodeRecursive != null) {
      map['executeRecursive'] = recursiveStatus.executeCodeRecursive![0];
    }
    return map;
  }

  LineSetting.fromJson(Map<String, dynamic> json)
      : maxSelect = json['maxSelect'] ?? -1 {
    super.currentPos = json['y'] ?? json['pos'];
    if (json.containsKey('children')) {
      children.addAll((json['children'] as List)
          .map((e) => ChoiceNodeBase.fromJson(e))
          .toList());
    }
    //recursiveStatus = RecursiveStatus.fromJson(json);
    recursiveStatus = RecursiveStatus();
    recursiveStatus.conditionClickableRecursive =
        json['clickableRecursive'] == null
            ? null
            : getClassFromJson(json['clickableRecursive']);
    var executeRecursive = json['executeRecursive'] == null
        ? null
        : getClassFromJson(json['executeRecursive']);
    if (executeRecursive != null) {
      recursiveStatus.executeCodeRecursive = [executeRecursive];
    }

    for (var element in children) {
      element.parent = this;
    }
  }

  void addData(int x, ChoiceNodeBase node) {
    node.currentPos = x;
    node.parent = this;
    if (x > children.length) {
      children.add(node);
    } else {
      children.insert(x, node);
    }
  }

  ChoiceNodeBase? getData(int x){
    if(children.length <= x) return null;
    return children[x] as ChoiceNodeBase?;
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
          Analyser.analyseCodes(getClickableString());
      var executeCodeRecursiveParsed =
          Analyser.analyseCodes(getExecuteString());

      recursiveStatus.conditionClickableRecursive = conditionClickableRecursiveParsed.isNotEmpty
          ? conditionClickableRecursiveParsed[0]
          : null;
      recursiveStatus.executeCodeRecursive = executeCodeRecursiveParsed.isNotEmpty
          ? executeCodeRecursiveParsed
          : null;
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
      VariableDataBase.instance.setValue('lineSetting_$currentPos',
          ValueTypeWrapper(ValueType(0), false, false));
    } else {
      VariableDataBase.instance.deleteValue('lineSetting_$currentPos');
    }

    for (var node in children) {
      node.initValueTypeWrapper();
    }
  }
}