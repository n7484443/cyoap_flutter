import 'package:cyoap_flutter/model/variable_db.dart';

import 'analyser.dart';
import 'value_type.dart';

abstract class RecursiveUnit {
  List<RecursiveUnit> childNode = List.empty(growable: true);

  ValueType value;

  // 함수 or 값
  RecursiveUnit() : value = ValueType(ValueTypeData.none);

  RecursiveUnit.fromValue(this.value);

  RecursiveUnit.fromJson(Map<String, dynamic> json)
      : childNode = json['childNode'],
        value = ValueType.fromJson(json);

  Map<String, dynamic> toJson() => {
        'childNode': childNode,
        'value': value,
      };

  void add(RecursiveUnit unit) {
    childNode.add(unit);
  }

  int checkParser(int i) {
    for (int k = 0; k < childNode.length; k++) {
      i++;
      i = childNode[k].checkParser(i);
    }
    return i;
  }

  ValueType unzip();

  @override
  String toString() {
    if (childNode.isEmpty) {
      return '$value';
    }
    return '$value | $childNode';
  }
}

RecursiveUnit getClassFromJson(Map<String, dynamic> json) {
  return json['class'] == 'RecursiveParser'
      ? RecursiveParser.fromJson(json)
      : RecursiveData.fromJson(json);
}

class RecursiveParser extends RecursiveUnit {
  bool? createAsGlobal;

  RecursiveParser(ValueType value, {this.createAsGlobal})
      : super.fromValue(value);

  @override
  Map<String, dynamic> toJson() => {
        'class': 'RecursiveParser',
        'childNode': childNode,
        'value': value,
        'createAsGlobal': createAsGlobal,
      };

  RecursiveParser.fromJson(Map<String, dynamic> json)
      : createAsGlobal = json['createAsGlobal'] {
    super.value = ValueType.fromJson(json['value']);
    super.childNode = json.containsKey('childNode')
        ? (json['childNode'] as List).map((e) => getClassFromJson(e)).toList()
        : List.empty(growable: true);
  }

  @override
  ValueType unzip() {
    if (value.data == null) return ValueType.none();
    if (childNode.length == 3 && value.data == Analyser().functionList.funcIf) {
      if (childNode[0].unzip().data) {
        return childNode[1].unzip();
      } else {
        return childNode[2].unzip();
      }
    }
    if (value.data == Analyser().functionList.funcSet) {
      var unzippedData0 = childNode[0].unzip();
      var unzippedData1 = childNode[1].unzip();
      if(unzippedData0 is! VariableUnit){
        unzippedData0 = childNode[0].value;
      }
      var varName = (unzippedData0.data as VariableUnit).varName;
      if(createAsGlobal == null){
        var original = VariableDataBase().getValueTypeWrapper(varName)!;
        var copy = ValueTypeWrapper.copy(original)..valueType = unzippedData1;
        VariableDataBase().setValue(varName, copy);
      }else{
        VariableDataBase().setValue(varName, ValueTypeWrapper.normal(unzippedData1, createAsGlobal!));
      }
      return unzippedData0;
    }
    if(value.data == Analyser().functionList.funcExist){
      var unzippedData0 = childNode[0].unzip();
      if(unzippedData0 is! VariableUnit){
        unzippedData0 = childNode[0].value;
      }
      var varName = (unzippedData0.data as VariableUnit).varName;
      return ValueType(VariableDataBase().hasValue(varName));
    }
    var input = childNode.map((e) => e.unzip()).toList();
    return value.data(input);
  }
}

class RecursiveData extends RecursiveUnit {
  RecursiveData(ValueType value) : super.fromValue(value);

  @override
  RecursiveData.fromJson(Map<String, dynamic> json) {
    super.value = ValueType.fromJson(json['value']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'class': 'RecursiveData',
        'childNode': childNode,
        'value': value,
      };

  @override
  ValueType unzip() {
    if (value.data is VariableUnit) {
      var variable = value.data as VariableUnit;
      if (VariableDataBase().hasValue(variable.varName)) {
        var wrapper = VariableDataBase().getValueTypeWrapper(variable.varName);
        return ValueType(wrapper?.valueType.data);
      }
    }
    return value;
  }
}
