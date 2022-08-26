import 'dart:math';

import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/model/variable_db.dart';

class Functions {
  Map<String, ValueType Function(List<ValueType> input)>
      functionUnspecifiedFunction = {};
  Map<String, ValueType Function(List<ValueType> input)> functionValueType = {};
  Map<String, void Function(List<RecursiveUnit> input)> functionVoid = {};

  void init() {
    functionUnspecifiedFunction['+'] = funcPlus;
    functionUnspecifiedFunction['-'] = funcMinus;
    functionUnspecifiedFunction['*'] = funcMulti;
    functionUnspecifiedFunction['/'] = funcDiv;
    functionUnspecifiedFunction['=='] = funcEqual;
    functionUnspecifiedFunction['!='] = funcNotEqual;
    functionUnspecifiedFunction['>'] = funcBigger;
    functionUnspecifiedFunction['<'] = funcSmaller;
    functionUnspecifiedFunction['>='] = funcBiggerEqual;
    functionUnspecifiedFunction['<='] = funcSmallerEqual;

    functionValueType['floor'] = funcFloor;
    functionValueType['round'] = funcRound;
    functionValueType['ceil'] = funcCeil;
    functionValueType['and'] = funcAnd;
    functionValueType['or'] = funcOr;
    functionValueType['not'] = funcNot;
    functionValueType['random'] = funcRandom;
    functionValueType['exist'] =
        (input) => ValueType(VariableDataBase().hasValue(input[0].data));
    functionValueType['isVisible'] = (input) => ValueType(
        VariableDataBase().getValueTypeWrapper(input[0].data)?.visible ??
            false);
    functionValueType['loadVariable'] =
        (input) => VariableDataBase().getValueType(input[0].data) ?? input[0];
    functionValueType['condition'] = (input) => input[0];

    functionVoid['if'] = (input) {
      var data0 = input[0].unzip();
      if (data0.data is bool && data0.data) {
        input[1].unzip();
      } else if (input.length == 3) {
        input[2].unzip();
      }
    };
    functionVoid['setLocal'] = (input) {
      var varName = input[0].unzip().data as String;
      VariableDataBase().setValue(
          varName, ValueTypeWrapper(input[1].unzip(), isGlobal: false));
    };
    functionVoid['setGlobal'] = (input) {
      var varName = input[0].unzip().data as String;
      VariableDataBase().setValue(
          varName, ValueTypeWrapper(input[1].unzip(), isGlobal: true));
    };
    functionVoid['setVariable'] = (input) {
      var varName = input[0].unzip().data as String;
      var original = VariableDataBase().getValueTypeWrapper(varName);
      if (original != null) {
        var copy = original.copyWith(valueType: input[1].unzip());
        VariableDataBase().setValue(varName, copy);
      }
    };
    functionVoid['setVisible'] = (input) {
      var varName = input[0].unzip().data as String;
      var value = input[1].unzip().data as bool;
      var original = VariableDataBase().getValueTypeWrapper(varName);
      if (original != null) {
        VariableDataBase().setValue(varName, original.copyWith(visible: value));
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
    return functionUnspecifiedFunction[name] ??
        functionValueType[name] ??
        functionVoid[name];
  }

  bool isUnspecifiedFunction(String name) {
    return functionUnspecifiedFunction[name] != null;
  }

  bool hasFunction(String name) {
    return getFunction(name) != null;
  }

  ValueType Function(List<ValueType> input)? getFunctionValueType(String name) {
    return functionUnspecifiedFunction[name] ?? functionValueType[name];
  }

  void Function(List<RecursiveUnit> input)? getFunctionVoid(String name) {
    return functionVoid[name];
  }

  String getFunctionName(Function function) {
    for (var key in functionUnspecifiedFunction.keys) {
      if (functionUnspecifiedFunction[key] == function) {
        return key;
      }
    }
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

  ValueType funcFloor(List<ValueType> input) {
    if (input[0].data is num) {
      return ValueType((input[0].data as num).floor());
    }
    return ValueType(null);
  }

  ValueType funcRound(List<ValueType> input) {
    if (input[0].data is num) {
      return ValueType((input[0].data as num).round());
    }
    return ValueType(null);
  }

  ValueType funcCeil(List<ValueType> input) {
    if (input[0].data is num) {
      return ValueType((input[0].data as num).ceil());
    }
    return ValueType(null);
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
    }
    return ValueType(null);
  }

  ValueType funcMulti(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType(input[0].data * input[1].data);
    }
    return ValueType(null);
  }

  ValueType funcDiv(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType(input[0].data / input[1].data);
    }
    return ValueType(null);
  }

  var epsilon = 0.000001;

  ValueType funcEqual(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType((input[0].data - input[1].data as num).abs() <= epsilon);
    } else {
      return ValueType(input[0].data == input[1].data);
    }
  }

  ValueType funcNotEqual(List<ValueType> input) =>
      ValueType(!funcEqual(input).data);

  ValueType funcBigger(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType(input[0].data > input[1].data);
    }
    return ValueType(false);
  }

  ValueType funcSmaller(List<ValueType> input) {
    if (input[0].data is num && input[1].data is num) {
      return ValueType(input[0].data < input[1].data);
    }
    return ValueType(false);
  }

  ValueType funcBiggerEqual(List<ValueType> input) =>
      ValueType(!funcSmaller(input).data);

  ValueType funcSmallerEqual(List<ValueType> input) =>
      ValueType(!funcBigger(input).data);

  ValueType funcRandom(List<ValueType> input) {
    if (input[0].data is int) {
      return ValueType(Random().nextInt(input[0].data as int));
    }
    return ValueType(Random().nextBool());
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
    }
    return ValueType(false);
  }
}
