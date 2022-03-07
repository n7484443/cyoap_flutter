import 'package:cyoap_flutter/model/grammar/analyser_const.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/token.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';

import 'analyser.dart';

class SemanticAnalyser {
  RecursiveUnit parserNull = RecursiveData(ValueType(ValueTypeData.none));
  RecursiveUnit parserComma = RecursiveData(ValueType(ValueTypeData.comma));
  RecursiveUnit parserEnd = RecursiveData(ValueType(ValueTypeData.comma));

  RecursiveUnit compile(List<Token> tokens) {
    return analyseLines(tokens);
  }

  late List<Token> tokens;
  RecursiveUnit recursiveCreate(RecursiveUnit motherUnit) {
    if (tokens.isEmpty) {
      return parserEnd;
    }
    var t = tokens[0];
    tokens.removeAt(0);
    switch (t.type) {
      case AnalyserConst.functionStart:
        while (true) {
          var inner = recursiveCreate(motherUnit);
          if (inner == parserComma) {
            continue;
          } else if (inner == parserEnd) {
            break;
          }
          motherUnit.add(inner);
        }
        return motherUnit;
      case AnalyserConst.functionEnd:
        return parserEnd;
      case AnalyserConst.function:
        var funcParser = RecursiveParser(ValueType(t.toData()));
        return recursiveCreate(funcParser);
      case AnalyserConst.functionComma:
        return parserComma;
      default:
        RecursiveData newParser;
        if (t.type == AnalyserConst.variableName) {
          newParser = RecursiveData(ValueType(VariableUnit(t.data)));
        } else {
          newParser = RecursiveData(ValueType(t.toData()));
        }

        if (tokens.isNotEmpty) {
          var tokenAfter = tokens[0];
          if (tokenAfter.type == AnalyserConst.functionUnspecified) {
            tokens.removeAt(0);
            var functionParser = RecursiveParser(ValueType(tokenAfter.toData()));
            var v = recursiveCreate(functionParser);
            functionParser.add(newParser);
            functionParser.add(v);
            return functionParser;
          }
        }
        return newParser;
    }
  }

  RecursiveUnit analyseLines(List<Token> analysedData) {
    if (analysedData.isEmpty) return parserNull;

    if (analysedData[0].data == "if" &&
        analysedData[0].type == AnalyserConst.function) {
      List<int> comma = [0, 0];
      for (int i = 0; i < analysedData.length; i++) {
        if (analysedData[i].type == AnalyserConst.functionComma) {
          if (comma[0] == 0) {
            comma[0] = i;
          } else {
            comma[1] = i;
            break;
          }
        }
      }
      List<Token> listCheck = analysedData.sublist(2, comma[0]);
      List<Token> listTrue = analysedData.sublist(comma[0] + 1, comma[1]);
      List<Token> listFalse =
      analysedData.sublist(comma[1] + 1, analysedData.length - 1);

      return RecursiveParser(ValueType(analysedData[0].toData()))
        ..add(analyseLines(listCheck))
        ..add(analyseLines(listTrue))
        ..add(analyseLines(listFalse));
    }
    int equalPos = -1;
    for (int i = 0; i < analysedData.length; i++) {
      if (analysedData[i].type == AnalyserConst.equal) {
        equalPos = i;
        break;
      }
    }

    RecursiveParser parser = RecursiveParser(ValueType.none());
    if (equalPos == -1) {
      tokens = analysedData;
      return recursiveCreate(parser);
    }
    tokens = analysedData.sublist(equalPos + 1);
    var parserAns = recursiveCreate( parser);

    if (analysedData[equalPos - 1].type == AnalyserConst.variableName) {
      var recursive = RecursiveData(
          ValueType(VariableUnit(analysedData[equalPos - 1].data)))
        ..dontReplace = true;
      return RecursiveParser(ValueType(Analyser.instance.functionList.funcSet))
        ..add(recursive)
        ..add(parserAns);
    }
    throw Error();
  }
}
