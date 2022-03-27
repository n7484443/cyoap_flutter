import 'package:cyoap_flutter/viewModel/vm_choice_node.dart';

import 'choiceNode/choice_node.dart';

class NodeEditor {
  static final NodeEditor instance = NodeEditor();

  late ChoiceNodeBase target;

  void setTarget(ChoiceNodeBase node) {
    target = node;
  }

  VMChoiceNode getVMChoiceNode() {
    return VMChoiceNode.getVMChoiceNodeFromTag(target.tag)!;
  }
}
