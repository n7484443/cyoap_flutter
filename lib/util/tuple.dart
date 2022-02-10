import 'package:cyoap_flutter/model/grammar/value_type.dart';

class Tuple<A, B>{
  A data1;
  B data2;
  Tuple(this.data1, this.data2);

  @override
  String toString() {
    return data1.toString() + ' : ' + data2.toString();
  }

  @override
  bool operator ==(other){
    return (other is Tuple<A, B>)
        && other.data1 == data1 && other.data2 == data2;
  }

  Map<String, dynamic> toJson() => {
    'data1' : data1,
    'data2' : data2,
    'typeA' : A.toString(),
    'typeB' : B.toString(),
  };

  Tuple.fromJson(Map<String, dynamic> json):
    data1 = json['data1'],
    data2 = json['typeB'] == 'ValueTypeVisible' ? ValueTypeWrapper.fromJson(json['data2']) : json['data2'];
}