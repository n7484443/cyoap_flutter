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
        if(tokenAdded.data == 'let'){
          tokenAdded.type = AnalyserConst.let;
        }else if (tokenAdded.type == AnalyserConst.unspecified) {
          if (isStringDouble(tokenAdded.data)) {
            if (tokenAdded.data.contains('.')) {
              tokenAdded.type = AnalyserConst.doubles;
            } else {
              tokenAdded.type = AnalyserConst.ints;
            }
          } else if (tokenAdded.data == "true" || tokenAdded.data == "false") {
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
          tokenAdded = Token(AnalyserConst.functionUnspecified, c);
          break;
        case '<':
        case '>':
          tokenAdded = Token(AnalyserConst.functionUnspecified, c);
          break;
        case '=':
          if (tokenAdded != null) {
            if (tokenAdded.type == AnalyserConst.functionUnspecified) {
              if(tokenAdded.data == '+' || tokenAdded.data == '-' || tokenAdded.data == '*' || tokenAdded.data == '/'){
                tokenList.add(Token(AnalyserConst.equal, '='));
                tokenList.add(tokenList[tokenList.length - 2]);
                tokenList.add(tokenAdded);
                tokenAdded = null;
              }else{
                tokenAdded.addUnitData(c);
              }
            } else if (tokenAdded.type == AnalyserConst.equal) {
              tokenAdded.type = AnalyserConst.functionUnspecified;
              tokenAdded.addUnitData(c);
            }
            addToken();
            tokenAdded = null;
          } else {
            tokenAdded = Token(AnalyserConst.equal, c);
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
            if ((tokenList.last.type == AnalyserConst.functionUnspecified ||
                    tokenList.last.type == AnalyserConst.equal) &&
                (tokenAdded.data == '+' || tokenAdded.data == '-')) {
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
