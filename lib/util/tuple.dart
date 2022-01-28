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
}