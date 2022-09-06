import 'dart:collection';

import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/choiceNode/choice_node.dart';
import '../model/choiceNode/pos.dart';
import '../model/platform_system.dart';

final vmVariableTableProvider = StateNotifierProvider<
    VariableTilesStateNotifier, Map<String, ValueTypeWrapper>>((ref) {
  return VariableTilesStateNotifier(VariableDataBase().varMap);
});

final isDebugModeProvider = StateProvider<bool>((ref) {
  return false;
});

final isVisibleHideVariableProvider = StateProvider<bool>((ref) {
  return false;
});

final isVisibleSourceProvider = StateProvider<bool>((ref) {
  return false;
});

class VariableTilesStateNotifier
    extends StateNotifier<Map<String, ValueTypeWrapper>> {
  VariableTilesStateNotifier(super.state) {
    VariableDataBase().variableTilesStateNotifier = this;
  }

  void update() {
    state = HashMap.from(VariableDataBase().varMap);
  }
}

@immutable
class CheckList {
  final String name;
  final bool? check;
  final Pos pos;
  final List<CheckList>? children;

  const CheckList({
    this.check,
    this.children,
    required this.pos,
    required this.name,
  });
}

final checkListNotifierProvider =
    StateNotifierProvider<CheckListNotifier, List<CheckList>>((ref) {
  return CheckListNotifier();
});

class CheckListNotifier extends StateNotifier<List<CheckList>> {
  CheckListNotifier() : super([]) {
    VariableDataBase().checkListNotifier = this;
    update();
  }

  void update() {
    state = showList;
  }

  List<CheckList> get showList {
    var nodeList = List<CheckList>.empty(growable: true);
    for (var line in getPlatform.lineSettings) {
      List<CheckList> subWidgetList = List.empty(growable: true);
      for (var child in line.children) {
        (child as ChoiceNode).doAllChild((node) {
          if (isEditable) {
            subWidgetList.add(CheckList(name: node.title, pos: node.pos));
          } else {
            if (node.analyseVisibleCode()) {
              subWidgetList.add(CheckList(
                  name: node.title,
                  pos: child.pos,
                  check: node.choiceStatus.isSelected()));
            }
          }
        });
      }
      nodeList.add(CheckList(
          name: "lineSetting_${line.currentPos}",
          pos: line.pos,
          children: subWidgetList));
    }
    return nodeList;
  }
}
