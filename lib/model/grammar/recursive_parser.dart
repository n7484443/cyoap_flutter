import 'package:cyoap_flutter/model/variable_db.dart';

import 'analyser.dart';
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
    return '$body$childNode';
  }

  @override
  ValueType unzip() {
    if (body.data == null) return ValueType.none();
    if (body.data is ValueTypeData) {
      return ValueType.none();
    }
    if (childNode.length == 3 && body.data == Analyser().functionList.funcIf) {
      if (childNode[0].unzip().data) {
        return childNode[1].unzip();
      } else {
        return childNode[2].unzip();
      }
    }
    if (body.data == Analyser().functionList.funcSetVariable) {
      var unzippedData0 = childNode[0].unzip();
      var unzippedData1 = childNode[1].unzip();
      if (unzippedData0 is! VariableUnit) {
        unzippedData0 = childNode[0].body;
      }
      var varName = (unzippedData0.data as VariableUnit).varName;
      var original = VariableDataBase().getValueTypeWrapper(varName)!;
      var copy = ValueTypeWrapper.copy(original)..valueType = unzippedData1;
      VariableDataBase().setValue(varName, copy);
      return unzippedData0;
    }
    if (body.data == Analyser().functionList.funcSetGlobal) {
      var unzippedData0 = childNode[0].unzip();
      var unzippedData1 = childNode[1].unzip();
      if (unzippedData0 is! VariableUnit) {
        unzippedData0 = childNode[0].body;
      }
      var varName = (unzippedData0.data as VariableUnit).varName;
      VariableDataBase()
          .setValue(varName, ValueTypeWrapper.normal(unzippedData1, true));
      return unzippedData0;
    }
    if (body.data == Analyser().functionList.funcSetLocal) {
      var unzippedData0 = childNode[0].unzip();
      var unzippedData1 = childNode[1].unzip();
      if (unzippedData0 is! VariableUnit) {
        unzippedData0 = childNode[0].body;
      }
      var varName = (unzippedData0.data as VariableUnit).varName;
      VariableDataBase()
          .setValue(varName, ValueTypeWrapper.normal(unzippedData1, false));
      return unzippedData0;
    }
    if (body.data == Analyser().functionList.funcExist) {
      var unzippedData0 = childNode[0].unzip();
      if (unzippedData0 is! VariableUnit) {
        unzippedData0 = childNode[0].body;
      }
      var varName = (unzippedData0.data as VariableUnit).varName;
      return ValueType(VariableDataBase().hasValue(varName));
    }
    var input = childNode.map((e) => e.unzip()).toList();
    return body.data(input);
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
    if (body.data is VariableUnit) {
      var variable = body.data as VariableUnit;
      if (VariableDataBase().hasValue(variable.varName)) {
        var wrapper = VariableDataBase().getValueTypeWrapper(variable.varName);
        return ValueType(wrapper?.valueType.data);
      }
    }
    return body;
  }

  @override
  String toString() {
    return body.toString();
  }
}