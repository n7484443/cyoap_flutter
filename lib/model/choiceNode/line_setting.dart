import '../grammar/analyser.dart';
import '../grammar/recursive_parser.dart';
import '../grammar/value_type.dart';
import '../variable_db.dart';
import 'choice_node.dart';
import 'generable_parser.dart';

class LineSetting extends GenerableParserAndPosition {
  int y;
  @override
  int get currentPos => y;

  int maxSelect;
  RecursiveUnit? clickableRecursive;
  RecursiveUnit? conditionVisibleRecursive;
  RecursiveUnit? executeRecursive;
  String conditionVisibleString = '';
  List<ChoiceNodeBase> children;

  LineSetting(this.y, {this.maxSelect = -1})
      : children = List.empty(growable: true);

  @override
  Map<String, dynamic> toJson() => {
        'y': y,
        'maxSelect': maxSelect,
        'clickableRecursive': clickableRecursive,
        'executeRecursive': executeRecursive,
        'children': children,
      };

  LineSetting.fromJson(Map<String, dynamic> json)
      : y = json['y'],
        maxSelect = json['maxSelect'] ?? -1,
        clickableRecursive = json['clickableRecursive'] == null
            ? null
            : getClassFromJson(json['clickableRecursive']),
        executeRecursive = json['executeRecursive'] == null
            ? null
            : getClassFromJson(json['executeRecursive']),
        children = json.containsKey('children')
            ? (json['children'] as List).map((e) => ChoiceNodeBase.fromJson(e)).toList()
            : List.empty(growable: true);


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
    return 'lineSetting_$y < $maxSelect';
  }

  String getExecuteString() {
    return 'lineSetting_$y += 1';
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

      clickableRecursive = conditionClickableRecursiveParsed.isNotEmpty
          ? conditionClickableRecursiveParsed[0]
          : null;
      executeRecursive = executeCodeRecursiveParsed.isNotEmpty
          ? executeCodeRecursiveParsed[0]
          : null;
    } else {
      clickableRecursive = null;
      executeRecursive = null;
    }

    for (var node in children) {
      node.generateParser();
    }
  }

  @override
  void initValueTypeWrapper() {
    if (isNeedToCheck()) {
      VariableDataBase.instance.setValue(
          'lineSetting_$y', ValueTypeWrapper(ValueType(0), false, false));
    } else {
      VariableDataBase.instance.deleteValue('lineSetting_$y');
    }

    for (var node in children) {
      node.initValueTypeWrapper();
    }
  }
}
