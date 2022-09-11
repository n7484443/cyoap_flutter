import 'dart:math';

import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/model/variable_db.dart';

enum FunctionListEnum {
  plus(2),
  minus(2),
  mul(2),
  div(2),
  equal(2),
  notEqual(2),
  bigger(2),
  smaller(2),
  biggerEqual(2),
  smallerEqual(2),
  floor(1),
  round(1),
  ceil(1),
  and(2, hasMultipleArgument: true),
  or(2, hasMultipleArgument: true),
  not(1),
  random(1),
  exist(1),
  isVisible(1),
  loadVariable(1),
  condition(1),
  setLocal(2, hasOutput: false),
  setGlobal(2, hasOutput: false),
  setVariable(2, hasOutput: false),
  setVisible(2, hasOutput: false),
  none(0, hasOutput: false);

  const FunctionListEnum(this.argumentLength, {this.hasOutput = true, this.hasMultipleArgument = false});

  final int argumentLength;
  final bool hasOutput;
  final bool hasMultipleArgument;

  static FunctionListEnum getFunctionListEnum(String name){
    return FunctionListEnum.values.firstWhere((element) => element.name == name, orElse: (){
      print(name);
      return none;
    });
  }
}

class Functions {
  Map<FunctionListEnum, ValueType Function(List<ValueType> input)>
      functionUnspecifiedFunction = {};
  Map<FunctionListEnum, Function(List<ValueType> input)>
      functionValueType = {};

  void init() {
    functionUnspecifiedFunction[FunctionListEnum.plus] = funcPlus;
    functionUnspecifiedFunction[FunctionListEnum.minus] = funcMinus;
    functionUnspecifiedFunction[FunctionListEnum.mul] = funcMulti;
    functionUnspecifiedFunction[FunctionListEnum.div] = funcDiv;
    functionUnspecifiedFunction[FunctionListEnum.equal] = funcEqual;
    functionUnspecifiedFunction[FunctionListEnum.notEqual] = funcNotEqual;
    functionUnspecifiedFunction[FunctionListEnum.bigger] = funcBigger;
    functionUnspecifiedFunction[FunctionListEnum.smaller] = funcSmaller;
    functionUnspecifiedFunction[FunctionListEnum.biggerEqual] = funcBiggerEqual;
    functionUnspecifiedFunction[FunctionListEnum.smallerEqual] =
        funcSmallerEqual;

    functionValueType[FunctionListEnum.floor] = funcFloor;
    functionValueType[FunctionListEnum.round] = funcRound;
    functionValueType[FunctionListEnum.ceil] = funcCeil;
    functionValueType[FunctionListEnum.and] = funcAnd;
    functionValueType[FunctionListEnum.or] = funcOr;
    functionValueType[FunctionListEnum.not] = funcNot;
    functionValueType[FunctionListEnum.random] = funcRandom;
    functionValueType[FunctionListEnum.exist] =
        (input) => ValueType.bool(VariableDataBase().hasValue(input[0].data));
    functionValueType[FunctionListEnum.isVisible] = (input) => ValueType.bool(
        VariableDataBase().getValueTypeWrapper(input[0].data)?.visible ??
            false);
    functionValueType[FunctionListEnum.loadVariable] =
        (input) => VariableDataBase().getValueType(input[0].data) ?? input[0];
    functionValueType[FunctionListEnum.condition] = (input) => input[0];

    functionValueType[FunctionListEnum.setLocal] = (input) {
      var varName = input[0].dataUnzip as String;
      VariableDataBase()
          .setValue(varName, ValueTypeWrapper(input[1], isGlobal: false));
    };
    functionValueType[FunctionListEnum.setGlobal] = (input) {
      var varName = input[0].dataUnzip as String;
      VariableDataBase()
          .setValue(varName, ValueTypeWrapper(input[1], isGlobal: true));
    };
    functionValueType[FunctionListEnum.setVariable] = (input) {
      var varName = input[0].dataUnzip as String;
      var original = VariableDataBase().getValueTypeWrapper(varName);
      if (original != null) {
        var copy = original.copyWith(valueType: input[1]);
        VariableDataBase().setValue(varName, copy);
      }
    };
    functionValueType[FunctionListEnum.setVisible] = (input) {
      var varName = input[0].dataUnzip as String;
      var value = input[1].dataUnzip as bool;
      var original = VariableDataBase().getValueTypeWrapper(varName);
      if (original != null) {
        VariableDataBase().setValue(varName, original.copyWith(visible: value));
      }
    };
  }

  Function? getFunctionFromString(String name) {
    var enumData = FunctionListEnum.getFunctionListEnum(name);
    return getFunction(enumData);
  }

  Function? getFunction(FunctionListEnum enumData) {
    return functionUnspecifiedFunction[enumData] ??
        functionValueType[enumData];
  }

  bool isUnspecifiedFunction(String name) {
    var enumData = FunctionListEnum.getFunctionListEnum(name);
    return functionUnspecifiedFunction[enumData] != null;
  }

