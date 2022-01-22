import 'package:cyoap_flutter/model/grammer/FunctionList.dart';

import 'ValueType.dart';

class RecursiveParser {
  Recursive_Parser[] child_node = Recursive_Parser[3];
  ValueType value;
  // 노드마다 가지는 최대의 데이터:3
  // if ( a, then, else) 가 최대

  void add(RecursiveParser parser) {
    for (int i = 0; i < child_node.length; i++) {
      if (child_node[i] == null) {
        child_node[i] = parser;
        return;
      }
    }
  }

  int checkParser(int i) {
    if (value != null) print("$i:$value.data:$value.type\n");
    for (int k = 0; k < 3; k++) {
      if (child_node[k] != null) {
        i++;
        i = child_node[k].checkParser(i);
      }
    }
    return i;
  }

  void checkParser() {
    checkParser(0);
  }

  ValueType unzip() {
    if (value.data is Function) {
      if (value.data is Func_one_input) {
        return value.data.func(child_node[0].unzip());
      } else if (value.data is Func_two_input) {
        return value.data.func(child_node[0].unzip(), child_node[1].unzip());
      } else {
        return value.data.func(child_node[0].unzip(), child_node[1].unzip(), child_node[2].unzip());
      }
    } else {
      return value;
    }
  }
}
