import 'dart:collection';

import 'package:cyoap_core/choiceNode/choice_node.dart';

const int constClipboard = 1;
class Clipboard {
  Queue<ChoiceNode> queue = Queue();
  int length = 3;

  void addData(ChoiceNode choiceNode) {
    choiceNode.parent = null;
    queue.addFirst(choiceNode);
    if (queue.length > length) {
      queue.removeLast();
    }
    update();
  }

  ChoiceNode getData(int index) {
    var node = queue.elementAt(index);
    queue.remove(node);
    queue.addFirst(node);
    update();
    return node.clone();
  }

  void update(){
    for(var i = 0; i < queue.length; i++){
      var choice = queue.elementAt(i);
      choice.currentPos = -i - constClipboard;
      choice.checkDataCorrect();
    }
  }
}
