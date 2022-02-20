import 'analyser_const.dart';
import 'token.dart';

class LexicalAnalyser {
  // 같은 값이 반환시->다음값으로
  // null 일때->함수 입력 끝
  bool boolForStringInput = false;

  /*
    어휘분석기. 토큰으로 변환한다.
     */
  List<Token> analyze(String s) {
    var str = s.replaceAll(" ", "").replaceAll("\n", "");
    List<Token> func = [];
    for (int i = 0; i < str.length; i++) {
      var c = str[i];
      var size = func.length - 1;
      switch (c) {
        case '-':
          if(i + 1 < str.length && str[i + 1] != '='){
            if (func[size].type != AnalyserConst.doubles &&
                func[size].type != AnalyserConst.ints) {
              func.add(Token(AnalyserConst.ints, '0'));
            }
          }
          func.add(Token(AnalyserConst.functionUnspecified, c.toString()));

          break;
        case '+':
        case '*':
        case '/':
        case '<':
        case '>':
          func.add(Token(AnalyserConst.functionUnspecified, c.toString()));
          break;
        case '=':
          String sFront = str[i - 1].toString();
          if (str[i - 1] == '=' || str[i - 1] == '!') {
            func[size] = Token(AnalyserConst.functionUnspecified, sFront + "=");
          } else if (str[i - 1] == '<' || str[i - 1] == '>') {
            func[size] = Token(AnalyserConst.functionUnspecified, sFront + "=");
          } else if (str[i - 1] == '+' ||
              str[i - 1] == '-' ||
              str[i - 1] == '*' ||
              str[i - 1] == '/') {
            func[size] = Token(AnalyserConst.equal, "=");
            func.add(Token(AnalyserConst.variableName,
                func[0].data)); //a += b 를 a = a + b 꼴로 변환
            func.add(Token(AnalyserConst.functionUnspecified,
                sFront)); //a += b 를 a = a + b 꼴로 변환
          } else {
            func.add(Token(AnalyserConst.equal, "="));
          }
          break;
        case '"':
          boolForStringInput = !boolForStringInput;
          break;
        case '(':
          if (func[size].type == AnalyserConst.variableName) {
            func[size] = func[size].changeUnitType(AnalyserConst.function);
            func.add(Token(AnalyserConst.functionStart, "("));
          }
          break;
        case ')':
          func.add(Token(AnalyserConst.functionEnd, ")"));
          break;
        case ',':
          func.add(Token(AnalyserConst.functionComma, ","));
          break;
        case '!':
          func.add(Token(AnalyserConst.functionUnspecified, "!"));
          break;
        default:
          if (boolForStringInput) {
            if (func[size].type == AnalyserConst.strs) {
              func[size] = func[size].addUnitData(c);
            } else {
              func.add(Token(AnalyserConst.strs, c.toString()));
            }
          } else {
            var isDigit = isStringDouble(c);
            if (func.isEmpty) {
              func.add(Token(
                  isDigit ? AnalyserConst.ints : AnalyserConst.variableName,
                  c.toString()));
            } else if (c == '.') {
              func[size] = Token(AnalyserConst.doubles, func[size].data + c);
              if (!isStringDouble(func[size].data)) {
                print("error! float has more than two point(.) \n");
              }
            } else if (isDigit) {
              switch (func[size].type) {
                case AnalyserConst.variableName:
                case AnalyserConst.ints:
                case AnalyserConst.doubles:
                  func[size] = func[size].addUnitData(c);
                  break;
                default:
                  func.add(Token(AnalyserConst.ints, c.toString()));
                  break;
              }
            } else {
              if (func[size].type == AnalyserConst.variableName) {
                func[size] = func[size].addUnitData(c);
                if (func[size].data.toLowerCase() == "true") {
                  func[size] = Token(AnalyserConst.bools, 'true');
                } else if (func[size].data.toLowerCase() == "false") {
                  func[size] = Token(AnalyserConst.bools, 'false');
                }
              } else if (func[size].type != AnalyserConst.ints) {
                func.add(Token(AnalyserConst.variableName, c.toString()));
                if (func[size].data.toLowerCase() == "true") {
                  func[size] = Token(AnalyserConst.bools, 'true');
                } else if (func[size].data.toLowerCase() == "false") {
                  func[size] = Token(AnalyserConst.bools, 'false');
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
      case AnalyserConst.ints:
        return int;
      case AnalyserConst.doubles:
        return double;
      case AnalyserConst.bools:
        return bool;
      case AnalyserConst.strs:
        return "string";
      case AnalyserConst.function:
        return Function;
      case AnalyserConst.variableName:
        return "var";
      default:
        return;
    }
  }

  bool isStringDouble(String s) {
    return double.tryParse(s) != null;
  }
}
