import '../grammar/analyser.dart';
import '../grammar/recursive_parser.dart';
import '../grammar/value_type.dart';
import '../variable_db.dart';
import 'generable_parser.dart';

class LineSetting extends GenerableParser{
  int y;
  int maxSelect;
  RecursiveUnit? clickableRecursive;
  RecursiveUnit? executeRecursive;

  LineSetting(this.y, {this.maxSelect = -1});

  Map<String, dynamic> toJson() => {
        'y': y,
        'maxSelect': maxSelect,
        'clickableRecursive': clickableRecursive,
        'executeRecursive': executeRecursive,
      };

  LineSetting.fromJson(Map<String, dynamic> json)
      : y = json['y'],
        maxSelect = json['maxSelect'] ?? -1,
        clickableRecursive = json['clickableRecursive'] == null ? null : getClassFromJson(json['clickableRecursive']),
        executeRecursive = json['executeRecursive'] == null ? null : getClassFromJson(json['executeRecursive']);

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
    if(isNeedToCheck()){
      var conditionClickableRecursiveParsed = Analyser.analyseCodes(getClickableString());
      var executeCodeRecursiveParsed = Analyser.analyseCodes(getExecuteString());

      clickableRecursive = conditionClickableRecursiveParsed.isNotEmpty ? conditionClickableRecursiveParsed[0] : null;
      executeRecursive = executeCodeRecursiveParsed.isNotEmpty ? executeCodeRecursiveParsed[0] : null;
    }else{
      clickableRecursive = null;
      executeRecursive = null;
    }
  }

  @override
  void initValueTypeWrapper() {
    if(isNeedToCheck()) {
      VariableDataBase.instance.setValue('lineSetting_$y',
          ValueTypeWrapper(ValueType(0), false, false));
    }else{
      VariableDataBase.instance.deleteValue('lineSetting_$y');
    }
  }
}