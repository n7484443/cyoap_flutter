import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:visibility_detector/visibility_detector.dart';

part 'vm_choice_page_edit.g.dart';

class ChoicePageFindUtil {
  static final ChoicePageFindUtil _instance = ChoicePageFindUtil._();

  factory ChoicePageFindUtil() => _instance;

  ChoicePageFindUtil._();

  List<Pos> posList = [];
  BuildContext? context;
  Pos? target;

  void clear() {
    context = null;
    target = null;
    posList.clear();
    VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 500);
  }

  void updatePos() {
    posList.sort();
  }

  void addPos(Pos pos, BuildContext context) {
    posList.add(pos);
    if (pos == target) {
      this.context = context;
      return;
    }
  }

  void deletePos(Pos pos, BuildContext context) {
    posList.remove(pos);
  }

  RelativePosition checkInside() {
    var list = ChoicePageFindUtil().posList;
    var target = ChoicePageFindUtil().target;
    if (target == null) {
      return RelativePosition.contain;
    }
    if (list.isEmpty) {
      return RelativePosition.moveSomething;
    }
    if (target < list.first) {
      return RelativePosition.up;
    }
    if (target > list.last) {
      return RelativePosition.down;
    }
    return RelativePosition.contain;
  }
}

enum RelativePosition { up, down, contain, moveSomething }

@riverpod
class ChoicePageTarget extends _$ChoicePageTarget {
  @override
  Pos? build() {
    ref.keepAlive();
    return null;
  }

  void set(Pos? pos) {
    VisibilityDetectorController.instance.updateInterval = const Duration(milliseconds: 0);
    ChoicePageFindUtil().target = pos;
    state = pos;
  }
}
