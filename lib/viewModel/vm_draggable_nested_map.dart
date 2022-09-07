import 'package:cyoap_flutter/model/choiceNode/choice_line.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/choiceNode/choice_node.dart';
import '../model/choiceNode/generable_parser.dart';
import '../model/choiceNode/pos.dart';
import '../model/platform_system.dart';
import '../model/variable_db.dart';

const int maxWidthSize = 12;

final draggableNestedMapChangedProvider = StateProvider<bool>((ref) => false);

final vmDraggableNestedMapProvider =
    Provider.autoDispose((ref) => VMDraggableNestedMap(ref));

final removedChoiceNode = StateProvider<ChoiceNode?>((ref) => null);
final dragPositionProvider = StateProvider<double?>((ref) => null);

final dragChoiceNodeProvider =
    StateNotifierProvider<DragChoiceNodeNotifier, Pos?>(
        (ref) => DragChoiceNodeNotifier(ref));

class DragChoiceNodeNotifier extends StateNotifier<Pos?> {
  Ref ref;

  DragChoiceNodeNotifier(this.ref) : super(null);

  void dragStart(Pos pos) {
    state = pos.copyWith();
  }

  void dragEnd() {
    state = null;
  }
}

class VMDraggableNestedMap {
  Ref ref;

  VMDraggableNestedMap(this.ref);

  void copyData(ChoiceNode choiceNode) {
    ref.read(removedChoiceNode.notifier).state = choiceNode.clone();
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    refreshPage(ref);
  }

  void removeData(Pos pos) {
    var choiceNode = getPlatform.removeData(pos);
    copyData(choiceNode);
    VariableDataBase().updateCheckList();
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    refreshPage(ref);
  }

  void addData(Pos pos, ChoiceNode choiceNode) {
    getPlatform.addData(pos, choiceNode);
    VariableDataBase().updateCheckList();
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    refreshPage(ref);
  }

  static ChoiceNode createNodeForTemp() {
    return ChoiceNode.noTitle(3, true, '', '');
  }

  void changeData(Pos input, Pos target) {
    if (input.last == nonPositioned) {
      getPlatform.addData(target, createNodeForTemp());
    } else {
      var inputNode = getPlatform.getChoiceNode(input)!;
      var targetNode = getPlatform.getChoiceNode(target);
      if (targetNode == null) {
        var generableParser =
            getPlatform.getGenerableParserAndPosition(target.removeLast());
        if (generableParser == null) {
          getPlatform.removeData(input);
          getPlatform.addData(target, inputNode);
        } else {
          getPlatform.insertDataWithParent(inputNode, generableParser);
        }
      } else {
        getPlatform.insertData(inputNode, targetNode);
      }
    }
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    refreshPage(ref);
  }

  void moveLine(int before, int after) {
    if (after >= getPlatform.lineSettings.length) {
      return;
    }
    if (after < 0) {
      return;
    }
    var temp = getPlatform.lineSettings[before];
    getPlatform.lineSettings[before] = getPlatform.lineSettings[after];
    getPlatform.lineSettings[after] = temp;
    getPlatform.checkDataCorrect();
    refreshPage(ref);
  }
}

void refreshPage(Ref ref, {int startLine = 0}) {
  for (var pos = startLine; pos < getPlatform.lineSettings.length; pos++) {
    refreshLine(ref, pos);
  }
}

void refreshLine(Ref ref, int y) {
  var pos = Pos(data: [y]);
  ref.invalidate(lineProvider(y));
  ref.invalidate(lineLengthProvider);
  ref.invalidate(lineVisibleProvider(pos));
  ref.read(childrenChangeProvider(pos).notifier).update();
  for (var child in ref.read(lineProvider(y))!.children) {
    refreshChild(ref, child);
  }
}

final lineProvider = Provider.autoDispose
    .family<LineSetting?, int>((ref, pos) => getPlatform.getLineSetting(pos));

final lineVisibleProvider = Provider.autoDispose
    .family<bool, Pos>((ref, pos) => !ref.watch(lineProvider(pos.first))!.choiceStatus.isHide());

final _childrenProvider = Provider.autoDispose
    .family<List<GenerableParserAndPosition>, Pos>((ref, pos) {
  if (pos.length == 1) {
    return ref.watch(lineProvider(pos.first))!.children;
  } else {
    return ref.watch(choiceNodeProvider(pos)).node!.children;
  }
});

final childrenChangeProvider = StateNotifierProvider.autoDispose
    .family<ChildrenNotifier, List<GenerableParserAndPosition>, Pos>(
        (ref, pos) => ChildrenNotifier(ref, pos));

class ChildrenNotifier extends StateNotifier<List<GenerableParserAndPosition>> {
  Ref ref;
  Pos pos;

  ChildrenNotifier(this.ref, this.pos)
      : super([...ref.read(_childrenProvider(pos))]);

  void update() {
    state = [...ref.read(_childrenProvider(pos))];
  }
}

final lineAlwaysVisibleProvider = StateProvider.autoDispose.family<bool, int>(
    (ref, pos) => ref.watch(lineProvider(pos))!.alwaysVisible);

final lineMaxSelectProvider = StateProvider.autoDispose
    .family<int, int>((ref, pos) => ref.watch(lineProvider(pos))!.maxSelect);

final lineBackgroundColorProvider = StateProvider.autoDispose
    .family<Color?, int>(
        (ref, pos) => ref.watch(lineProvider(pos))!.backgroundColor);

final lineLengthProvider =
    Provider.autoDispose<int>((ref) => getPlatform.lineSettings.length);
