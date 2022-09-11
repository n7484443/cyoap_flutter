import 'package:json_annotation/json_annotation.dart';

import '../grammar/analyser.dart';

part 'recursive_status.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: false)
class RecursiveStatus {
  List<String> conditionClickableRecursive;
  List<String> conditionVisibleRecursive;
  List<String> executeCodeRecursive;

  String? conditionClickableString;
  String? conditionVisibleString;
  String? executeCodeString;
  RecursiveStatus(
      {this.conditionClickableString,
      this.conditionVisibleString,
      this.executeCodeString}):
        conditionClickableRecursive = [],
        conditionVisibleRecursive = [],
        executeCodeRecursive = [];

  RecursiveStatus.fromJson(Map<String, dynamic> json)
      : conditionClickableString = json['conditionClickableString'],
        conditionVisibleString = json['conditionVisibleString'],
        executeCodeString = json['executeCodeString'],
        conditionClickableRecursive = json['conditionClickableRecursive'] ?? [],
        conditionVisibleRecursive = json['conditionVisibleRecursive'] ?? [],
        executeCodeRecursive = json['executeCodeRecursive'] ?? [];

  Map<String, dynamic> toJson() => _$RecursiveStatusToJson(this);

  void generateParser(String pos) {
    conditionClickableRecursive =
        Analyser().analyseSingleLine(conditionClickableString, pos: pos);
    conditionVisibleRecursive =
        Analyser().analyseSingleLine(conditionVisibleString, pos: pos);
    executeCodeRecursive = Analyser().analyseMultiLine(executeCodeString, pos: pos);
  }
}
