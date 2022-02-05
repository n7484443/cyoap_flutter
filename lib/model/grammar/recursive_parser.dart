import 'package:cyoap_flutter/model/variable_db.dart';

import 'analyser.dart';
import 'value_type.dart';

abstract class RecursiveUnit{
  List<RecursiveUnit> childNode = List.empty(growable: true);

  // 노드마다 가지는 최대의 데이터:3
  // if ( a, then, else) 가 최대

  ValueType value;

  // 함수 or 값
  RecursiveUnit() :
        value = ValueType(valueTypeData.none);

  RecursiveUnit.fromValue(this.value);


  RecursiveUnit.fromJson(Map<String, dynamic> json)
      : childNode = json['childNode'],
        value = ValueType.fromJson(json);

  Map<String, dynamic> toJson() =>
      {
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
    if(childNode.isEmpty){
      return '$value';
    }
    return '$value | $childNode';
  }
}

class RecursiveParser extends RecursiveUnit {
  RecursiveParser(ValueType value) : super.fromValue(value);

  @override
  Map<String, dynamic> toJson() =>
      {
        'class': 'RecursiveParser',
        'childNode': childNode,
        'value': value,
      };

  RecursiveParser.fromJson(Map<String, dynamic> json){
    super.value = ValueType.fromJson(json['value']);
    super.childNode = json.containsKey('childNode') ? (json['childNode'] as List).map((e){
      if(e['class'] == 'RecursiveParser') {
        return RecursiveParser.fromJson(e);
      }else{
        return RecursiveData.fromJson(e);
      }
    }).toList() : List.empty(growable: true);
  }


  @override
  ValueType unzip() {
    switch (childNode.length) {
      case 0:
        return value.data(ValueType.none(), ValueType.none(), ValueType.none());
      case 1:
        return value.data(
            childNode[0].unzip(), ValueType.none(), ValueType.none());
      case 2:
        return value.data(childNode[0].unzip(), childNode[1].unzip(), ValueType.none());
      default:
        if(value.data == Analyser.instance.functionList.funcIf){
          if(childNode[0].unzip().data){
            return childNode[1].unzip();
          }else{
            return childNode[2].unzip();
          }
        }else{
          return value.data(childNode[0].unzip(), childNode[1].unzip(), childNode[2].unzip());
        }
    }
  }
}

class RecursiveData extends RecursiveUnit {
  bool dontReplace = false;

  RecursiveData(ValueType value) : super.fromValue(value);

  @override
  RecursiveData.fromJson(Map<String, dynamic> json)
      : dontReplace = json['dontReplace']{
    super.value = ValueType.fromJson(json['value']);
  }

  @override
  Map<String, dynamic> toJson() =>
      {
        'class': 'RecursiveData',
        'childNode': childNode,
        'value': value,
        'dontReplace': dontReplace,
      };

  @override
  ValueType unzip() {
    if (value.data is VariableUnit) {
      var variable = value.data as VariableUnit;
      if (VariableDataBase.instance.hasValue(variable.varName) &&
          !dontReplace) {
        return ValueType(VariableDataBase.instance
            .getValue(variable.varName)
            ?.data);
      } else {
        return value;
      }
    }
    return value;
  }
}