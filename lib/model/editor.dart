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

  late ChoiceNodeBase target;

  void setTarget(ChoiceNodeBase node) {
    target = node;
  }

  VMChoiceNode getVMChoiceNode() {
    return VMChoiceNode.getVMChoiceNodeFromTag(target.tag)!;
  }
}
