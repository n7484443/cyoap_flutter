import 'package:cyoap_flutter/model/choiceNode/pos.dart';
import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';

import '../../util/platform_specified_util/platform_specified.dart';
import '../grammar/analyser.dart';
import '../grammar/value_type.dart';
import 'choice_status.dart';

abstract class GenerableParserAndPosition {
  ChoiceStatus choiceStatus = ChoiceStatus();

  void generateParser() {
    recursiveStatus.generateParser(errorName);
    for (var child in children) {
      child.generateParser();
    }
  }

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

  int currentPos = 0;
  int width = 12;

  List<GenerableParserAndPosition> children = List.empty(growable: true);

  GenerableParserAndPosition? parent;
  late RecursiveStatus recursiveStatus;

  bool get isSelectableMode => true;
  bool get isHide => choiceStatus.isHide();

  void execute() {
    if (choiceStatus.isSelected()) {
      Analyser().run(recursiveStatus.executeCodeRecursive, pos: errorName);
      for (var child in children) {
        child.execute();
      }
    }
  }

  bool analyseVisibleCode() {
    var data = Analyser().check(recursiveStatus.conditionVisibleRecursive, pos: errorName);
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
    if (!parent) {
      choiceStatus = choiceStatus.copyWith(visible: false);
    } else {
      choiceStatus = choiceStatus.copyWith(visible: analyseVisibleCode());
    }

    for (var child in children) {
      child.checkVisible(choiceStatus.visible);
    }
  }

  bool isClickable() {
    var data = Analyser().check(recursiveStatus.conditionClickableRecursive, pos: errorName);
    if (data != null) {
      if (data is bool) {
        return data;
      } else if (data is ValueTypeWrapper) {
        return data.valueType.data is bool ? data.valueType.data : true;
      }
    }
    return true;
  }

  void checkClickable(bool parent, bool onlyWorkLine) {
    if (!onlyWorkLine && !parent) {
      choiceStatus = choiceStatus.copyWith(
          status:
              analyseVisibleCode() ? SelectableStatus.closed : SelectableStatus.hide);
    } else {
      var selectable = isClickable();
      if (isSelectableMode) {
        if (choiceStatus.isNotSelected() && !choiceStatus.isHide()) {
          selectable &= parent;
          choiceStatus = choiceStatus.copyWith(
              status:
                  selectable ? SelectableStatus.open : SelectableStatus.closed);
        }
      }
    }
    for (var child in children) {
      child.checkClickable(choiceStatus.isSelected(), false);
    }
  }

  Pos get pos {
    var posList = parent?.pos ?? Pos();
    return posList.addLast(currentPos);
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

  String? convertToWebp(String? name) {
    if (name == null) return null;
    return PlatformSpecified().saveProject!.convertImageName(name);
  }

  String get errorName => pos.toString();
}
