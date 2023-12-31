import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_core/preset/line_preset.dart';
import 'package:cyoap_core/variable_db.dart';
import 'package:cyoap_flutter/viewModel/preset/vm_choice_line_preset.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/platform_system.dart';

part 'vm_draggable_nested_map.g.dart';

final draggableNestedMapChangedProvider = StateProvider<bool>((ref) => false);

final vmDraggableNestedMapProvider =
    Provider.autoDispose((ref) => VMDraggableNestedMap(ref));

final removedChoiceNodeStatusProvider =
    ChangeNotifierProvider<RemovedChoiceNodeNotifier>(
        (ref) => RemovedChoiceNodeNotifier(ref, null));

class RemovedChoiceNodeNotifier extends ChangeNotifier {
  ChoiceNode? choiceNode;
  Ref ref;

  RemovedChoiceNodeNotifier(this.ref, this.choiceNode);

  void update(ChoiceNode choiceNode) {
    this.choiceNode = choiceNode;
    notifyListeners();
    ref.invalidate(choiceNodeStatusProvider(
        const Pos(data: [removedPositioned, removedPositioned])));
  }
}

final copiedChoiceNodeStatusProvider =
    ChangeNotifierProvider<CopiedChoiceNodeNotifier>(
        (ref) => CopiedChoiceNodeNotifier(ref, null));

class CopiedChoiceNodeNotifier extends ChangeNotifier {
  ChoiceNode? choiceNode;
  Ref ref;

  CopiedChoiceNodeNotifier(this.ref, this.choiceNode);

  void update(ChoiceNode choiceNode) {
    this.choiceNode = choiceNode;
    notifyListeners();
    ref.invalidate(choiceNodeStatusProvider(
        const Pos(data: [copiedPositioned, copiedPositioned])));
  }
}

final dragPositionProvider = StateProvider<double?>((ref) => null);

final dragchoiceNodeStatusProvider =
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

  void refresh() {
    refreshPage(ref);
  }

  void copyData(ChoiceNode choiceNode) {
    ref
        .read(copiedChoiceNodeStatusProvider.notifier)
        .update(choiceNode.clone());
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    refreshPage(ref);
  }

  void removeData(Pos pos) {
    var choiceNode = getPlatform.removeData(pos);
    ref
        .read(removedChoiceNodeStatusProvider.notifier)
        .update(choiceNode.clone());
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

  void changeData(Pos input, Pos target) {
    if (input.last == nonPositioned) {
      getPlatform.addData(target, getPlatform.createTempNode());
    } else {
      var inputNode = getPlatform.getChoiceNode(input)!;
      var targetNode = getPlatform.getChoiceNode(target);
      if (targetNode == null) {
        var choice = getPlatform.getChoice(target.removeLast());
        if (choice == null) {
          getPlatform.removeData(input);
          getPlatform.addData(target, inputNode);
        } else {
          getPlatform.insertDataWithParent(inputNode, choice);
        }
      } else {
        getPlatform.insertData(inputNode, targetNode);
      }
    }
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
    refreshPage(ref);
  }

  void moveLine(int before, int after) {
    if (after >= getPlatform.choicePage.choiceLines.length) {
      return;
    }
    if (after < 0) {
      return;
    }
    var temp = getPlatform.choicePage.choiceLines[before];
    getPlatform.choicePage.choiceLines[before] = getPlatform.choicePage.choiceLines[after];
    getPlatform.choicePage.choiceLines[after] = temp;
    getPlatform.checkDataCorrect();
    refreshPage(ref);
  }
}

void refreshPage(Ref ref, {int startLine = 0}) {
  ref.invalidate(lineLengthProvider);
  for (var pos = startLine; pos < getPlatform.choicePage.choiceLines.length; pos++) {
    refreshLine(ref, pos);
  }
}

void refreshLine(Ref ref, int y) {
  var pos = Pos(data: [y]);
  ref.invalidate(lineProvider(y));
  ref.invalidate(lineListProvider);
  ref.invalidate(lineVisibleProvider(pos));
  for (var child in ref.read(lineProvider(y))!.children) {
    refreshChild(ref, child);
  }
}

final refreshPageProvider = Provider.autoDispose<void>((ref) {
  refreshPage(ref);
});

final lineProvider = Provider.autoDispose
    .family<ChoiceLine?, int>((ref, pos) => getPlatform.getLineSetting(pos));

final lineVisibleProvider = Provider.autoDispose.family<bool?, Pos>(
    (ref, pos) => ref.watch(lineProvider(pos.first))?.isOpen());

@riverpod
List<Choice> getChildren(GetChildrenRef ref, {required Pos pos}) {
  if (pos.length == 1) {
    return ref.watch(lineProvider(pos.first))?.children ?? [];
  } else {
    return ref.watch(choiceNodeStatusProvider(pos)).node?.children ?? [];
  }
}

final lineOptionProvider =
    StateProvider.autoDispose.family<ChoiceLineOption, int>((ref, pos) {
  ref.listenSelf((previous, ChoiceLineOption next) {
    getPlatform.getLineSetting(pos)?.choiceLineOption = next;
    ref.read(draggableNestedMapChangedProvider.notifier).state = true;
  });
  return ref.watch(lineProvider(pos))?.choiceLineOption ??
      const ChoiceLineOption();
});

final linePresetProvider =
    Provider.family.autoDispose<ChoiceLineDesignPreset, int>((ref, pos) {
  var list = ref.watch(choiceLinePresetListProvider);
  var presetName = ref.watch(lineOptionProvider(pos)).presetName;
  return list.firstWhere((element) => element.name == presetName,
      orElse: () => const ChoiceLineDesignPreset(name: 'default'));
});

final lineLengthProvider =
    Provider.autoDispose<int>((ref) => getPlatform.choicePage.choiceLines.length);

final lineListProvider = Provider.autoDispose<List<int>>((ref) {
  if (isEditable) {
    return getPlatform.choicePage.choiceLines.map((e) => e.currentPos).toList();
  }
  return getPlatform.choicePage.choiceLines
      .where((e) => e.isOpen())
      .map((e) => e.currentPos)
      .toList();
});

final lineFoldProvider =
    StateProvider.autoDispose.family<bool, int>((ref, i) => false);
