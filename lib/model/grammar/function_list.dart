import 'dart:math';

import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/model/variable_db.dart';

class FunctionList {
  Function getFunction(String name) {
    switch (name) {
      case "if":
        return funcIf;
      case "floor":
        return funcFloor;
      case "round":
        return funcRound;
      case "ceil":
        return funcCeil;
      case "+":
        return funcPlus;
      case "-":
        return funcMinus;
      case "*":
        return funcMulti;
      case "/":
        return funcDiv;
      case "=":
        return funcSet;
      case "==":
        return funcEqual;
      case "!=":
        return funcNotEqual;
      case ">":
        return funcBigger;
      case "<":
        return funcSmaller;
      case ">=":
        return funcBiggerEqual;
      case "<=":
        return funcSmallerEqual;
      case "and":
        return funcAnd;
      case "or":
        return funcOr;
      case "random":
        return funcRandom;
      default:
        return funcNone;
    }
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
      VariableDataBase.instance.setValue((a.data as VariableUnit).varName, b);
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
}
