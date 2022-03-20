import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';

import '../grammar/analyser.dart';
import '../grammar/recursive_parser.dart';
import '../grammar/value_type.dart';
import '../variable_db.dart';
import 'choice_node.dart';
import 'generable_parser.dart';

class LineSetting extends GenerableParserAndPosition {
  int _y;

  @override
  int get currentPos => _y;

  int maxSelect;
  List<ChoiceNodeBase> children;

  LineSetting(this._y, {this.maxSelect = -1})
      : children = List.empty(growable: true) {
    recursiveStatus = RecursiveStatus();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'y': _y,
      'maxSelect': maxSelect,
      'clickableRecursive': recursiveStatus.conditionClickableRecursive,
      'children': children,
    };
    if(recursiveStatus.executeCodeRecursive != null){
      map['executeRecursive'] = recursiveStatus.executeCodeRecursive![0];
    }
    map.addAll(recursiveStatus.toJson());
    return map;
  }

  LineSetting.fromJson(Map<String, dynamic> json)
      : _y = json['y'],
        maxSelect = json['maxSelect'] ?? -1,
        children = json.containsKey('children')
            ? (json['children'] as List)
                .map((e) => ChoiceNodeBase.fromJson(e))
                .toList()
            : List.empty(growable: true) {
    //recursiveStatus = RecursiveStatus.fromJson(json);
    recursiveStatus = RecursiveStatus();
    recursiveStatus.conditionClickableRecursive =
        json['clickableRecursive'] == null
            ? null
            : getClassFromJson(json['clickableRecursive']);
    var executeRecursive = json['executeRecursive'] == null
        ? null
        : getClassFromJson(json['executeRecursive']);
    if(executeRecursive != null){
      recursiveStatus.executeCodeRecursive = [executeRecursive];
    }

    for (var element in children) {
      element.parent = this;
    }
  }

  void addData(int x, ChoiceNodeBase node) {
    node.x = x;
    node.parent = this;
    if (x > children.length) {
      children.add(node);
    } else {
      children.insert(x, node);
    }
  }

  ChoiceNodeBase? getData(int x){
    if(children.length <= x) return null;
    return children[x];
  }

  String getClickableString() {
    return 'lineSetting_$_y < $maxSelect';
  }

  String getExecuteString() {
    return 'lineSetting_$_y += 1';
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
      VariableDataBase.instance.setValue(
          'lineSetting_$_y', ValueTypeWrapper(ValueType(0), false, false));
    } else {
      VariableDataBase.instance.deleteValue('lineSetting_$_y');
    }

    for (var node in children) {
      node.initValueTypeWrapper();
    }
  }
}
