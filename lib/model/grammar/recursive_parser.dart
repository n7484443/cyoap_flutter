import 'dart:convert';

import 'package:cyoap_flutter/model/grammar/analyser.dart';

import 'value_type.dart';

abstract class RecursiveUnit {
  RecursiveUnit? parent;
  ValueType body;

  // 함수 or 값
  RecursiveUnit() : body = ValueType(null);

  RecursiveUnit.fromValue(this.body);

  Map<String, dynamic> toJson();

  void add(RecursiveUnit unit) {
    unit.parent = this;
  }

  List<RecursiveUnit> get child => [];

  ValueType unzip();

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

RecursiveUnit? getClassFromJson(Map<String, dynamic>? json) {
  if (json == null) return null;
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
    super.add(unit);
    childNode.add(unit);
  }

  @override
  Map<String, dynamic> toJson() => {
        'class': 'RecursiveParser',
        'childNode': childNode,
        'value': body,
      };
  RecursiveFunction(super.value) : super.fromValue();

  RecursiveFunction.fromJson(Map<String, dynamic> json) {
    super.body = ValueType.fromJson(json['value']);
    childNode = json.containsKey('childNode')
        ? (json['childNode'] as List).map((e) => getClassFromJson(e)!).toList()
        : List.empty(growable: true);
  }

  @override
  ValueType unzip() {
    if (body.data == null) return ValueType(null);
    if (Analyser().functionList.hasFunction(body.data)) {
      var functionValueType =
          Analyser().functionList.getFunctionValueType(body.data);
      if (functionValueType != null) {
        var input = childNode.map((e) => e.unzip()).toList();
        return functionValueType(input);
      }
      var functionVoid = Analyser().functionList.getFunctionVoid(body.data);
      if (functionVoid != null) {
        functionVoid(child);
      }
    }
    return ValueType(null);
  }
}

class RecursiveData extends RecursiveUnit {
  RecursiveData(super.value) : super.fromValue();

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
  ValueType unzip() => body;
}
