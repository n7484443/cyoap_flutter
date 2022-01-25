import 'choiceNode/choice_node.dart';

class NodeEditor{
  static final NodeEditor instance = NodeEditor();

  late ChoiceNodeBase target;

  void setTarget(ChoiceNodeBase node){
    target = node;
  }
}