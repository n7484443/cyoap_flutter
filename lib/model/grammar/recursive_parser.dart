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
  RecursiveParser(ValueType value) : super.fromValue(value);

  @override
  Map<String, dynamic> toJson() => {
        'class': 'RecursiveParser',
        'childNode': childNode,
        'value': value,
      };

  RecursiveParser.fromJson(Map<String, dynamic> json) {
    super.value = ValueType.fromJson(json['value']);
    super.childNode = json.containsKey('childNode')
        ? (json['childNode'] as List).map((e) => getClassFromJson(e)).toList()
        : List.empty(growable: true);
  }

  @override
  ValueType unzip() {
    if (value.data == null) return ValueType.none();
    if (childNode.length == 3 &&
        value.data == Analyser().functionList.funcIf) {
      if (childNode[0].unzip().data) {
        return childNode[1].unzip();
      } else {
        return childNode[2].unzip();
      }
    }
    var input = childNode.map((e) => e.unzip()).toList();
    return value.data(input);
  }
}

class RecursiveData extends RecursiveUnit {
  bool dontReplace = false;

  RecursiveData(ValueType value) : super.fromValue(value);

  @override
  RecursiveData.fromJson(Map<String, dynamic> json)
      : dontReplace = json['dontReplace'] {
    super.value = ValueType.fromJson(json['value']);
  }

  @override
  Map<String, dynamic> toJson() => {
        'class': 'RecursiveData',
        'childNode': childNode,
        'value': value,
        'dontReplace': dontReplace,
      };

  @override
  ValueType unzip() {
    if (value.data is VariableUnit) {
      var variable = value.data as VariableUnit;
      if (VariableDataBase().hasValue(variable.varName) &&
          !dontReplace) {
        return ValueType(VariableDataBase()
            .getValueTypeWrapper(variable.varName)
            ?.valueType
            .data);
      } else {
        return value;
      }
    }
    return value;
  }
}
