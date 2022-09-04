import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/choiceNode/choice_node.dart';
import '../model/choiceNode/choice_status.dart';
import '../model/choiceNode/generable_parser.dart';
import '../model/choiceNode/pos.dart';
import '../model/platform_system.dart';

const double nodeBaseHeight = 200;
const int designSamplePosition0 = -100;
const int designSamplePosition1 = -101;
const int nonPositioned = -1;
const int removedPositioned = -2;

void refreshChild(Ref ref, GenerableParserAndPosition node) {
  ref.read(choiceNodeProvider(node.pos)).needUpdate();
  ref.invalidate(opacityProvider(node.pos));
  ref.invalidate(isIgnorePointerProvider(node.pos));
  ref.read(childrenChangeProvider(node.pos).notifier).update();
  for (var child in node.children) {
    refreshChild(ref, child);
  }
}

final choiceNodeProvider =
    ChangeNotifierProvider.family.autoDispose<ChoiceNodeNotifier, Pos>((ref, pos) {
      return ChoiceNodeNotifier(ref, pos);
});

class ChoiceNodeNotifier extends ChangeNotifier{
  ChoiceNode? node;
  Ref ref;
  Pos pos;
  ChoiceNodeNotifier(this.ref, this.pos){
    if (pos.last == removedPositioned) {
      node = ref.read(removedChoiceNode);
    }else{
      var node = getPlatform.getNode(pos);
      if (node is ChoiceNode) {
        this.node = node;
      } else {
        this.node = null;
      }
    }
  }

  void needUpdate(){
    notifyListeners();
  }
}

final isChoiceNodeIsOccupySpaceProvider = Provider.family
    .autoDispose<bool, Pos>(
        (ref, pos) => ref.watch(choiceNodeProvider(pos)).node!.isOccupySpace);

final isChoiceNodeCardProvider = Provider.family.autoDispose<bool, Pos>(
    (ref, pos) => ref.watch(choiceNodeProvider(pos)).node!.isCard);

final isChoiceNodeRoundProvider = Provider.family.autoDispose<bool, Pos>(
    (ref, pos) => ref.watch(choiceNodeProvider(pos)).node!.isRound);

final isChoiceNodeHideTitleProvider = Provider.family.autoDispose<bool, Pos>(
    (ref, pos) => ref.watch(choiceNodeProvider(pos)).node!.hideTitle);

final imageStringProvider =
    Provider.family.autoDispose<String, Pos>((ref, pos) {
  var node = ref.watch(choiceNodeProvider(pos)).node!;
  if (ConstList.isDistributed) return node.imageString;
  if (!ImageDB().contains(node.imageString) && node.imageString.isNotEmpty) {
    if (node.imageString != "noImage") {
      node.imageString = "";
    }
  }
  return node.imageString;
});

final titleStringProvider = Provider.family.autoDispose<String, Pos>(
    (ref, pos) => ref.watch(choiceNodeProvider(pos)).node!.title);

