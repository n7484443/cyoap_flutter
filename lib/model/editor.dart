import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';

import 'choiceNode/choice_node.dart';

class NodeEditor {
  static final NodeEditor? _instance =
      ConstList.isDistributed ? null : NodeEditor._init();

  factory NodeEditor() {
    return _instance!;
  }
  NodeEditor._init();

  ChoiceNodeBase? _target;

  ChoiceNodeBase get target => _target!;

  set target(ChoiceNodeBase node) => _target = node;

  VMChoiceNode? getVMChoiceNode() {
    if(_target == null)return null;
    return VMChoiceNode.getVMChoiceNodeFromTag(_target!.tag);
  }
}
