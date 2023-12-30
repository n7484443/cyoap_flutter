import 'dart:async';
import 'dart:convert';

import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/preset/vm_choice_node_preset.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../model/platform.dart';
import '../model/platform_system.dart';

const double nodeBaseHeight = 200;
const int removedPositioned = -2;
const int copiedPositioned = -3;

void refreshChild(Ref ref, Choice node) {
  ref.invalidate(choiceNodeStatusProvider(node.pos));
  ref.invalidate(opacityProvider(node.pos));
  for (var child in node.children) {
    refreshChild(ref, child);
  }
}

final choiceNodeStatusProvider = ChangeNotifierProvider.family
    .autoDispose<ChoiceNodeNotifier, Pos>((ref, pos) {
  return ChoiceNodeNotifier(ref, pos);
});

class ChoiceNodeNotifier extends ChangeNotifier {
  ChoiceNode? node;
  Ref ref;
  Pos pos;

  ChoiceNodeNotifier(this.ref, this.pos) {
    if (pos.last == copiedPositioned) {
      node = ref.read(copiedChoiceNodeStatusProvider).choiceNode;
    } else if (pos.last == removedPositioned) {
      node = ref.read(removedChoiceNodeStatusProvider).choiceNode;
    } else if (pos.last == designSamplePosition) {
      node = ChoiceNode(
        width: 1,
        title: "sample_title".i18n,
        contents: "[{\"insert\":\"${'sample_node'.i18n}\\n\"}]",
        imageString: "noImage",
      )..currentPos = -1;

      node!.choiceNodeOption = node!.choiceNodeOption.copyWith(
          presetName: ref.read(choiceNodePresetCurrentEditProvider).name);
      node!.select = ref.read(choiceNodePresetTestSelectProvider) ? 1 : 0;
    } else {
      var node = getPlatform.getNode(pos);
      if (node is ChoiceNode) {
        this.node = node;
      } else {
        this.node = null;
      }
    }
  }
}

final choiceNodeDesignSettingProvider =
    Provider.family.autoDispose<ChoiceNodeOption, Pos>((ref, pos) {
  var node = ref.watch(choiceNodeStatusProvider(pos)).node;
  return node!.choiceNodeOption;
});

final imageStringProvider =
    Provider.family.autoDispose<String, Pos>((ref, pos) {
  var node = ref.watch(choiceNodeStatusProvider(pos)).node!;
  if (!ImageDB().contains(node.imageString) && node.imageString.isNotEmpty) {
    if (node.imageString != "noImage") {
      node.imageString = "";
    }
  }
  return node.imageString;
});

final titleStringProvider = Provider.family.autoDispose<String, Pos>(
    (ref, pos) => ref.watch(choiceNodeStatusProvider(pos)).node!.title);

final contentsQuillProvider =
    Provider.family.autoDispose<Delta?, Pos>((ref, pos) {
  var node = ref.watch(choiceNodeStatusProvider(pos)).node!;
  if (node.contentsString.isEmpty) {
    return null;
  }
  var json = jsonDecode(node.contentsString);
  return Delta.fromJson(json);
});

final nodeModeProvider = Provider.family.autoDispose<ChoiceNodeMode, Pos>(
    (ref, pos) => ref.watch(choiceNodeStatusProvider(pos)).node!.choiceNodeMode);

final choiceNodeSelectProvider = StateNotifierProvider.family
    .autoDispose<ChoiceNodeSelectNotifier, int, Pos>(
        (ref, pos) => ChoiceNodeSelectNotifier(ref, pos));

class ChoiceNodeSelectNotifier extends StateNotifier<int> {
  Ref ref;
  Pos pos;

  ChoiceNodeSelectNotifier(this.ref, this.pos) : super(0);

  void select(int n) {
    var node = ref.read(choiceNodeStatusProvider(pos)).node!;
    node.selectNode(n);
    if (node.random != -1) {
      ref.read(randomStateNotifierProvider(pos).notifier).startRandom();
    }
    updateStatusAll(ref, startLine: node.pos.first);
    state = node.select;
  }

  int maxSelect() {
    var node = ref.read(choiceNodeStatusProvider(pos)).node!;
    return node.maximumStatus;
  }
}

final randomProcessExecutedProvider = StateProvider<bool>((ref) => false);
final randomStateNotifierProvider =
    StateNotifierProvider.family<RandomProvider, int, Pos>(
        (ref, pos) => RandomProvider(ref, pos));

final opacityProvider = Provider.family.autoDispose<double, Pos>((ref, pos) {
  var node = ref.watch(choiceNodeStatusProvider(pos)).node;
  if (node == null) return 0;
  if (isEditable) return 1;
  if (node.choiceNodeMode == ChoiceNodeMode.onlyCode) return 0;
  if (node.isHide()) return 0;
  if (node.isOpen()) return 1;
  return 0.4;
});

class RandomProvider extends StateNotifier<int> {
  Ref ref;
  Pos pos;

  RandomProvider(this.ref, this.pos) : super(-1);

  void startRandom() {
    ref.read(randomProcessExecutedProvider.notifier).state = true;
    var node = ref.read(choiceNodeStatusProvider(pos)).node!;
    state = node.maximumStatus * 10;
    var timer =
        Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      state = state ~/ 2;
    });
    Timer(const Duration(milliseconds: 2000), () {
      timer.cancel();
      state = node.random;
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
      : node = ref.read(choiceNodeStatusProvider(pos)).node ?? ChoiceNode.empty(),
        super(ref.read(choiceNodeStatusProvider(pos)).node?.width ?? 12);

  void sizeChange(int width) {
    if (width == -1) {
      if (state > ref.read(choiceNodeStatusProvider(pos)).node!.getMaxSize(false)) {
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

void updateStatusAll(Ref ref, {int startLine = 0}) {
  getPlatform.updateStatusAll();
  ref.read(snackBarErrorProvider.notifier).update();
  refreshPage(ref, startLine: startLine);
}

void updateImageAll(Ref ref) {
  getPlatform.updateStatusAll();
  for (var lineSetting in getPlatform.lineSettings) {
    for (var node in lineSetting.children) {
      ref.invalidate(imageStringProvider(node.pos));
    }
  }
}
