import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/clipboard.dart';

part 'vm_draggable_nested_map.g.dart';

final choiceNodeClipboardStatusProvider =
    ChangeNotifierProvider.autoDispose<ChoiceNodeClipboardNotifier>(
        (ref) => ChoiceNodeClipboardNotifier(ref));

class ChoiceNodeClipboardNotifier extends ChangeNotifier {
  List<ChoiceNode> choiceNodeQueue = [];
  Ref ref;

  ChoiceNodeClipboardNotifier(this.ref) {
    choiceNodeQueue = getPlatform.clipboard.queue.toList();
  }

  void add(ChoiceNode original) {
    var choiceNode = original.clone();
    getPlatform.clipboard.addData(choiceNode);
    choiceNodeQueue = getPlatform.clipboard.queue.toList();
    for (int i = 0; i < length; i++) {
      ref
          .read(choiceStatusProvider(Pos(data: [-i - constClipboard])).notifier)
          .refreshSelf();
    }
    notifyListeners();
  }

  ChoiceNode getIndex(int index) {
    return choiceNodeQueue[index];
  }

  ChoiceNode getIndexPos(Pos pos) {
    var node = getIndex(-pos.first - constClipboard);
    if (pos.length == 1) {
      return node;
    }
    var pointer = pos.removeFirst();
    while (pointer.length > 0) {
      node = node.children[pointer.first] as ChoiceNode;
      pointer = pointer.removeFirst();
    }
    return node;
  }

  int get length {
    return choiceNodeQueue.length;
  }

  List<Pos> get posList {
    return List.generate(
        length, (index) => Pos(data: [-index - constClipboard]));
  }
}

@riverpod
class CurrentProjectChanged extends _$CurrentProjectChanged {
  @override
  bool build() {
    ref.keepAlive();
    return false;
  }

  void changed({required bool needUpdateCode}) {
    state = true;
    if(needUpdateCode){
      getPlatform.generateRecursiveParser();
      getPlatform.updateStatus();
    }
  }

  void save() {
    state = false;
  }
}

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
