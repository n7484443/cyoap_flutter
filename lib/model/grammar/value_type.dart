import '../variable_db.dart';
import 'analyser.dart';

class ValueType {
  dynamic data;

  ValueType(this.data) {
    if (data is ValueType) {
      throw Error();
    }
  }

  ValueType.none() : data = ValueTypeData.none;
  ValueType.comma() : data = ValueTypeData.comma;

  void set(ValueType a) {
    data = a.data;
  }

  dynamic dataUnzip() {
    if (data == null) return null;
    if (data != ValueTypeData.none) {
      if (data is VariableUnit) {
        return VariableDataBase().getValueTypeWrapper(data.varName);
      }
      return data;
    }
    return null;
  }

  @override
  String toString() {
    if (data is Function) {
      return data.toString().split('\'')[1];
    }
    return 'value Type : $data';
  }

  ValueType.fromJson(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'function':
        data = Analyser().functionList.getFunction(json['data']);
        break;
      case 'VariableUnit':
        data = VariableUnit.fromJson(json['data']);
        break;
      case 'int':
        data = int.tryParse(json['data']);
        break;
      case 'double':
        data = double.tryParse(json['data']);
        break;
      case 'bool':
        data = json['data'] == 'true';
        break;
      case 'String':
        data = json['data'] as String;
        break;
    }
  }

  Map<String, dynamic> toJson() => {
        'data': data is VariableUnit
            ? (data as VariableUnit).toJson()
            : (data is Function
                ? Analyser().functionList.getFunctionName(data)
                : data.toString()),
        'type': data is Function ? 'function' : data.runtimeType.toString(),
      };
}

class VariableUnit {
  String varName;

  VariableUnit(this.varName);

  @override
  String toString() {
    return 'Data From DB: "$varName"';
  }

  VariableUnit.fromJson(Map<String, dynamic> json) : varName = json['varName'];

  Map<String, dynamic> toJson() => {
        'varName': varName,
      };
}

enum ValueTypeData {
  none,
  comma,
}

class ValueTypeWrapper {
  ValueType valueType;
  bool visible;
  String displayName;

  ValueTypeWrapper(this.valueType, this.visible,
      {this.displayName = ''});

  ValueTypeWrapper.normal(this.valueType)
      : visible = false,
        displayName = '';

  ValueTypeWrapper.fromJson(Map<String, dynamic> json)
      : valueType = ValueType.fromJson(json['valueType']),
        visible = json['visible'] == 'true',
        displayName = json['displayName'] ?? '';

  Map<String, dynamic> toJson() => {
        'visible': visible.toString().toLowerCase(),
        'valueType': valueType.toJson(),
        'displayName': displayName,
      };

  @override
  String toString() {
    return '($valueType : $visible)';
  }
}
