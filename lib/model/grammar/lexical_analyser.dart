import 'analyser_const.dart';
import 'token.dart';

class LexicalAnalyser {
  /*
    어휘분석기. 토큰으로 변환한다.
     */
  List<Token> analyse(String input) {
    bool isStringInput = false;
    List<Token> tokenList = List.empty(growable: true);
    Token? tokenAdded;

    void addToken() {
      if (tokenAdded != null) {
        if (tokenAdded.dataString == 'let') {
          tokenAdded.type = AnalyserConst.variableLet;
        } else if (tokenAdded.dataString == 'var') {
          tokenAdded.type = AnalyserConst.variableVar;
        } else if (tokenAdded.type == AnalyserConst.unspecified) {
          if (isStringDouble(tokenAdded.dataString)) {
            if (tokenAdded.dataString.contains('.')) {
              tokenAdded.type = AnalyserConst.doubles;
            } else {
              tokenAdded.type = AnalyserConst.ints;
            }
          } else if (tokenAdded.dataString == "true" || tokenAdded.dataString == "false") {
            tokenAdded.type = AnalyserConst.bools;
          } else {
            tokenAdded.type = AnalyserConst.variableName;
          }
        }
        tokenList.add(tokenAdded);
      }
    }

    for (int i = 0; i < input.length; i++) {
      var c = input[i];
      switch (c) {
        case '-':
        case '+':
        case '*':
        case '/':
        case '<':
        case '>':
          addToken();
          tokenAdded = null;
          tokenAdded = Token(AnalyserConst.functionUnspecified, c);
          break;
        case '=':
          if (tokenAdded != null) {
            if (tokenAdded.type == AnalyserConst.functionUnspecified) {
              if (tokenAdded.dataString == '+' ||
                  tokenAdded.dataString == '-' ||
                  tokenAdded.dataString == '*' ||
                  tokenAdded.dataString == '/') {
                tokenList.add(Token(AnalyserConst.functionUnspecified, '='));
                tokenList.add(tokenList[tokenList.length - 2]);
                tokenList.add(tokenAdded);
                tokenAdded = null;
              } else {
                tokenAdded.addUnitData(c);
              }
            }
            addToken();
            tokenAdded = null;
          } else {
            tokenAdded = Token(AnalyserConst.functionUnspecified, c);
          }
          break;
        case '\'':
        case '"':
          if (isStringInput) {
            tokenList.add(tokenAdded!);
            tokenAdded = null;
          } else {
            tokenAdded = Token(AnalyserConst.strings, "");
          }
          isStringInput = !isStringInput;

          break;
        case '(':
          if (tokenAdded != null) {
            tokenAdded.type = AnalyserConst.function;
            tokenList.add(tokenAdded);
            tokenAdded = null;
          }
          tokenList.add(Token(AnalyserConst.functionStart, "("));
          break;
        case ')':
          addToken();
          tokenAdded = null;
          tokenList.add(Token(AnalyserConst.functionEnd, ")"));
          break;
        case ',':
          addToken();
          tokenAdded = null;
          tokenList.add(Token(AnalyserConst.functionComma, ","));
          break;
        case '!':
          tokenAdded = Token(AnalyserConst.functionUnspecified, "!");
          break;
        case ' ':
          if (!isStringInput) {
            addToken();
            tokenAdded = null;
          } else {
            tokenAdded!.addUnitData(c);
          }
          break;
        default:
          if (tokenAdded == null) {
            tokenAdded = Token(AnalyserConst.unspecified, c);
          } else if (tokenAdded.type == AnalyserConst.functionUnspecified) {
            if (tokenList.last.type == AnalyserConst.functionUnspecified &&
                (tokenAdded.dataString == '+' || tokenAdded.dataString == '-')) {
              tokenAdded.type = AnalyserConst.unspecified;
              tokenAdded.addUnitData(c);
            } else {
              addToken();
              tokenAdded = Token(AnalyserConst.unspecified, c);
            }
          } else {
            tokenAdded.addUnitData(c);
          }
          break;
      }
    }
    addToken();
    return tokenList;
  }

  bool isStringDouble(String s) {
    return double.tryParse(s) != null;
  }
}
