import 'analyser.dart';
import 'analyser_const.dart';

class Token {
  int type;
  String data;

  Token(this.type, this.data);
  Token changeUnitType(int newType) {
    return Token(newType, data);
  }

  Token addUnitData(String newData) {
    return Token(type, data + newData);
  }

  @override
  String toString() {
    return '$type : $data';
  }

  dynamic toData() {
    switch (type) {
      case AnalyserConst.ints:
        return int.tryParse(data);
      case AnalyserConst.doubles:
        return double.tryParse(data);
      case AnalyserConst.bools:
        return data == 'true';
      case AnalyserConst.strings:
        return data;
      case AnalyserConst.functionUnspecified:
      case AnalyserConst.function:
        return Analyser.instance.functionList.getFunction(data);
      default:
        return;
    }
  }
}
