import 'dart:async';
import 'dart:convert';

import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/choiceNode/selectable_status.dart';
import 'package:cyoap_flutter/i18n.dart';
import 'package:cyoap_flutter/model/image_db.dart';
import 'package:cyoap_flutter/viewModel/preset/vm_choice_node_preset.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/platform.dart';
import '../model/platform_system.dart';

const double nodeBaseHeight = 200;
const int removedPositioned = -2;

void refreshChild(Ref ref, Choice node) {
  ref.invalidate(choiceNodeProvider(node.pos));
  ref.invalidate(opacityProvider(node.pos));
  ref.read(childrenChangeProvider(node.pos).notifier).update();
  for (var child in node.children) {
    refreshChild(ref, child);
  }
}

final choiceNodeProvider = ChangeNotifierProvider.family
    .autoDispose<ChoiceNodeNotifier, Pos>((ref, pos) {
  return ChoiceNodeNotifier(ref, pos);
});

class ChoiceNodeNotifier extends ChangeNotifier {
  ChoiceNode? node;
  Ref ref;
  Pos pos;

  ChoiceNodeNotifier(this.ref, this.pos) {
    if (pos.last == removedPositioned) {
      node = ref.read(removedChoiceNode);
    } else if (pos.last == designSamplePosition) {
      node = ChoiceNode(
        1,
        "sample_title".i18n,
        "[{\"insert\":\"${'sample_node'.i18n}\\n\"}]",
        "noImage",
      )..currentPos = -1;

      node!.choiceNodeOption = node!.choiceNodeOption
          .copyWith(presetName: ref.read(choiceNodePresetCurrentEditProvider).name);
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
  var node = ref.watch(choiceNodeProvider(pos));
  return node.node!.choiceNodeOption;
});


final imageStringProvider =
    Provider.family.autoDispose<String, Pos>((ref, pos) {
  var node = ref.watch(choiceNodeProvider(pos)).node!;
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
    var json =
        jsonDecode(ref.watch(choiceNodeProvider(pos)).node!.contentsString);
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

final nodeModeProvider = Provider.family.autoDispose<ChoiceNodeMode, Pos>(
    (ref, pos) => ref.watch(choiceNodeProvider(pos)).node!.choiceNodeMode);

final choiceNodePlayStatusProvider =
    Provider.family.autoDispose<SelectableStatus, Pos>((ref, pos) {
  return ref.watch(choiceNodeProvider(pos)).node!.selectableStatus;
});

final choiceNodeSelectProvider = StateNotifierProvider.family
    .autoDispose<ChoiceNodeSelectNotifier, int, Pos>(
        (ref, pos) => ChoiceNodeSelectNotifier(ref, pos));

class ChoiceNodeSelectNotifier extends StateNotifier<int> {
  Ref ref;
  Pos pos;

  ChoiceNodeSelectNotifier(this.ref, this.pos) : super(0);

  void select(int n, {Future Function()? showDialogFunction}) {
    var node = ref.read(choiceNodeProvider(pos)).node!;
    node.selectNode(n);
    if (node.random != -1) {
      showDialogFunction!();
      ref.read(randomStateNotifierProvider(pos).notifier).startRandom();
    }
    updateStatusAll(ref, startLine: node.pos.first);
    state = node.select;
  }

  int maxSelect(){
    var node = ref.read(choiceNodeProvider(pos)).node!;
    return node.maximumStatus;
  }
}

final randomProcessExecutedProvider = StateProvider<bool>((ref) => false);
final randomStateNotifierProvider =
    StateNotifierProvider.family<RandomProvider, int, Pos>(
        (ref, pos) => RandomProvider(ref, pos));

final opacityProvider = Provider.family.autoDispose<double, Pos>((ref, pos) {
  var node = ref.watch(choiceNodeProvider(pos)).node!;
  if (isEditable) return 1;
  if (node.choiceNodeMode == ChoiceNodeMode.onlyCode) return 0;
  if (node.isExecutable()) return 1;
  var status = ref.watch(choiceNodePlayStatusProvider(pos));
  if (status.isHide()) return 0;
  if (status.isClosed()) return 0.4;
  if (!node.checkParentClickable(first: true)) return 0.4;
  return 1;
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
