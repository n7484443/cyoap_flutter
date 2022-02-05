import 'dart:collection';

import 'package:cyoap_flutter/viewModel/vm_variable_table.dart';

import 'grammar/value_type.dart';

class VariableDataBase {
  static final VariableDataBase instance = VariableDataBase();
  var varMap = HashMap<String, ValueType>();
  VMVariableTable? viewModel;

  static VariableDataBase getInstance() {
    return instance;
  }

  void setValue(String name, ValueType value) {
    varMap[name] = value;
    viewModel?.updateLists();
  }


  bool hasValue(String name) {
    return varMap.containsKey(name);
  }

  ValueType? getValue(String name) {
    return varMap[name];
  }

  @override
  String toString() {
    return varMap.toString();
  }

  void clear() {
    varMap.clear();
    viewModel?.updateLists();
  }
}