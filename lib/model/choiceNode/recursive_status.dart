import '../grammar/analyser.dart';
import '../grammar/recursive_parser.dart';

class RecursiveStatus {
  RecursiveUnit? conditionClickableRecursive;
  RecursiveUnit? conditionVisibleRecursive;
  RecursiveUnit? executeCodeRecursive;

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
    try {
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
        executeCodeRecursive = getClassFromJson(json['executeCodeRecursive']);
      }
    } catch (e) {
      print(e);
      conditionClickableRecursive = null;
      conditionVisibleRecursive = null;
      executeCodeRecursive = null;
    }
  }

  void generateParser() {
    conditionClickableRecursive =
        Analyser().analyseCodes(conditionClickableString);
    conditionVisibleRecursive = Analyser().analyseCodes(conditionVisibleString);
    executeCodeRecursive = Analyser().analyseCodes(executeCodeString);
  }
}
