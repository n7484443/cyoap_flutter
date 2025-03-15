import 'dart:collection';

import 'package:cyoap_core/choiceNode/choice_node.dart';

const int constClipboard = 1;

class Clipboard {
  Queue<ChoiceNode> queue = Queue();
  int length = 10;

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

  void update() {
    for (var i = 0; i < queue.length; i++) {
      var choice = queue.elementAt(i);
      choice.currentPos = -i - constClipboard;
      choice.checkDataCorrect();
    }
  }

  Clipboard(this.length);

  Map<String, dynamic> toJson() {
    return {
      'queue': queue.map((e) => e.toJson()).toList(),
      'length': length,
    };
  }

  Clipboard.fromJson(Map<String, dynamic> json) {
    queue = Queue.from(((json['queue'] as List?) ?? []).map((e) => ChoiceNode.fromJson(e)).toList());
    length = json['length'] ?? length;
  }
}
