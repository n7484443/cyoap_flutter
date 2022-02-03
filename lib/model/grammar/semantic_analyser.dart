import 'package:cyoap_flutter/model/grammar/analyser_const.dart';
import 'package:cyoap_flutter/model/grammar/recursive_parser.dart';
import 'package:cyoap_flutter/model/grammar/token.dart';
import 'package:cyoap_flutter/model/grammar/value_type.dart';
import 'package:cyoap_flutter/util/tuple.dart';

import 'analyser.dart';

class SemanticAnalyser {
  RecursiveUnit parserNull = RecursiveData(ValueType(valueTypeData.none));
  RecursiveUnit parserComma = RecursiveData(ValueType(valueTypeData.comma));

  RecursiveUnit compile(List<Token> tokens) {
    return analyseLines(tokens);
  }

  Tuple<RecursiveUnit, int> recursiveCreate(
      int i, List<Token> tokens, RecursiveUnit motherUnit) {
    if (i >= tokens.length) {
      return Tuple(motherUnit, i);
    }
    switch (tokens[i].type) {
      case AnalyserConst.functionStart:
        while (true) {
          var inner = recursiveCreate(i + 1, tokens, motherUnit);
          i = inner.data2;
          var innerParser = inner.data1;
          if (innerParser == parserComma) {
            i++;
            continue;
          } else if (innerParser == parserNull) {
            break;
          }

          motherUnit.add(innerParser);
        }
        return Tuple(motherUnit, i);
      case AnalyserConst.functionEnd:
        return Tuple(parserNull, i);
      case AnalyserConst.function:
        var funcParser = RecursiveParser(ValueType(tokens[i].toData()));
        return recursiveCreate(i + 1, tokens, funcParser);
      case AnalyserConst.functionComma:
        i++;
        return Tuple(parserComma, i);
      default:
        RecursiveData newParser;
        if (tokens[i].type == AnalyserConst.variable_name) {
          newParser = RecursiveData(ValueType(VariableUnit(tokens[i].data)));
        } else {
          newParser = RecursiveData(ValueType(tokens[i].toData()));
        }

        if (tokens.length >= i + 2) {
          if (tokens[i + 1].type == AnalyserConst.functionUnspecified) {
            var functionParser =
                RecursiveParser(ValueType(tokens[i + 1].toData()));
            var v = recursiveCreate(i + 2, tokens, functionParser);
            i = v.data2;
            functionParser.add(newParser);
            functionParser.add(v.data1);
            return Tuple(functionParser, i);
          }
        }
        return Tuple(newParser, i);
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
      return recursiveCreate(0, analysedData, parser).data1;
    }
    var parserAns = recursiveCreate(equalPos + 1, analysedData, parser);

    if (analysedData[equalPos - 1].type == AnalyserConst.variable_name) {
      var recursive = RecursiveData(
          ValueType(VariableUnit(analysedData[equalPos - 1].data)))
        ..dontReplace = true;
      return RecursiveParser(ValueType(Analyser.instance.functionList.funcSet))
        ..add(recursive)
        ..add(parserAns.data1);
    }
    throw Error();
  }
}
