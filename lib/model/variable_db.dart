import 'dart:collection';

import 'grammar/value_type.dart';

typedef VariableChangeCallback = void Function();
typedef CheckListChangeCallback = void Function();

class VariableDataBase {
  static final VariableDataBase _instance = VariableDataBase._init();

  factory VariableDataBase() {
    return _instance;
  }

  VariableDataBase._init();

  var varMapGlobal = HashMap<String, ValueTypeWrapper>();
  var varMapLocal = HashMap<String, ValueTypeWrapper>();

  VariableChangeCallback? variableChangeCallback;
  CheckListChangeCallback? checkListChangeCallback;

  void updateVariableTiles() {
    if(variableChangeCallback != null){
      variableChangeCallback!();
    }
  }

  void updateCheckList() {
    if(checkListChangeCallback != null) {
      checkListChangeCallback!();
    }
  }

  void setValue(String name, ValueTypeWrapper value) {
    if(value.isGlobal){
      varMapGlobal[name] = value;
    }else{
      varMapLocal[name] = value;
    }
    updateVariableTiles();
  }

  void deleteValue(String name) {
    if(varMapLocal.containsKey(name)){
      varMapLocal.remove(name);
    }else{
      varMapGlobal.remove(name);
    }
    updateVariableTiles();
  }

  bool hasValue(String name) {
    return varMapLocal.containsKey(name) || varMapGlobal.containsKey(name);
  }

  ValueTypeWrapper? getValueTypeWrapper(String name) {
    if(hasValue(name)){
      return varMapLocal[name] ?? varMapGlobal[name];
    }
    return null;
  }

  ValueType? getValueType(String name) {
    return getValueTypeWrapper(name)?.valueType;
  }

  @override
  String toString() {
    return varMapGlobal.toString();
  }

  void clear() {
    varMapGlobal.clear();
    varMapLocal.clear();
    updateVariableTiles();
    updateCheckList();
  }

  void clearLocalVariable() {
    varMapLocal.clear();
  }
}
