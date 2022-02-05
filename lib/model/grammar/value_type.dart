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
    if(json['data'].toString().startsWith('func')){
      data = Analyser.instance.functionList.getFunction(json['data'].toString().replaceFirst('func', ''));
      print(data);
    }else if(json['data'] is Map && (json['data'] as Map).containsKey('varName')){
      data = VariableUnit.fromJson(json['data']);
    }else{
      data = json['data'];
    }
  }

  Map<String, dynamic> toJson() => {
        'data': data is VariableUnit ? (data as VariableUnit).toJson() : (data is Function ? 'func${data.toString().split('\'')[1]}' : data.toString()),
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