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

  void setValue(String name, ValueTypeWrapper value, {bool? isGlobal}) {
    var trim = name.trim();
    if(isGlobal == null){
      if(varMapLocal.containsKey(name)){
        varMapLocal[trim] = value;
      }else if(varMapGlobal.containsKey(name)) {
        varMapGlobal[trim] = value;
      }
    }else if(isGlobal){
      varMapGlobal[trim] = value;
    }else{
      varMapLocal[trim] = value;
    }

    updateVariableTiles();
  }

  void deleteValue(String name) {
    var trim = name.trim();
    if(varMapLocal.containsKey(trim)){
      varMapLocal.remove(trim);
    }else{
      varMapGlobal.remove(trim);
    }
    updateVariableTiles();
  }

  bool hasValue(String name) {
    var trim = name.trim();
    return varMapLocal.containsKey(trim) || varMapGlobal.containsKey(trim);
  }

  ValueTypeWrapper? getValueTypeWrapper(String name) {
    var trim = name.trim();
    if(hasValue(trim)){
      return varMapLocal[trim] ?? varMapGlobal[trim];
    }
    return null;
  }

  ValueType? getValueType(String name) {
    var trim = name.trim();
    return getValueTypeWrapper(trim)?.valueType;
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
