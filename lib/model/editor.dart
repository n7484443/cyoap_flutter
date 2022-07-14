import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';

import 'choiceNode/choice_node.dart';
import 'choiceNode/recursive_status.dart';

class NodeEditor {
  static final NodeEditor? _instance =
      ConstList.isDistributed ? null : NodeEditor._init();

  factory NodeEditor() {
    return _instance!;
  }
  NodeEditor._init();

  ChoiceNode? _target;

  ChoiceNode get target => _target!;

  RecursiveStatus get targetRecursive => target.recursiveStatus;

  set target(ChoiceNode node) => _target = node;

  VMChoiceNode? getVMChoiceNode() {
    if (_target == null) return null;
    return VMChoiceNode.getVMChoiceNodeFromTag(_target!.tag);
  }
}
