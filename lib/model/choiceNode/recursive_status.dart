import 'package:cyoap_core/grammar/analyser.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recursive_status.g.dart';

@JsonSerializable(explicitToJson: true)
class RecursiveStatus {
  @JsonKey(defaultValue: [])
  List<String> conditionClickableCode = [];
  @JsonKey(defaultValue: [])
  List<String> conditionVisibleCode = [];
  @JsonKey(defaultValue: [])
  List<String> executeCode = [];

  String? conditionClickableString;
  String? conditionVisibleString;
  String? executeCodeString;

  RecursiveStatus({
    this.conditionClickableString,
    this.conditionVisibleString,
    this.executeCodeString,
  });

  factory RecursiveStatus.fromJson(Map<String, dynamic> json) =>
      _$RecursiveStatusFromJson(json);

  Map<String, dynamic> toJson() => _$RecursiveStatusToJson(this);

  void generateParser(String pos) {
    conditionClickableCode =
        Analyser().analyseSingleLine(conditionClickableString, pos: pos);
    conditionVisibleCode =
        Analyser().analyseSingleLine(conditionVisibleString, pos: pos);
    executeCode = Analyser().analyseMultiLine(executeCodeString, pos: pos);
  }
}
