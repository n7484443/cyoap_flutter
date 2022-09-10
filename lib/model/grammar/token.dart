import 'analyser_const.dart';

class Token {
  AnalyserConst type;
  String dataString;

  Token(this.type, {this.dataString = ""});

  Token changeUnitType(AnalyserConst newType) {
    return Token(newType, dataString: dataString);
  }

  void addUnitData(String newData) {
    dataString += newData;
  }

  @override
  String toString() {
    return '$type : $dataString';
  }

  dynamic get data {
    switch (type) {
      case AnalyserConst.ints:
        return int.tryParse(dataString);
      case AnalyserConst.doubles:
        return double.tryParse(dataString);
      case AnalyserConst.bools:
        return dataString == 'true';
      default:
        return dataString;
    }
  }
}
