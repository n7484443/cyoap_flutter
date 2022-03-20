import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';

import '../grammar/value_type.dart';

abstract class GenerableParserAndPosition {
  void generateParser();

  void initValueTypeWrapper();

  Map<String, dynamic> toJson();

  int get currentPos;

  GenerableParserAndPosition? parent;
  late RecursiveStatus recursiveStatus;

  void execute() {
    if (recursiveStatus.executeCodeRecursive != null) {
      for (var codes in recursiveStatus.executeCodeRecursive!) {
        codes.unzip();
      }
    }
  }

  bool isVisible() {
    if (recursiveStatus.conditionVisibleRecursive != null) {
      var data = recursiveStatus.conditionVisibleRecursive!.unzip().dataUnzip();
      if (data != null) {
        if (data is bool) {
          return data;
        } else if (data is ValueTypeWrapper) {
          return data.valueType.data is bool ? data.valueType.data : true;
        }
      }
    }
    return true;
  }

  bool isClickable() {
    if (recursiveStatus.conditionClickableRecursive != null) {
      var data =
          recursiveStatus.conditionClickableRecursive!.unzip().dataUnzip();
      if (data != null) {
        if (data is bool) {
          return data;
        } else if (data is ValueTypeWrapper) {
          return data.valueType.data is bool ? data.valueType.data : true;
        }
      }
    }
    return true;
  }
  String get tag => parent == null ? "$currentPos" : "${parent?.tag}:$currentPos";
}
