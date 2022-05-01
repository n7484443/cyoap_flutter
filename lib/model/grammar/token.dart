import 'analyser.dart';
import 'analyser_const.dart';

class Token {
  int type;
  String dataString;

  Token(this.type, this.dataString);
  Token changeUnitType(int newType) {
    return Token(newType, dataString);
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
      case AnalyserConst.strings:
        return dataString;
      case AnalyserConst.functionUnspecified:
      case AnalyserConst.function:
        return Analyser().functionList.getFunction(dataString);
      default:
        return;
    }
  }
}
