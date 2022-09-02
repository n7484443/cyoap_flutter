import 'package:cyoap_flutter/main.dart';

import 'choiceNode/choice_node.dart';
import 'choiceNode/recursive_status.dart';

class NodeEditor {
  static final NodeEditor? _instance =
      ConstList.isDistributed ? null : NodeEditor._init();

  factory NodeEditor() {
    return _instance!;
  }
  NodeEditor._init();

  ChoiceNode? target;

  RecursiveStatus get targetRecursive => target!.recursiveStatus;
}
