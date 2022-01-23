import 'package:cyoap_flutter/model/grammer/LexicalAnalyser.dart';
import 'package:cyoap_flutter/model/grammer/VariableDataBase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var ins = VariableDataBase.getInstance();
  String str_test = """
                aaa = 3
                a = 3 + 5
                func1 = round(4.8)
                func2 = ceil(4.8)
                func3 = floor(4.8)
                func4 = floor(4)
                c = "abcdefg가나다라마바사"
                d = true
                e = false
                f = 6-5.5
                comp1 = f == 0.5
                comp2 = f >= 0.5
                comp3 = f > 0.5
                if(f == 0.5, alpha = 11, beta = 15)
                if(f == 8.5, gamma = 12, omega = 16)
                test_alpha = 1
                test_alpha += 3
                """;
  String str_test_2 = """
                a123123aa = 3
                """;
  String str_check = """
                f == 0.5
                """;
  LexicalAnalyzer.instance.analyze(str_test);

}