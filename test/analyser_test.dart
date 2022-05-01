import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/model/grammar/analyser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var ins = VariableDataBase();
  String strTest = """
                var numberTest0 = -5.5
                var numberTest1 = 3
                var numberTest2 = 3 + 5
                var numberTest3 = 6 - 5.5
                var numberTest4 = 6 * 3
                var numberTest5 = 6 / 3
                
                var boolTest1 = true
                var boolTest2 = false
                
                var roundTest = round(4.8)
                var ceilTest = ceil(4.8)
                var floorTest = floor(4.8)
                
                var stringTest = "문자열 테스트String1"
                var stringAddTest = "문자" + "열테스트1"
                
                var comp1 = numberTest0 == -5.5
                var comp2 = numberTest0 >= -5.5
                var comp3 = numberTest0 > -5.5
                if(numberTest0 == -5.5, var alpha = 11, var beta = 15)
                if(numberTest0 != -5.5, var gamma = 12, var omega = 16)
                var test_alpha = 1
                test_alpha += 3
                var test_beta = 1
                test_beta -= 5
                
                var and_test_alpha = true
                var and_test_beta = true
                var and_test_1 = and(true, and_test_beta, true, true, true, true)
                var and_test_2 = and(false, true, true, true)
                var and_test_3 = and(true, false)
                var and_test_4 = and(false, false)
                
                var multiple_test_1 = and(not(and(true, false)), true)
                
                let globalTest = 123
                """;
  String strTest2 = """
                numberTest0 < 0
  """;
  String strTest3 = """ 
                numberTest4 >= 19
  """;
  String strGlobalTest = """
                if(globalTest == 123, var T = true, var T = false)
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
    expect(Analyser().check(recursiveData[0]) as bool, true);

    recursiveData = Analyser().analyseCodes(strTest3);
    expect(Analyser().check(recursiveData[0]) as bool, false);
  });

  test('global variable Test', (){
    recursiveData = Analyser().analyseCodes(strGlobalTest);
    Analyser().run(recursiveData);
    expect(ins.getValueType('T')?.data, true);
  });
}