import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final draggableNestedMapChangedProvider = StateProvider<bool>((ref) => false);

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
    ref
        .read(choiceStatusProvider(
            const Pos(data: [removedPositioned, removedPositioned])))
        .refreshSelf();
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
    ref
        .read(choiceStatusProvider(
            const Pos(data: [copiedPositioned, copiedPositioned])))
        .refreshSelf();
  }
}

final dragPositionProvider = StateProvider<double?>((ref) => null);

final dragChoiceNodeStatusProvider =
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
