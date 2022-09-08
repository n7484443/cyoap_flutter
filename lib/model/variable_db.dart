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

  var varMap = HashMap<String, ValueTypeWrapper>();

  VariableChangeCallback? variableChangeCallback;
  CheckListChangeCallback? checkListChangeCallback;

  void updateVariableTiles() {
    variableChangeCallback!();
  }

  void updateCheckList() {
    checkListChangeCallback!();
  }

  void setValue(String name, ValueTypeWrapper value) {
    varMap[name] = value;
    updateVariableTiles();
  }

  void deleteValue(String name) {
    varMap.remove(name);
    updateVariableTiles();
  }

  bool hasValue(String name) {
    return varMap.containsKey(name);
  }

  ValueTypeWrapper? getValueTypeWrapper(String name) {
    return varMap[name];
  }

  ValueType? getValueType(String name) {
    return varMap[name]?.valueType;
  }

  @override
  String toString() {
    return varMap.toString();
  }

  void clear() {
    varMap.clear();
    updateVariableTiles();
    updateCheckList();
  }

  void clearLocalVariable() {
    varMap.removeWhere((key, value) => !value.isGlobal);
  }
}
