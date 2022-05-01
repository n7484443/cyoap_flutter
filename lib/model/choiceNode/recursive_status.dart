import '../grammar/analyser.dart';
import '../grammar/recursive_parser.dart';

class RecursiveStatus {
  RecursiveUnit? conditionClickableRecursive;
  RecursiveUnit? conditionVisibleRecursive;
  List<RecursiveUnit>? executeCodeRecursive;

  String conditionClickableString = '';
  String conditionVisibleString = '';
  String executeCodeString = '';

  Map<String, dynamic> toJson() => {
        'conditionClickableRecursive': conditionClickableRecursive,
        'conditionVisibleRecursive': conditionVisibleRecursive,
        'executeCodeRecursive': executeCodeRecursive,
        'conditionClickableString': conditionClickableString,
        'conditionVisibleString': conditionVisibleString,
        'executeCodeString': executeCodeString,
      };

  RecursiveStatus();

  RecursiveStatus.fromJson(Map<String, dynamic> json)
      : conditionClickableString = json['conditionClickableString'],
        conditionVisibleString = json['conditionVisibleString'],
        executeCodeString = json['executeCodeString'] {

    if (json['conditionClickableRecursive'] == null) {
      conditionClickableRecursive = null;
    } else {
      conditionClickableRecursive =
          getClassFromJson(json['conditionClickableRecursive']);
    }

    if (json['conditionVisibleRecursive'] == null) {
      conditionVisibleRecursive = null;
    } else {
      conditionVisibleRecursive =
          getClassFromJson(json['conditionVisibleRecursive']);
    }

    if (json['executeCodeRecursive'] == null) {
      executeCodeRecursive = null;
    } else {
      executeCodeRecursive = List.generate(
        (json['executeCodeRecursive'] as List).length,
        (index) {
          return getClassFromJson(
              (json['executeCodeRecursive'] as List)[index]);
        },
      );
    }
  }

  void generateParser() {
    var conditionClickableRecursiveParsed =
        Analyser().analyseCodes(conditionClickableString);
    var conditionVisibleRecursiveParsed =
        Analyser().analyseCodes(conditionVisibleString);
    var executeCodeRecursiveParsed = Analyser().analyseCodes(executeCodeString);

    conditionClickableRecursive = conditionClickableRecursiveParsed.isNotEmpty
        ? conditionClickableRecursiveParsed[0]
        : null;
    conditionVisibleRecursive = conditionVisibleRecursiveParsed.isNotEmpty
        ? conditionVisibleRecursiveParsed[0]
        : null;
    executeCodeRecursive = executeCodeRecursiveParsed;
  }
}
