import 'dart:collection';

import 'package:cyoap_core/choiceNode/choice_node.dart';

class HistoryDB {
  static final HistoryDB _instance = HistoryDB._init();

  factory HistoryDB() {
    return _instance;
  }

  HistoryDB._init();
  final Queue<ChoiceNode> _historyList = Queue();
  final int historySize = 10;

  ChoiceNode? get first => _historyList.first.clone();

  void push(ChoiceNode node) {
    _historyList.addFirst(node.clone());
    if(_historyList.length > historySize) {
      _historyList.removeLast();
    }
  }

  ChoiceNode get(int index){
    return _historyList.elementAt(index).clone();
  }

  Queue<ChoiceNode> get historyList => _historyList;
}
