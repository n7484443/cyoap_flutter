import 'analyser.dart';

class ValueType {
  dynamic data;

  ValueType(this.data){
    if(data is ValueType){
      throw Error();
    }
  }

  ValueType.none() : data = valueTypeData.none;

  void set(ValueType a) {
    data = a.data;
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
        data = Analyser.instance.functionList
            .getFunction(json['data'].toString().replaceFirst('func', ''));
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

  Map<String, dynamic> toJson() =>
      {
        'data': data is VariableUnit
            ? (data as VariableUnit).toJson()
            : (data is Function
                ? data.toString().split('\'')[1]
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

enum valueTypeData{
  none, comma,
}