import '../grammar/recursive_parser.dart';

class LineSetting {
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
}