import 'package:cyoap_flutter/model/grammar/analyser.dart';

import 'value_type.dart';

abstract class RecursiveUnit {
  ValueType body;

  // 함수 or 값
  RecursiveUnit() : body = ValueType(ValueTypeData.none);

  RecursiveUnit.fromValue(this.body);

  Map<String, dynamic> toJson();

  void add(RecursiveUnit unit) {}

  List<RecursiveUnit> get child => [];

  ValueType unzip();
}

RecursiveUnit getClassFromJson(Map<String, dynamic> json) {
  return json['class'] == 'RecursiveParser'
      ? RecursiveFunction.fromJson(json)
      : RecursiveData.fromJson(json);
}

class RecursiveFunction extends RecursiveUnit {
  List<RecursiveUnit> childNode = List.empty(growable: true);

  @override
  List<RecursiveUnit> get child => childNode;

  @override
  void add(RecursiveUnit unit) {
    childNode.add(unit);
  }

  RecursiveFunction(ValueType value) : super.fromValue(value);

  @override
  Map<String, dynamic> toJson() => {
        'class': 'RecursiveParser',
        'childNode': childNode,
        'value': body,
      };

  RecursiveFunction.fromJson(Map<String, dynamic> json) {
    super.body = ValueType.fromJson(json['value']);
    childNode = json.containsKey('childNode')
        ? (json['childNode'] as List).map((e) => getClassFromJson(e)).toList()
        : List.empty(growable: true);
  }

  @override
  String toString() {
    return '$body $childNode';
  }

  @override
  ValueType unzip() {
    if (body.data == null) return ValueType.none();
    if (Analyser().functionList.getFunction(body.data) != null) {
      var functionValueType = Analyser().functionList.getFunctionValueType(body.data);
      if(functionValueType != null){
        var input = childNode.map((e) => e.unzip()).toList();
        return functionValueType(input);
      }
      var functionVoid = Analyser().functionList.getFunctionVoid(body.data);
      if(functionVoid != null){
        functionVoid(child);
      }
    }
    return ValueType.none();
  }
}

class RecursiveData extends RecursiveUnit {
  RecursiveData(ValueType value) : super.fromValue(value);

  @override
  RecursiveData.fromJson(Map<String, dynamic> json) {
    super.body = ValueType.fromJson(json['value']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'class': 'RecursiveData',
        'value': body,
      };

  @override
  ValueType unzip() {
    return body;
  }

  @override
  String toString() {
    return body.toString();
  }
}
