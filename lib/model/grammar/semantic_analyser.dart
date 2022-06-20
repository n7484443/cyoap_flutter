import 'package:cyoap_flutter/model/grammar/analyser_const.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/token.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';

class SemanticAnalyser {
  ///-1:block end
  int recursiveAnalyse(
      RecursiveUnit parent, List<Token> tokens, int posFromParent) {
    var pos = posFromParent;
    if (pos >= tokens.length) {
      return -1;
    }
    var token = tokens[pos];
    switch (token.type) {
      case AnalyserConst.functionUnspecified:
        RecursiveFunction sub = RecursiveFunction(ValueType(token.data));
        parent.add(sub);
        for(var i = 0; i < 2; i++){
          pos = recursiveAnalyse(sub, tokens, pos + 1);
        }
        break;
      case AnalyserConst.functionIf:
      case AnalyserConst.function:
      case AnalyserConst.blockStart:
        RecursiveFunction sub;
        if (token.type == AnalyserConst.blockStart) {
          sub = RecursiveFunction(ValueType("doLines"));
        } else {
          sub = RecursiveFunction(ValueType(token.data));
          pos++;// ( 가 있으므로
        }
        parent.add(sub);
        while (true) {
          var outPos = recursiveAnalyse(sub, tokens, pos + 1);
          if (outPos == -1) {
            pos++;
            break;
          }
          pos = outPos;
        }
        break;
      case AnalyserConst.functionComma:
        pos++;
        break;
      case AnalyserConst.blockEnd:
      case AnalyserConst.functionEnd:
        return -1;
      case AnalyserConst.variableName:
        RecursiveUnit out;
        if(parent.body.data == "setLocal" || parent.body.data == "setGlobal" || parent.body.data == "setVariable"){
          out = RecursiveData(ValueType(token.dataString));
        }else{
          out = RecursiveFunction(ValueType("loadVariable"));
        }
        out.add(RecursiveData(ValueType(token.dataString)));
        parent.add(out);
        break;
      case AnalyserConst.functionElse:
        break;
      default:
        parent.add(RecursiveData(ValueType(token.data)));
        break;
    }
    return pos;
  }

  RecursiveUnit? analyseLines(List<Token> analysedData) {
    if (analysedData.isEmpty) return null;
    analysedData.insert(0, Token(AnalyserConst.blockStart));
    analysedData.add(Token(AnalyserConst.blockEnd));
    var parent = RecursiveFunction(ValueType("doLines"));
    recursiveAnalyse(parent, analysedData, 0);
    return parent;
  }
}
