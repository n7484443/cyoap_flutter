import 'package:cyoap_flutter/model/grammer/Analyser.dart';
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
  var l = Analyser.getInstance().parserLines(str_test_2);
  Analyser.getInstance().analyseList(l);
  expect(3, ins.getValue("a123123aa")?.data);

  var func = Analyser.getInstance().parserLines(str_test);

  expect("aaa = 3", func[0].trim());
  expect("a = 3 + 5", func[1].trim());

  Analyser.getInstance().analyseList(func);
  expect(3, ins.getValue("aaa")?.data);
  expect(8, ins.getValue("a")?.data);
  expect(5, ins.getValue("func1")?.data);
  expect(5, ins.getValue("func2")?.data);
  expect(4, ins.getValue("func3")?.data);
  expect(4, ins.getValue("func4")?.data);
  expect("abcdefg가나다라마바사", ins.getValue("c")?.data);
  expect(ins.getValue("d")?.data, true);
  expect(ins.getValue("e")?.data, false);
  expect(0.5, ins.getValue("f")?.data);

  expect(ins.getValue("comp1")?.data, true);
  expect(ins.getValue("comp2")?.data, true);
  expect(ins.getValue("comp3")?.data, false);

  expect(11, ins.getValue("alpha")?.data);
  expect(ins.getValue("beta")?.data, null);
  expect(ins.getValue("gamma")?.data, null);
  expect(16, ins.getValue("omega")?.data);

  expect(4, ins.getValue("test_alpha")?.data);

  expect(Analyser.getInstance().analyseConditional(str_check), true);
}