final contentsQuillProvider =
    Provider.family.autoDispose<QuillController, Pos>((ref, pos) {
  QuillController controller;
  if (ref.watch(choiceNodeProvider(pos)).node!.contentsString.isEmpty) {
    controller = QuillController.basic();
  } else {
    var json = jsonDecode(ref.watch(choiceNodeProvider(pos)).node!.contentsString);
    var document = Document.fromJson(json);
    controller = QuillController(
        document: document,
        selection: const TextSelection.collapsed(offset: 0));
  }
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

final imagePositionProvider = Provider.family.autoDispose<int, Pos>(
    (ref, pos) => ref.watch(choiceNodeProvider(pos)).node!.imagePosition);

final maximizingImageProvider = Provider.family.autoDispose<bool, Pos>(
    (ref, pos) => ref.watch(choiceNodeProvider(pos)).node!.maximizingImage);

final nodeModeProvider = Provider.family.autoDispose<ChoiceNodeMode, Pos>(
    (ref, pos) => ref.watch(choiceNodeProvider(pos)).node!.choiceNodeMode);

final choiceNodePlayStatusProvider =
    Provider.family.autoDispose<ChoiceStatus, Pos>((ref, pos) {
  return ref.watch(choiceNodeProvider(pos)).node!.choiceStatus;
});

final isIgnorePointerProvider =
    Provider.family.autoDispose<bool, Pos>((ref, pos) {
  if (ref.watch(nodeModeProvider(pos)) == ChoiceNodeMode.onlyCode) {
    return false;
  }
  if (ref.watch(nodeModeProvider(pos)) == ChoiceNodeMode.unSelectableMode) {
    return false;
  }
  var choiceStatus = ref.watch(choiceNodePlayStatusProvider(pos));
  var node = ref.watch(choiceNodeProvider(pos)).node!;
  return choiceStatus.visible &&
      choiceStatus.isPointerInteractive(node.isSelectableMode);
});

final choiceNodeSelectProvider = StateNotifierProvider.family
    .autoDispose<ChoiceNodeSelectNotifier, int, Pos>(
        (ref, pos) => ChoiceNodeSelectNotifier(ref, pos));

class ChoiceNodeSelectNotifier extends StateNotifier<int> {
  Ref ref;
  Pos pos;

  ChoiceNodeSelectNotifier(this.ref, this.pos) : super(0);

  Future<void> select(int n, {Future Function()? showDialogFunction}) async {
    if (!ref.read(isIgnorePointerProvider(pos))) {
      return;
    }

    var node = ref.read(choiceNodeProvider(pos)).node!;
    if (node.isSelected() &&
        ref.read(nodeModeProvider(pos)) != ChoiceNodeMode.multiSelect) {
      node.selectNode(n);
    } else if (ref.read(nodeModeProvider(pos)) == ChoiceNodeMode.randomMode) {
      node.selectNode(n);
      ref.read(randomStateNotifierProvider(pos).notifier).startRandom();
      await showDialogFunction!();
    } else if (ref.read(nodeModeProvider(pos)) == ChoiceNodeMode.multiSelect) {
      state += n;
      state = state.clamp(0, node.maximumStatus);
      node.selectNode(state);
    } else {
      node.selectNode(n);
    }
    updateStatusAll(ref, start: node.pos.first);
  }
}

final randomProcessExecutedProvider = StateProvider<bool>((ref) => false);
final randomStateNotifierProvider =
    StateNotifierProvider.family<RandomProvider, int, Pos>(
        (ref, pos) => RandomProvider(ref, pos));

final opacityProvider = Provider.family.autoDispose<double, Pos>((ref, pos) {
  var node = ref.watch(choiceNodeProvider(pos)).node!;
  if (isEditable) return 1;
  if (!ref.watch(choiceNodePlayStatusProvider(pos)).visible) return 0;

  if (node.isSelectableMode) {
    if (ref.watch(isIgnorePointerProvider(pos))) {
      return 1;
    } else {
      return 0.4;
    }
  } else {
    if (ref.watch(choiceNodePlayStatusProvider(pos)).isSelected()) {
      return 1;
    } else {
      return 0;
    }
  }
});

class RandomProvider extends StateNotifier<int> {
  Ref ref;
  Pos pos;

  RandomProvider(this.ref, this.pos) : super(-1);

  void startRandom() {
    ref.read(randomProcessExecutedProvider.notifier).state = true;
    var node = ref.read(choiceNodeProvider(pos)).node!;
    state = node.maximumStatus * 10;
    var timer =
        Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      state = state ~/ 2;
    });
    Timer(const Duration(milliseconds: 2000), () {
      timer.cancel();
      state = Random().nextInt(node.maximumStatus);
      node.random = state;
      ref.read(randomProcessExecutedProvider.notifier).state = false;
    });
  }
}

final choiceNodeSizeProvider = StateNotifierProvider.family
    .autoDispose<ChoiceNodeSizeNotifier, int, Pos>((ref, pos) {
  return ChoiceNodeSizeNotifier(pos, ref);
});

class ChoiceNodeSizeNotifier extends StateNotifier<int> {
  final Pos pos;
  Ref ref;
  ChoiceNode node;

  ChoiceNodeSizeNotifier(this.pos, this.ref)
      : node = ref.read(choiceNodeProvider(pos)).node!,
        super(ref.read(choiceNodeProvider(pos)).node!.width);

  void sizeChange(int width) {
    if (width == -1) {
      if (state > ref.read(choiceNodeProvider(pos)).node!.getMaxSize(false)) {
        state = node.getMaxSize(false);
      }
    } else {
      state = width.clamp(0, node.getMaxSize(false));
    }
    node.width = state;
    for (var child in node.children) {
      ref.read(choiceNodeSizeProvider(child.pos).notifier).sizeChange(-1);
    }
    refreshLine(ref, pos.first);
  }
}

void updateStatusAll(Ref ref, {int start = 0}) {
  getPlatform.updateStatusAll();
  ref.read(snackBarErrorProvider.notifier).update();
  refreshPage(ref, start: start);
}

void updateImageAll(Ref ref) {
  getPlatform.updateStatusAll();
  for (var lineSetting in getPlatform.lineSettings) {
    for (var node in lineSetting.children) {
      ref.refresh(imageStringProvider(node.pos));
    }
  }
}
