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
    if(data is Function){
      return data.toString().split('\'')[1];
    }
    return 'value Type : $data';
  }
}

class VariableUnit {
  String varName;

  VariableUnit(this.varName);

  @override
  String toString(){
    return 'Data From DB: "$varName"';
  }
}

enum valueTypeData{
  none, comma,
}