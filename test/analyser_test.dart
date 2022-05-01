import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/model/grammar/analyser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var ins = VariableDataBase();
  String strTest = """
                numberTest0 = -5.5
                numberTest1 = 3
                numberTest2 = 3 + 5
                numberTest3 = 6 - 5.5
                numberTest4 = 6 * 3
                numberTest5 = 6 / 3
                
                boolTest1 = true
                boolTest2 = false
                
                roundTest = round(4.8)
                ceilTest = ceil(4.8)
                floorTest = floor(4.8)
                
                stringTest = "문자열 테스트String1"
                stringAddTest = "문자" + "열테스트1"
                
                comp1 = numberTest0 == -5.5
                comp2 = numberTest0 >= -5.5
                comp3 = numberTest0 > -5.5
                if(numberTest0 == -5.5, alpha = 11, beta = 15)
                if(numberTest0 != -5.5, gamma = 12, omega = 16)
                test_alpha = 1
                test_alpha += 3
                test_beta = 1
                test_beta -= 5
                
                and_test_alpha = true
                and_test_beta = true
                and_test_1 = and(true, and_test_beta, true, true, true, true)
                and_test_2 = and(false, true, true, true)
                and_test_3 = and(true, false)
                and_test_4 = and(false, false)
                
                multiple_test_1 = and(not(and(true, false)), true)
                
                let globalTest = 123
                """;
  String strTest2 = """
                numberTest0 < 0
  """;
  String strTest3 = """ 
                numberTest4 >= 19
  """;
  String strGlobalTest = """
                if(globalTest == 123, T = true, T = false)
                """;
  var recursiveData = Analyser().analyseCodes(strTest);
  Analyser().run(recursiveData);

  var epsilon = 0.00001;
  test('numberTest', (){
    expect(ins.getValueType('numberTest0')?.data, closeTo(-5.5, epsilon));
    expect(ins.getValueType('numberTest1')?.data, 3);
    expect(ins.getValueType('numberTest2')?.data, 8);
    expect(ins.getValueType('numberTest3')?.data, closeTo(0.5, epsilon));
    expect(ins.getValueType('numberTest4')?.data, 18);
    expect(ins.getValueType('numberTest5')?.data, 2);
  });

  test('boolTest', (){
    expect(ins.getValueType('boolTest1')?.data, true);
    expect(ins.getValueType('boolTest2')?.data, false);
  });

  test('funcTest', (){
    expect(ins.getValueType('roundTest')?.data, 5);
    expect(ins.getValueType('ceilTest')?.data, 5);
    expect(ins.getValueType('floorTest')?.data, 4);
  });

  test('stringTest', (){
    expect(ins.getValueType('stringTest')?.data, "문자열 테스트String1");
    expect(ins.getValueType('stringAddTest')?.data, "문자열테스트1");
  });

  test('compTest', (){
    expect(ins.getValueType('comp1')?.data, true);
    expect(ins.getValueType('comp2')?.data, true);
    expect(ins.getValueType('comp3')?.data, false);
  });

  test('ifTest', (){
    expect(ins.getValueType('alpha')?.data, 11);
    expect(ins.getValueType('beta')?.data, null);
    expect(ins.getValueType('gamma')?.data, null);
    expect(ins.getValueType('omega')?.data, 16);
  });
  test('addTest', (){
    expect(ins.getValueType('test_alpha')?.data, 4);
    expect(ins.getValueType('test_beta')?.data, -4);
  });

  test('and Test', (){
    expect(ins.getValueType('and_test_1')?.data, true);
    expect(ins.getValueType('and_test_2')?.data, false);
    expect(ins.getValueType('and_test_3')?.data, false);
    expect(ins.getValueType('and_test_4')?.data, false);
  });


  test('multiple Test', (){
    expect(ins.getValueType('multiple_test_1')?.data, true);
  });

  test('return Test', (){
    var recursiveData = Analyser().analyseCodes(strTest2);
    var ret = Analyser().check(recursiveData[0]);
    expect(ret.data as bool, true);

    recursiveData = Analyser().analyseCodes(strTest3);
    ret = Analyser().check(recursiveData[0]);
    expect(ret.data as bool, false);
  });

  test('global variable Test', (){
    recursiveData = Analyser().analyseCodes(strGlobalTest);
    for (var e in recursiveData) {
      e.unzip();
    }
    expect('T', true);
  });
}