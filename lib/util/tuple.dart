import 'dart:ui';

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

  @override
  int get hashCode => hashValues(data1.hashCode, data2.hashCode);

  Tuple<double, double> mul(num sizeMultiply) {
    if(data1 is num && data2 is num){
      double alpha = data1 is double ? data1 as double : (data1 as int).toDouble();
      double beta = data2 is double ? data2 as double : (data2 as int).toDouble();
      return Tuple(alpha * sizeMultiply, beta * sizeMultiply);
    }
    throw 'none null mul';
  }

  Tuple<A, B> copy(){
    return Tuple(data1, data2);
  }

}