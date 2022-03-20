import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';

import '../grammar/value_type.dart';

enum SelectableStatus {
  //isSelectable가 false 인 경우에는 selected와 hide 두가지로 사용
  selected, //선택된 상태
  hide, //숨긴 상태
  open, //선택 가능한 상태
  closed, //약간 흐릿하면서 선택 불가능한 상태
}

extension SelectableStatusExtension on SelectableStatus {
  bool isSelected() {
    return this == SelectableStatus.selected;
  }

  bool isPointerInteractive(bool isSelectable) {
    if (isSelectable) {
      return this == SelectableStatus.selected || this == SelectableStatus.open;
    }
    return false;
  }

  bool isNotSelected() {
    return !isSelected();
  }

  SelectableStatus reverseSelected(bool isSelectable) {
    if (isSelectable) {
      return this == SelectableStatus.selected
          ? SelectableStatus.open
          : SelectableStatus.selected;
    } else {
      return this == SelectableStatus.selected
          ? SelectableStatus.hide
          : SelectableStatus.selected;
    }
  }
}

abstract class GenerableParserAndPosition {
  void generateParser();

  void initValueTypeWrapper();

  Map<String, dynamic> toJson();

  int get currentPos;
  set currentPos(int pos);

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
