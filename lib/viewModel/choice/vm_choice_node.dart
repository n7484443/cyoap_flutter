import 'dart:async';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/platform_system.dart';

part 'vm_choice_node.g.dart';

@riverpod
ChoiceNodeOption choiceNodeDesignSetting(Ref ref, {required Pos pos}) {
  var node = ref.watch(choiceStatusProvider(pos)).asChoiceNode();
  return node!.choiceNodeOption;
}

@riverpod
String imageString(Ref ref, {required Pos pos}) {
  var node = ref.watch(choiceStatusProvider(pos)).asChoiceNode()!;
  if (!ImageDB().contains(node.imageString) && node.imageString.isNotEmpty) {
    if (node.imageString != "noImage") {
      node.imageString = "";
    }
  }
  return node.imageString;
}

final titleStringProvider = Provider.family.autoDispose<String, Pos>((ref, pos) => ref.watch(choiceStatusProvider(pos)).asChoiceNode()!.title);

@riverpod
String? contentsQuill(Ref ref, {required Pos pos}) {
  var node = ref.watch(choiceStatusProvider(pos)).asChoiceNode()!;
  if (node.contentsString.isEmpty) {
    return null;
  }
  return node.contentsString;
}

final nodeModeProvider = Provider.family.autoDispose<ChoiceNodeMode, Pos>((ref, pos) => ref.watch(choiceStatusProvider(pos)).asChoiceNode()!.choiceNodeMode);

final randomProcessExecutedProvider = StateProvider<bool>((ref) => false);
final randomStateNotifierProvider = StateNotifierProvider.family<RandomProvider, int, Pos>((ref, pos) => RandomProvider(ref, pos));

final opacityProvider = Provider.family.autoDispose<double, Pos>((ref, pos) {
  var node = ref.watch(choiceStatusProvider(pos)).asChoiceNode();
  if (node == null) return 0;
  if (ref.watch(isEditableProvider(pos: pos))) return 1;
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
    var node = ref.read(choiceStatusProvider(pos)).asChoiceNode()!;
    state = node.maximumStatus * 10;
    var timer = Timer.periodic(const Duration(milliseconds: 500), (Timer timer) {
      state = state ~/ 2;
    });
    Timer(const Duration(milliseconds: 2000), () {
      timer.cancel();
      state = node.random;
      ref.read(randomProcessExecutedProvider.notifier).state = false;
    });
  }
}

final choiceNodeSizeProvider = StateNotifierProvider.family.autoDispose<ChoiceNodeSizeNotifier, int, Pos>((ref, pos) {
  return ChoiceNodeSizeNotifier(pos, ref);
});

class ChoiceNodeSizeNotifier extends StateNotifier<int> {
  final Pos pos;
  Ref ref;
  ChoiceNode node;

  ChoiceNodeSizeNotifier(this.pos, this.ref)
      : node = ref.read(choiceStatusProvider(pos)).asChoiceNode() ?? ChoiceNode.empty(),
        super(ref.read(choiceStatusProvider(pos)).asChoiceNode()?.getWidth(getPlatform) ?? 12);

  void sizeChange(int width) {
    if (width == -1) {
      if (state > ref.read(choiceStatusProvider(pos)).asChoiceNode()!.getMaxSize(getPlatform, false)) {
        state = node.getMaxSize(getPlatform, false);
      }
    } else {
      state = width.clamp(0, node.getMaxSize(getPlatform, false));
    }
    node.width = state;
    for (var child in node.children) {
      ref.read(choiceNodeSizeProvider(child.pos).notifier).sizeChange(-1);
    }
    ref.read(choiceStatusProvider(pos).notifier).refreshParent();
  }
}

void updateImageAll(Ref ref) {
  getPlatform.updateStatus();
  for (var lineSetting in getPlatform.choicePage.choiceLines) {
    for (var node in lineSetting.children) {
      ref.invalidate(imageStringProvider(pos: node.pos));
    }
  }
}
