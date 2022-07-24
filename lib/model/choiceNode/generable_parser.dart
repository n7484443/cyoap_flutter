import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';

import '../grammar/analyser.dart';
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

  bool isHide() {
    return this == SelectableStatus.hide;
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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'width': width,
      'pos': currentPos,
      'children': children,
    };

    map.addAll(recursiveStatus.toJson());
    return map;
  }

  SelectableStatus status = SelectableStatus.open;

  int currentPos = 0;
  int width = 12;

  List<GenerableParserAndPosition> children = List.empty(growable: true);

  GenerableParserAndPosition? parent;
  late RecursiveStatus recursiveStatus;

  bool get isSelectableMode => true;

  void execute() {
    if (status.isSelected()) {
      Analyser().run(recursiveStatus.executeCodeRecursive);
      for (var child in children) {
        child.execute();
      }
    }
  }

  bool isVisible() {
    var data = Analyser().check(recursiveStatus.conditionVisibleRecursive);
    if (data != null) {
      if (data is bool) {
        return data;
      } else if (data is ValueTypeWrapper) {
        return data.valueType.data is bool ? data.valueType.data : true;
      }
    }
    return true;
  }

  void checkVisible(bool parent) {
    if (!parent || !isVisible()) {
      status = SelectableStatus.hide;
    }

    for (var child in children) {
      child.checkVisible(!status.isHide());
    }
  }

  bool isClickable() {
    var data = Analyser().check(recursiveStatus.conditionClickableRecursive);
    if (data != null) {
      if (data is bool) {
        return data;
      } else if (data is ValueTypeWrapper) {
        return data.valueType.data is bool ? data.valueType.data : true;
      }
    }
    return true;
  }

  void checkClickable(bool parentClickable, bool onlyWorkLine) {
    if (!onlyWorkLine && !parentClickable) {
      status = isVisible() ? SelectableStatus.closed : SelectableStatus.hide;
    } else {
      var selectable = isClickable();
      if (isSelectableMode) {
        if (status != SelectableStatus.selected &&
            status != SelectableStatus.hide) {
          selectable &= parentClickable;
          status = selectable ? SelectableStatus.open : SelectableStatus.closed;
        }
      }
    }
    for (var child in children) {
      child.checkClickable(status.isSelected(), false);
    }
  }

  String get tag =>
      parent == null ? "$currentPos" : "${parent!.tag}:$currentPos";

  List<int> pos({List<int>? posList}) {
    if (posList == null) {
      posList = List.empty(growable: true);
    } else {
      posList = List.from(posList);
    }
    if (parent != null) {
      posList.addAll(parent!.pos(posList: posList));
    }
    posList.add(currentPos);
    return posList;
  }

  void addChildren(GenerableParserAndPosition childNode, {int? pos}) {
    pos ??= children.length;
    childNode.parent = this;
    childNode.width = childNode.width.clamp(0, width);
    children.insert(pos, childNode);
    for (int i = 0; i < children.length; i++) {
      children[i].currentPos = i;
    }
  }

  void removeChildren(GenerableParserAndPosition childNode) {
    childNode.parent = null;
    if (children.length > childNode.currentPos) {
      children.removeAt(childNode.currentPos);
    }
    childNode.currentPos = 0;
    for (int i = 0; i < children.length; i++) {
      children[i].currentPos = i;
    }
  }
}
