import 'dart:collection';

import 'value_type.dart';

class VariableDataBase {
  static final VariableDataBase instance = VariableDataBase();
  var varMap = HashMap<String, ValueType>();
  bool isUpdated = false;

  static VariableDataBase getInstance() {
    return instance;
  }

  void setValue(String name, ValueType value) {
    varMap[name] = value;
    isUpdated = true;
  }


  bool hasValue(String name) {
    return varMap.containsKey(name);
  }

  void changeValue(String name, ValueType value) {
    var v = varMap[name];
    if (v == null) {
      setValue(name, value);
      return;
    }

    if (v.data is int && value.data is int) {
      v.data = v.data + value.data;
    } else if ((v.data is int || v.data is double) && (value.data is int || value.data is double)) {
      v.data = v.data + value.data;
    }else{
      varMap[name]?.data += value.data;
    }

    isUpdated = true;
  }

  ValueType? getValue(String name) {
    return varMap[name];
  }

  @override
  String toString() {
    return varMap.toString();
  }
}