  bool hasFunction(String name) {
    return FunctionListEnum.getFunctionListEnum(name) != FunctionListEnum.none;
  }

  Function(List<ValueType> input)? getFunctionValueType(String name) {
    var enumData = FunctionListEnum.getFunctionListEnum(name);
    return functionUnspecifiedFunction[enumData] ?? functionValueType[enumData];
  }

  FunctionListEnum getFunctionName(Function function) {
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
    return FunctionListEnum.none;
  }

  ValueType funcFloor(List<ValueType> input) {
    if (input[0].type.isNum) {
      return ValueType.int((input[0].dataUnzip).floor());
    }
    return const ValueType.nulls();
  }

  ValueType funcRound(List<ValueType> input) {
    if (input[0].type.isNum) {
      return ValueType.int((input[0].dataUnzip).round());
    }
    return const ValueType.nulls();
  }

  ValueType funcCeil(List<ValueType> input) {
    if (input[0].type.isNum) {
      return ValueType.int((input[0].dataUnzip).ceil());
    }
    return const ValueType.nulls();
  }

  ValueType funcPlus(List<ValueType> input) {
    if (input[0].type.isInt && input[1].type.isInt) {
      return ValueType.int(input[0].dataUnzip + input[1].dataUnzip);
    } else if (input[0].type.isNum && input[1].type.isNum) {
      return ValueType.double(input[0].dataUnzip + input[1].dataUnzip);
    } else {
      return ValueType.string(input[0].data + input[1].data);
    }
  }

  ValueType funcMinus(List<ValueType> input) {
    if (input[0].type.isInt && input[1].type.isInt) {
      return ValueType.int(input[0].dataUnzip - input[1].dataUnzip);
    } else if (input[0].type.isNum && input[1].type.isNum) {
      return ValueType.double(input[0].dataUnzip - input[1].dataUnzip);
    }
    return const ValueType.nulls();
  }

  ValueType funcMulti(List<ValueType> input) {
    if (input[0].type.isInt && input[1].type.isInt) {
      return ValueType.int(input[0].dataUnzip * input[1].dataUnzip);
    } else if (input[0].type.isNum && input[1].type.isNum) {
      return ValueType.double(input[0].dataUnzip * input[1].dataUnzip);
    }
    return const ValueType.nulls();
  }

  ValueType funcDiv(List<ValueType> input) {
    if (input[0].type.isInt && input[1].type.isInt) {
      return ValueType.int(input[0].dataUnzip ~/ input[1].dataUnzip);
    } else if (input[0].type.isNum && input[1].type.isNum) {
      return ValueType.double(input[0].dataUnzip / input[1].dataUnzip);
    }
    return const ValueType.nulls();
  }

  var epsilon = 0.000001;

  ValueType funcEqual(List<ValueType> input) {
    if (input[0].type.isNotIntOne(input[1].type)) {
      return ValueType.bool(
          (input[0].dataUnzip - input[1].dataUnzip as num).abs() <= epsilon);
    }
    return ValueType.bool(input[0].data == input[1].data);
  }

  ValueType funcNotEqual(List<ValueType> input) =>
      ValueType.bool(!funcEqual(input).dataUnzip);

  ValueType funcBigger(List<ValueType> input) {
    if (input[0].type.isNum && input[1].type.isNum) {
      return ValueType.bool(input[0].dataUnzip > input[1].dataUnzip);
    }
    return const ValueType.bool(false);
  }

  ValueType funcSmaller(List<ValueType> input) {
    if (input[0].type.isNum && input[1].type.isNum) {
      return ValueType.bool(input[0].dataUnzip < input[1].dataUnzip);
    }
    return const ValueType.bool(false);
  }

  ValueType funcBiggerEqual(List<ValueType> input) =>
      ValueType.bool(!funcSmaller(input).dataUnzip);

  ValueType funcSmallerEqual(List<ValueType> input) =>
      ValueType.bool(!funcBigger(input).dataUnzip);

  ValueType funcRandom(List<ValueType> input) {
    if (input[0].type.isInt) {
      return ValueType.int(Random().nextInt(input[0].dataUnzip as int));
    }
    return ValueType.bool(Random().nextBool());
  }

  ValueType funcAnd(List<ValueType> input) {
    for (var i in input) {
      if (!(i.type.isBool && i.dataUnzip)) {
        return const ValueType.bool(false);
      }
    }
    return const ValueType.bool(true);
  }

  ValueType funcOr(List<ValueType> input) {
    for (var i in input) {
      if (i.type.isBool && i.dataUnzip) {
        return const ValueType.bool(true);
      }
    }
    return const ValueType.bool(false);
  }

  ValueType funcNot(List<ValueType> input) {
    if (input[0].type.isBool) {
      return ValueType.bool(!input[0].dataUnzip);
    }
    return const ValueType.bool(false);
  }
}
