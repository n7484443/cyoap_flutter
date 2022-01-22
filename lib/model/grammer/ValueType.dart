import 'VariableDataBase.dart';

class ValueType {
  dynamic data;

  ValueType(this.data);

  void set(ValueType a) {
    data = a.data;
  }
  String toString() {
    return 'ValueType{data=$data}';
  }
}
