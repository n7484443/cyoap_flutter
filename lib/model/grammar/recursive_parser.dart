import 'dart:convert';

import 'analyser.dart';
import 'function_list.dart';
import 'value_type.dart';

abstract class RecursiveUnit {
  RecursiveUnit? parent;
  ValueType body;

  // 함수 or 값
  RecursiveUnit(this.body);

  Map<String, dynamic> toJson();

  void add(RecursiveUnit unit) {
    unit.parent = this;
  }

  List<RecursiveUnit> get child => [];

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  //return and output
  List<String> toByteCode();
}

class RecursiveFunction extends RecursiveUnit {
  RecursiveFunction(super.body);
  List<RecursiveUnit> childNode = List.empty(growable: true);

  @override
  List<RecursiveUnit> get child => childNode;

  @override
  void add(RecursiveUnit unit) {
    super.add(unit);
    childNode.add(unit);
  }

  @override
  Map<String, dynamic> toJson() => {
        'childNode': childNode,
        'value': body,
      };

  @override
  List<String> toByteCode() {
    if (body.data.isEmpty) return [];
    if(body.type.isString && body.data == "doLines"){
      List<String> list = [];
      for (var e in child) {
        var out = e.toByteCode();
        list.addAll(out);
      }
      return list;
    }
    if (body.type.isString && body.data == "returnCondition") {
      return  [...child[0].toByteCode(), "return"];
    }
    if (body.type.isString && body.data == "if") {
      var condition = child[0].toByteCode();
      var ifCode = child[1].toByteCode();
      List<String> output = [
        ...condition,
        "if_goto ${ifCode.length + 1}",
        ...ifCode,
      ];
      if(child.length == 3){
        var elseCode = child[2].toByteCode();
        return [
          ...output,
          "goto ${elseCode.length}",
          ...elseCode,
        ];
      }
      return output;
    }
    if (Analyser().functionList.hasFunction(body.data)) {
      var funcEnum = FunctionListEnum.getFunctionListEnum(body.data);
      List<String> output = [];
      for (var e in child) {
        output.addAll(e.toByteCode());
      }
      if(funcEnum.hasMultipleArgument){
        return [...output, "${body.data} ${child.length}"];
      }
      return [...output, body.data];
    }
    return [];
  }
}

class RecursiveData extends RecursiveUnit {
  RecursiveData(super.body);

  @override
  Map<String, dynamic> toJson() => {
        'value': body,
      };

  @override
  List<String> toByteCode() {
    if(body.data.isEmpty) return [];
    if(body.type.isString){
      return ["push \"${body.data}\""];
    }
    return ["push ${body.data}"];
  }
}
