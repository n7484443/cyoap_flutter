import 'package:cyoap_core/choiceNode/choice.dart';
import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/choiceNode/choice_page.dart';
import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_core/i18n.dart';
import 'package:cyoap_core/playable_platform.dart';
import 'package:cyoap_flutter/viewModel/preset/vm_choice_node_preset.dart';
import 'package:cyoap_flutter/viewModel/choice/vm_choice_node.dart';
import 'package:cyoap_flutter/viewModel/vm_draggable_nested_map.dart';
import 'package:cyoap_flutter/viewModel/vm_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../model/platform.dart';
import '../../model/platform_system.dart';

part 'vm_choice.g.dart';

const double nodeBaseHeight = 200;
const int removedPositioned = -2;
const int copiedPositioned = -3;
final choiceStatusProvider =
    ChangeNotifierProvider.family.autoDispose<ChoiceStatus, Pos>((ref, pos) {
  return ChoiceStatus(ref, pos);
});

class ChoiceStatus extends ChangeNotifier {
  late Choice node;
  Ref ref;
  Pos pos;

  ChoiceStatus(this.ref, this.pos) {
    build();
  }

  void build() {
    if (pos.last == copiedPositioned) {
      node = ref.read(copiedChoiceNodeStatusProvider).choiceNode!;
    } else if (pos.last == removedPositioned) {
      node = ref.read(removedChoiceNodeStatusProvider).choiceNode!;
    } else if (pos.last == designSamplePosition) {
      var choiceNode = ChoiceNode(
        width: 1,
        title: "sample_title".i18n,
        contents: "[{\"insert\":\"${'sample_node'.i18n}\\n\"}]",
        imageString: "noImage",
      )..currentPos = -1;

      choiceNode.choiceNodeOption = choiceNode.choiceNodeOption.copyWith(
          presetName: ref.read(choiceNodePresetCurrentEditProvider).name);
      choiceNode.select = ref.read(choiceNodePresetTestSelectProvider) ? 1 : 0;
      node = choiceNode;
    } else {
      node = getPlatform.getChoice(pos)!;
    }
  }

  void refreshParent() {
    ref.read(choiceStatusProvider(pos.removeLast())).refreshSelf();
  }

  void refreshSelf() {
    build();
    notifyListeners();

    for (var i = 0; i < node.children.length; i++) {
      ref.read(choiceStatusProvider(pos.addLast(i))).refreshSelf();
    }
  }

  void refreshAll() {
    if (pos.length == 1) {
      refreshSelf();
    } else {
      ref.read(choiceStatusProvider(Pos(data: [pos.first]))).refreshSelf();
    }
  }

  void swapChoice(Pos target) {
    var lca = Pos.lca(pos, target);
    if (pos.last == nonPositioned) {
      getPlatform.addData(target, getPlatform.createTempNode());
    } else {
      var targetNode = getPlatform.getChoiceNode(target);
      if (targetNode == null) {
        var choice = getPlatform.getChoice(target.removeLast());
        if (choice == null) {
          getPlatform.removeData(pos);
          getPlatform.addData(target, node);
        } else {
          getPlatform.insertDataWithParent(node, choice);
        }
      } else {
        getPlatform.insertData(node, targetNode);
      }
    }
    if(lca == pos){
      refreshSelf();
    }else{
      ref.read(choiceStatusProvider(lca)).refreshSelf();
    }
  }

  void removeData() {
    var parent = ref.read(choiceStatusProvider(pos.removeLast())).node;
    parent.removeChildren(node);
    refreshParent();
  }

  void addChoice(Choice choice, {int? index}) {
    node.addChildren(choice, pos: index);
    refreshSelf();
  }

  void copyData() {
    ref
        .read(copiedChoiceNodeStatusProvider.notifier)
        .update(node.clone() as ChoiceNode);
  }

  List<Choice> getChildrenList() {
    return node.children;
  }

  ChoiceNode? asChoiceNode() {
    return node as ChoiceNode?;
  }

  ChoiceLine? asChoiceLine() {
    return node as ChoiceLine?;
  }

  ChoicePage? asChoicePage() {
    return node as ChoicePage?;
  }

  void select(int n) {
    var node = asChoiceNode()!;
    node.selectNode(n);
    if (node.random != -1) {
      ref.read(randomStateNotifierProvider(pos).notifier).startRandom();
    }
    getPlatform.updateStatus();
    ref.read(snackBarErrorProvider.notifier).update();
    refreshAll();
  }

  int maxSelect() {
    return asChoiceNode()!.maximumStatus;
  }
}

@riverpod
class CurrentChoicePage extends _$CurrentChoicePage {
  @override
  Pos build() {
    return const Pos(data: [0]);
  }

  void refresh() {
    ref.read(choiceStatusProvider(state)).refreshAll();
  }
}
