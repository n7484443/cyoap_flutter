import 'AnalyzerConst.dart';
import 'ParsingUnit.dart';
import 'VariableDataBase.dart';

class LexicalAnalyzer {
  static final LexicalAnalyzer instance = LexicalAnalyzer();

  // 같은 값이 반환시->다음값으로
  // null 일때->함수 입력 끝
  bool b = false;

  static LexicalAnalyzer getInstance() {
    return instance;
  }

  /*
    어휘분석기. 토큰으로 변환한다.
     */
  List<ParsingUnit> analyze(String s) {
    var str = s.replaceAll(" ", "").replaceAll("\n", "");
    List<ParsingUnit> func = [];
    for (int i = 0; i < str.length; i++) {
      var c = str[i];
      var size = func.length - 1;
      switch (c) {
        case '+':
        case '-':
        case '*':
        case '/':
        case '<':
        case '>':
          func.add(ParsingUnit(AnalyzerConst.function_unspecified, c.toString()));
          break;
        case '=':
          String s_front = str[i - 1].toString();
          if (str[i - 1] == '=' || str[i - 1] == '!') {
            func[size] = ParsingUnit(AnalyzerConst.function_unspecified, s_front + "=");
          } else if (str[i - 1] == '<' || str[i - 1] == '>') {
            func.remove(size);
            func.add(ParsingUnit(AnalyzerConst.function_unspecified, s_front + "="));
          } else if (str[i - 1] == '+' ||
              str[i - 1] == '-' ||
              str[i - 1] == '*' ||
              str[i - 1] == '/') {
            func.remove(size);
            func.add(ParsingUnit(AnalyzerConst.equal, "="));
            func.add(ParsingUnit(
                AnalyzerConst.variable_name, func[0].data)); //a += b 를 a = a + b 꼴로 변환
            func.add(ParsingUnit(
                AnalyzerConst.function_unspecified, s_front)); //a += b 를 a = a + b 꼴로 변환
          } else {
            func.add(ParsingUnit(AnalyzerConst.equal, "="));
          }
          break;
        case '"':
          b = !b;
          break;
        case '(':
          if (func[size].type == AnalyzerConst.variable_name) {
            func[size] = func[size].changeUnitType(AnalyzerConst.function);
            func.add(ParsingUnit(AnalyzerConst.function_start, "("));
          }
          break;
        case ')':
          func.add(ParsingUnit(AnalyzerConst.function_end, ")"));
          break;
        case ',':
          func.add(ParsingUnit(AnalyzerConst.function_comma, ","));
          break;
        default:
          {
            if (b) {
              if (func[size].type == AnalyzerConst.strs) {
                func[size] = func[size].addUnitData(c);
              } else {
                func.add(ParsingUnit(AnalyzerConst.strs, c.toString()));
              }
            } else {
              var isDigit = (double.tryParse(c) != null);
              if (func.isEmpty) {
                func.add(ParsingUnit(
                    isDigit ? AnalyzerConst.ints : AnalyzerConst.variable_name, c.toString()));
              } else if (c == '.') {
                func[size] = ParsingUnit(AnalyzerConst.floats, func[size].data + c);
                if (!isStringDouble(func[size].data)) {
                  print("error! float has more than two point(.) \n");
                }
              } else if (isDigit) {
                switch (func[size].type) {
                  case AnalyzerConst.variable_name:
                  case AnalyzerConst.ints:
                  case AnalyzerConst.floats:
                    func[size] = func[size].addUnitData(c);
                    break;
                  default:
                    func.add(ParsingUnit(AnalyzerConst.ints, c.toString()));
                }
              } else {
                if (func[size].type == AnalyzerConst.variable_name) {
                  func[size] = func[size].addUnitData(c);
                  if (func[size].data.toLowerCase() == "true") {
                    func[size] = func[size].changeUnitType(AnalyzerConst.trues);
                  } else if (func[size].data.toLowerCase() == "false") {
                    func[size] = func[size].changeUnitType(AnalyzerConst.falses);
                  }
                } else if (func[size].type != AnalyzerConst.ints) {
                  func.add(ParsingUnit(AnalyzerConst.variable_name, c.toString()));
                  if (func[size].data.toLowerCase() == "true") {
                    func[size] = func[size].changeUnitType(AnalyzerConst.trues);
                  } else if (func[size].data.toLowerCase() == "false") {
                    func[size] = func[size].changeUnitType(AnalyzerConst.falses);
                  }
                }
              }
            }
          }
      }
    }
    return func;
  }

  dynamic getTypeFromInt(int t) {
    switch (t) {
      case AnalyzerConst.ints:
        return int;
      case AnalyzerConst.floats:
        return double;
      case AnalyzerConst.trues:
      case AnalyzerConst.falses:
        return bool;
      case AnalyzerConst.strs:
        return "string";
      case AnalyzerConst.function:
        return Function;
      case AnalyzerConst.variable_name:
        return "var";
      default:
        return ;
    }
  }

  bool isStringDouble(String s) {
    try {
      double.parse(s);
      return true;
    } catch (e) {
      return false;
    }
  }
}
