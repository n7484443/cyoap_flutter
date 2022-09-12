import 'dart:collection';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/grammar/value_type.dart';
import 'package:cyoap_core/variable_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/platform_system.dart';

final vmVariableTableProvider = StateNotifierProvider<
    VariableTilesStateNotifier, Map<String, ValueTypeWrapper>>((ref) {
  return VariableTilesStateNotifier(VariableDataBase().varMapGlobal);
});

final isDebugModeProvider = StateProvider<bool>((ref) {
  return false;
});

final isVisibleHideVariableProvider = StateProvider<bool>((ref) {
  return false;
});

final searchProvider = StateProvider<String>((ref) {
  return "";
});

final isVisibleSourceProvider = StateProvider<bool>((ref) {
  return false;
});

class VariableTilesStateNotifier
    extends StateNotifier<Map<String, ValueTypeWrapper>> {
  VariableTilesStateNotifier(super.state) {
    VariableDataBase().variableChangeCallback = (){
      update();
    };
  }

  void update() {
    state = HashMap.from(VariableDataBase().varMapGlobal);
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
    VariableDataBase().checkListChangeCallback = (){
      update();
    };
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
