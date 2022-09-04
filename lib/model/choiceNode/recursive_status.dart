import 'package:json_annotation/json_annotation.dart';

import '../grammar/analyser.dart';
import '../grammar/recursive_parser.dart';

part 'recursive_status.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: false)
class RecursiveStatus {
  RecursiveUnit? conditionClickableRecursive;
  RecursiveUnit? conditionVisibleRecursive;
  RecursiveUnit? executeCodeRecursive;

  String? conditionClickableString;
  String? conditionVisibleString;
  String? executeCodeString;
  RecursiveStatus(
      {this.conditionClickableString,
      this.conditionVisibleString,
      this.executeCodeString});

  RecursiveStatus.fromJson(Map<String, dynamic> json)
      : conditionClickableString = json['conditionClickableString'],
        conditionVisibleString = json['conditionVisibleString'],
        executeCodeString = json['executeCodeString'] {
    try {
      conditionClickableRecursive =
          getClassFromJson(json['conditionClickableRecursive']);
      conditionVisibleRecursive =
          getClassFromJson(json['conditionVisibleRecursive']);
      executeCodeRecursive = getClassFromJson(json['executeCodeRecursive']);
    } catch (e) {
      print(e);
      conditionClickableRecursive = null;
      conditionVisibleRecursive = null;
      executeCodeRecursive = null;
    }
  }

  Map<String, dynamic> toJson() => _$RecursiveStatusToJson(this);

  void generateParser(String pos) {
    conditionClickableRecursive =
        Analyser().analyseSingleLine(conditionClickableString, pos: pos);
    conditionVisibleRecursive =
        Analyser().analyseSingleLine(conditionVisibleString, pos: pos);
    executeCodeRecursive = Analyser().analyseMultiLine(executeCodeString, pos: pos);
  }
}
