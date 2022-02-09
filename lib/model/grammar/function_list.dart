import 'dart:math';

import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/model/variable_db.dart';


class Functions {
  Map<String, Function> functionMap = {};

  void init(){
    functionMap.putIfAbsent('if', () => funcIf);
    functionMap.putIfAbsent('floor', () => funcFloor);
    functionMap.putIfAbsent('round', () => funcRound);
    functionMap.putIfAbsent('ceil', () => funcCeil);
    functionMap.putIfAbsent('+', () => funcPlus);
    functionMap.putIfAbsent('-', () => funcMinus);
    functionMap.putIfAbsent('*', () => funcMulti);
    functionMap.putIfAbsent('/', () => funcDiv);
    functionMap.putIfAbsent('=', () => funcSet);
    functionMap.putIfAbsent('==', () => funcEqual);
    functionMap.putIfAbsent('!=', () => funcNotEqual);
    functionMap.putIfAbsent('>', () => funcBigger);
    functionMap.putIfAbsent('<', () => funcSmaller);
    functionMap.putIfAbsent('>=', () => funcBiggerEqual);
    functionMap.putIfAbsent('<=', () => funcSmallerEqual);
    functionMap.putIfAbsent('and', () => funcAnd);
    functionMap.putIfAbsent('or', () => funcOr);
    functionMap.putIfAbsent('not', () => funcNot);
    functionMap.putIfAbsent('random', () => funcRandom);
    functionMap.putIfAbsent('none', () => funcNone);
  }

  Function getFunction(String name) {
    if (functionMap[name] == null) {
      for (var f in functionMap.values) {
        if (f.toString().contains(name)) {
          return f;
        }
      }
      return funcNone;
    }
    return functionMap[name]!;
  }

  String getFunctionName(Function function) {
    for (var key in functionMap.keys) {
      if (functionMap[key] == function) {
        return key;
      }
    }
    return 'none';
  }

  ValueType funcNone(ValueType a, ValueType b, ValueType c) {
    return a;
  }

  ValueType funcIf(ValueType a, ValueType b, ValueType c) {
    if (a.data is bool && a.data) {
      return b;
    } else {
      return c;
    }
  }

  ValueType funcFloor(ValueType a, ValueType b, ValueType c) {
    if (a.data is num) {
      return ValueType((a.data as num).floor());
    } else {
      return a;
    }
  }

  ValueType funcRound(ValueType a, ValueType b, ValueType c) {
    if (a.data is num) {
      return ValueType((a.data as num).round());
    } else {
      return a;
    }
  }

  ValueType funcCeil(ValueType a, ValueType b, ValueType c) {
    if (a.data is num) {
      return ValueType((a.data as num).ceil());
    } else {
      return a;
    }
  }

  ValueType funcPlus(ValueType a, ValueType b, ValueType c) {
    if (a.data is num && b.data is num) {
      return ValueType(a.data + b.data);
    } else {
      return ValueType(a.data.toString() + b.data.toString());
    }
  }

  ValueType funcMinus(ValueType a, ValueType b, ValueType c) {
    if (a.data is num && b.data is num) {
      return ValueType(a.data - b.data);
    } else {
      return a;
    }
  }

  ValueType funcMulti(ValueType a, ValueType b, ValueType c) {
    if (a.data is num && b.data is num) {
      return ValueType(a.data * b.data);
    } else {
      return a;
    }
  }

  ValueType funcDiv(ValueType a, ValueType b, ValueType c) {
    if (a.data is num && b.data is num) {
      return ValueType(a.data / b.data);
    } else {
      return a;
    }
  }

  ValueType funcSet(ValueType a, ValueType b, ValueType c) {
    if(a.data is VariableUnit){
      VariableDataBase.instance.setValue((a.data as VariableUnit).varName, ValueTypeWrapper.normal(b));
    }
    return a;
  }

  var epsilon = 0.000001;

  ValueType funcEqual(ValueType a, ValueType b, ValueType c) {
    if (a.data is num && b.data is num) {
      return ValueType((a.data - b.data as num).abs() <= epsilon);
    } else {
      return ValueType(false);
    }
  }

  ValueType funcNotEqual(ValueType a, ValueType b, ValueType c) {
    return ValueType(!funcEqual(a, b, c).data);
  }

  ValueType funcBigger(ValueType a, ValueType b, ValueType c) {
    if (a.data is num && b.data is num) {
      return ValueType(a.data > b.data);
    } else {
      return ValueType(false);
    }
  }

  ValueType funcSmaller(ValueType a, ValueType b, ValueType c) {
    if (a.data is num && b.data is num) {
      return ValueType(a.data < b.data);
    } else {
      return ValueType(false);
    }
  }

  ValueType funcBiggerEqual(ValueType a, ValueType b, ValueType c) {
    return ValueType(!funcSmaller(a, b, c).data);
  }

  ValueType funcSmallerEqual(ValueType a, ValueType b, ValueType c) {
    return ValueType(!funcBigger(a, b, c).data);
  }

  ValueType funcRandom(ValueType a, ValueType b, ValueType c) {
    if (a.data is int) {
      return ValueType(Random().nextInt(a.data as int));
    } else {
      return ValueType(Random().nextBool());
    }
  }

  ValueType funcAnd(ValueType a, ValueType b, ValueType c) {
    if (a.data is bool && b.data is bool) {
      return ValueType(a.data && b.data);
    } else {
      return ValueType(false);
    }
  }

  ValueType funcOr(ValueType a, ValueType b, ValueType c) {
    if (a.data is bool && b.data is bool) {
      return ValueType(a.data || b.data);
    } else {
      return ValueType(false);
    }
  }

  ValueType funcNot(ValueType a, ValueType b, ValueType c) {
    if (a.data is bool) {
      return ValueType(!a.data);
    } else {
      return ValueType(false);
    }
  }
}
