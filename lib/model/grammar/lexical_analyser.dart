import 'analyser_const.dart';
import 'token.dart';

class LexicalAnalyser {
  /*
    어휘분석기. 토큰으로 변환한다.
     */
  List<Token> analyse(String input) {
    bool isStringInput = false;
    Token? tokenAdded;
    List<Token> tokenList = List.empty(growable: true);

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
          } else if (tokenAdded.dataString == "true" ||
              tokenAdded.dataString == "false") {
            tokenAdded.type = AnalyserConst.bools;
          } else if (tokenAdded.dataString == "else") {
            tokenAdded.type = AnalyserConst.functionElse;
          } else {
            tokenAdded.type = AnalyserConst.variableName;
          }
        }
        tokenList.add(tokenAdded);
      }
    }

    var isCommitLine = false;
    var line = input.trim();
    for (int i = 0; i < line.length; i++) {
      var c = line[i];
      switch (c) {
        case '/':
          if (isCommitLine) {
            tokenAdded = null;
            break;
          } else {
            isCommitLine = true;
            addToken();
            tokenAdded =
                Token(AnalyserConst.functionUnspecified, dataString: c);
          }
          break;
        case '-':
        case '+':
        case '*':
        case '<':
        case '>':
          addToken();
          tokenAdded = Token(AnalyserConst.functionUnspecified, dataString: c);
          break;
        case '=':
          if (tokenAdded != null &&
              tokenAdded.type == AnalyserConst.functionUnspecified) {
            tokenAdded.addUnitData(c);
            if (tokenAdded.dataString == '+=' ||
                tokenAdded.dataString == '-=' ||
                tokenAdded.dataString == '*=' ||
                tokenAdded.dataString == '/=') {
              tokenList.add(
                  Token(AnalyserConst.functionUnspecified, dataString: '='));
              tokenList.add(tokenList[tokenList.length - 2]);
              tokenList.add(Token(AnalyserConst.functionUnspecified,
                  dataString: tokenAdded.dataString.replaceAll("=", "")));
              tokenAdded = null;
            }
          } else {
            addToken();
            tokenAdded =
                Token(AnalyserConst.functionUnspecified, dataString: c);
          }
          break;
        case '\'':
        case '"':
          if (isStringInput) {
            tokenList.add(tokenAdded!);
            tokenAdded = null;
          } else {
            tokenAdded = Token(AnalyserConst.strings);
          }
          isStringInput = !isStringInput;

          break;
        case '(':
          if (tokenAdded != null) {
            if (tokenAdded.dataString == "if") {
              tokenAdded.type = AnalyserConst.functionIf;
            } else {
              tokenAdded.type = AnalyserConst.function;
            }
            tokenList.add(tokenAdded);
            tokenAdded = null;
          }
          tokenList.add(Token(AnalyserConst.functionStart));
          break;
        case ')':
          addToken();
          tokenAdded = null;
          tokenList.add(Token(AnalyserConst.functionEnd));
          break;
        case ',':
          addToken();
          tokenAdded = null;
          tokenList.add(Token(AnalyserConst.functionComma));
          break;
        case '{':
          addToken();
          tokenAdded = null;
          tokenList.add(Token(AnalyserConst.blockStart));
          break;
        case '}':
          addToken();
          tokenAdded = null;
          tokenList.add(Token(AnalyserConst.blockEnd));
          break;
        case ' ':
          if (isStringInput) {
            tokenAdded!.addUnitData(c);
          } else {
            addToken();
            tokenAdded = null;
          }
          break;
        default:
          if (tokenAdded == null) {
            tokenAdded = Token(AnalyserConst.unspecified, dataString: c);
          } else if (tokenAdded.type == AnalyserConst.functionUnspecified) {
            if (tokenList.last.type == AnalyserConst.functionUnspecified &&
                (tokenAdded.dataString == '+' ||
                    tokenAdded.dataString == '-')) {
              tokenAdded.type = AnalyserConst.unspecified;
              tokenAdded.addUnitData(c);
            } else {
              addToken();
              tokenAdded = Token(AnalyserConst.unspecified, dataString: c);
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

  List<Token> changeToFunction(List<Token> tokenList) {
    var tokenOutput = List<Token>.empty(growable: true);
    var check = 0;
    for (var token in tokenList) {
      if (token.type == AnalyserConst.variableVar) {
        check = 1;
      } else if (token.type == AnalyserConst.variableLet) {
        check = 2;
      } else if (token.dataString == "=") {
        if (check == 0) {
          tokenOutput.add(Token(AnalyserConst.functionUnspecified,
              dataString: "setVariable"));
        } else if (check == 1) {
          tokenOutput.add(
              Token(AnalyserConst.functionUnspecified, dataString: "setLocal"));
        } else if (check == 2) {
          tokenOutput.add(Token(AnalyserConst.functionUnspecified,
              dataString: "setGlobal"));
        }
        check = 0;
      } else if (token.dataString == "+") {
        tokenOutput
            .add(Token(AnalyserConst.functionUnspecified, dataString: "plus"));
      } else if (token.dataString == "-") {
        tokenOutput
            .add(Token(AnalyserConst.functionUnspecified, dataString: "minus"));
      } else if (token.dataString == "*") {
        tokenOutput
            .add(Token(AnalyserConst.functionUnspecified, dataString: "mul"));
      } else if (token.dataString == "/") {
        tokenOutput
            .add(Token(AnalyserConst.functionUnspecified, dataString: "div"));
      } else if (token.dataString == "==") {
        tokenOutput
            .add(Token(AnalyserConst.functionUnspecified, dataString: "equal"));
      } else if (token.dataString == ">") {
        tokenOutput
            .add(Token(AnalyserConst.functionUnspecified, dataString: "bigger"));
      } else if (token.dataString == ">=") {
        tokenOutput
            .add(Token(AnalyserConst.functionUnspecified, dataString: "biggerEqual"));
      } else if (token.dataString == "<") {
        tokenOutput
            .add(Token(AnalyserConst.functionUnspecified, dataString: "smaller"));
      } else if (token.dataString == "<=") {
        tokenOutput
            .add(Token(AnalyserConst.functionUnspecified, dataString: "smallerEqual"));
      } else {
        tokenOutput.add(token);
      }
    }

    return tokenOutput;
  }

  bool isStringDouble(String s) {
    return double.tryParse(s) != null;
  }
}
