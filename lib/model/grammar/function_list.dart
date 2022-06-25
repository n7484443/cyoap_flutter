import 'dart:math';

import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/model/variable_db.dart';

class Functions {
  Map<String, ValueType Function(List<ValueType> input)> functionValueType = {};
  Map<String, void Function(List<RecursiveUnit> input)> functionVoid = {};

  void init() {
    functionValueType['floor'] = funcFloor;
    functionValueType['round'] = funcRound;
    functionValueType['ceil'] = funcCeil;
    functionValueType['+'] = funcPlus;
    functionValueType['-'] = funcMinus;
    functionValueType['*'] = funcMulti;
    functionValueType['/'] = funcDiv;
    functionValueType['=='] = funcEqual;
    functionValueType['!='] = funcNotEqual;
    functionValueType['>'] = funcBigger;
    functionValueType['<'] = funcSmaller;
    functionValueType['>='] = funcBiggerEqual;
    functionValueType['<='] = funcSmallerEqual;
    functionValueType['and'] = funcAnd;
    functionValueType['or'] = funcOr;
    functionValueType['not'] = funcNot;
    functionValueType['random'] = funcRandom;
    functionValueType['exist'] =
        (input) => ValueType(VariableDataBase().hasValue(input[0].data));
    functionValueType['loadVariable'] =
        (input) => VariableDataBase().getValueType(input[0].data) ?? input[0];
    functionValueType['condition'] = (input) => input[0];

    functionVoid['if'] = (input) {
      var data0 = input[0].unzip();
      if (data0.data is bool && data0.data) {
        input[1].unzip();
      } else {
        input[2].unzip();
      }
    };
    functionVoid['setLocal'] = (input) {
      var data0 = input[0].unzip();
      var data1 = input[1].unzip();
      VariableDataBase().setValue(
          data0.data, ValueTypeWrapper(data1, false, isGlobal: false));
    };
    functionVoid['setGlobal'] = (input) {
      var data0 = input[0].unzip();
      var data1 = input[1].unzip();
      VariableDataBase()
          .setValue(data0.data, ValueTypeWrapper(data1, false, isGlobal: true));
    };
    functionVoid['setVariable'] = (input) {
      var data0 = input[0].unzip();
      var data1 = input[1].unzip();
      if (data0.data is! String) {
        return;
      }
      var original = VariableDataBase().getValueTypeWrapper(data0.data);
      if (original != null) {
        var copy = ValueTypeWrapper.copy(original)..valueType = data1;
        VariableDataBase().setValue(data0.data, copy);
      } else {
        VariableDataBase().setValue(
            data0.data, ValueTypeWrapper.normal(ValueType(data0.data), false));
      }
    };
    functionVoid['doLines'] = (input) {
      for (var line in input) {
        line.unzip();
      }
    };
    functionVoid['none'] = (input) {};
  }

  Function? getFunction(String name) {
    return functionValueType[name] ?? functionVoid[name];
  }

  ValueType Function(List<ValueType> input)? getFunctionValueType(String name) {
    return functionValueType[name];
  }

  void Function(List<RecursiveUnit> input)? getFunctionVoid(String name) {
    return functionVoid[name];
  }

  String getFunctionName(Function function) {
    for (var key in functionValueType.keys) {
      if (functionValueType[key] == function) {
        return key;
      }
    }
    for (var key in functionVoid.keys) {
      if (functionVoid[key] == function) {
        return key;
      }
    }
    return 'none';
  }

  ValueType funcNone(List<ValueType> input) {
    return input[0];
  }

  ValueType funcFloor(List<ValueType> input) {
    if (input[0].data is num) {
      return ValueType((input[0].data as num).floor());
    } else {
      return input[0];
    }
  }

  ValueType funcRound(List<ValueType> input) {
    if (input[0].data is num) {
      return ValueType((input[0].data as num).round());
    } else {
      return input[0];
    }
  }

  ValueType funcCeil(List<ValueType> input) {
    if (input[0].data is num) {
      return ValueType((input[0].data as num).ceil());
    } else {
      return input[0];
    }
  }

  ValueType funcPlus(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType(input[0].data + input[1].data);
    } else {
      return ValueType(input[0].data.toString() + input[1].data.toString());
    }
  }

  ValueType funcMinus(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType(input[0].data - input[1].data);
    } else {
      return input[0];
    }
  }

  ValueType funcMulti(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType(input[0].data * input[1].data);
    } else {
      return input[0];
    }
  }

  ValueType funcDiv(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType(input[0].data / input[1].data);
    } else {
      return input[0];
    }
  }

  var epsilon = 0.000001;

  ValueType funcEqual(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType((input[0].data - input[1].data as num).abs() <= epsilon);
    } else {
      return ValueType(input[0].data == input[1].data);
    }
  }

  ValueType funcNotEqual(List<ValueType> input) {
    return ValueType(!funcEqual(input).data);
  }

  ValueType funcBigger(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType(input[0].data > input[1].data);
    } else {
      return ValueType(false);
    }
  }

  ValueType funcSmaller(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType(input[0].data < input[1].data);
    } else {
      return ValueType(false);
    }
  }

  ValueType funcBiggerEqual(List<ValueType> input) {
    return ValueType(!funcSmaller(input).data);
  }

  ValueType funcSmallerEqual(List<ValueType> input) {
    return ValueType(!funcBigger(input).data);
  }

  ValueType funcRandom(List<ValueType> input) {
    if (input[0].data is int) {
      return ValueType(Random().nextInt(input[0].data as int));
    } else {
      return ValueType(Random().nextBool());
    }
  }

  ValueType funcAnd(List<ValueType> input) {
    for (var i in input) {
      if (!(i.data is bool && i.data == true)) {
        return ValueType(false);
      }
    }
    return ValueType(true);
  }

  ValueType funcOr(List<ValueType> input) {
    for (var i in input) {
      if (i.data is bool && i.data == true) {
        return ValueType(true);
      }
    }
    return ValueType(false);
  }

  ValueType funcNot(List<ValueType> input) {
    if (input[0].data is bool) {
      return ValueType(!input[0].data);
    } else {
      return ValueType(false);
    }
  }
}
