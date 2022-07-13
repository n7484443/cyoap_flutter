import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/model/grammar/analyser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var ins = VariableDataBase();
  var epsilon = 0.00001;

  test('numberTest', () {
    String strTest = """
    let numberTest0 = -5.5
    let numberTest1 = 3 * (3 + 5)
    let numberTest2 = (3 * 3) + 5
    let numberTest3 = 6 - 5.5
    let numberTest4 = 6 * 3
    let numberTest5 = 6 / 3
    """;
    Analyser().run(Analyser().analyseCodes(strTest));
    expect(ins.getValueType('numberTest0')?.data, closeTo(-5.5, epsilon));
    expect(ins.getValueType('numberTest1')?.data, 24);
    expect(ins.getValueType('numberTest2')?.data, 14);
    expect(ins.getValueType('numberTest3')?.data, closeTo(0.5, epsilon));
    expect(ins.getValueType('numberTest4')?.data, 18);
    expect(ins.getValueType('numberTest5')?.data, 2);
  });
  test('boolTest', () {
    String strTest = """                
    var boolTest1 = true
    var boolTest2 = false
    """;
    Analyser().run(Analyser().analyseCodes(strTest));
    expect(ins.getValueType('boolTest1')?.data, true);
    expect(ins.getValueType('boolTest2')?.data, false);
  });

  test('funcTest', () {
    String strTest = """
    var roundTest = round(4.8)
    var ceilTest = ceil(4.8)
    var floorTest = floor(4.8)
    """;
    Analyser().run(Analyser().analyseCodes(strTest));
    expect(ins.getValueType('roundTest')?.data, 5);
    expect(ins.getValueType('ceilTest')?.data, 5);
    expect(ins.getValueType('floorTest')?.data, 4);
  });

  test('stringTest', () {
    String strTest = """
    var stringTest = "문자열 테스트String1"
    var stringAddTest = "문자" + "열테스트1"
    var stringAddTest1 = "문자열테스트1"
    var stringAddTest2 = stringAddTest == stringAddTest1
    """;
    Analyser().run(Analyser().analyseCodes(strTest));
    expect(ins.getValueType('stringTest')?.data, "문자열 테스트String1");
    expect(ins.getValueType('stringAddTest')?.data, "문자열테스트1");
    expect(ins.getValueType('stringAddTest1')?.data, "문자열테스트1");
    expect(ins.getValueType('stringAddTest2')?.data, true);
  });

  test('compTest', () {
    String strTest = """
    var comp1 = numberTest0==-5.5
    var comp2 = numberTest0 >= -5.5
    var comp3 = numberTest0 > -5.5
    """;
    Analyser().run(Analyser().analyseCodes(strTest));
    expect(ins.getValueType('comp1')?.data, true);
    expect(ins.getValueType('comp2')?.data, true);
    expect(ins.getValueType('comp3')?.data, false);
  });
  test('addTest', () {
    var addTestStr = """
    var test_alpha = 1
    test_alpha+=3
    var test_beta = 1
    test_beta -= 5
    """;
    Analyser().run(Analyser().analyseCodes(addTestStr));
    expect(ins.getValueType('test_alpha')?.data, 4);
    expect(ins.getValueType('test_beta')?.data, -4);
  });

  test('and Test', () {
    var andTestStr = """
    var and_test_alpha = true
    var and_test_beta = true
    var and_test_1 = and(true, and_test_beta, true, true, true, true)
    var and_test_2 = and(false, true, true, true)
    var and_test_3 = and(true, false)
    var and_test_4 = and(false, false)
    """;
    Analyser().run(Analyser().analyseCodes(andTestStr));

    expect(ins.getValueType('and_test_1')?.data, true);
    expect(ins.getValueType('and_test_2')?.data, false);
    expect(ins.getValueType('and_test_3')?.data, false);
    expect(ins.getValueType('and_test_4')?.data, false);
  });

  test('multiple Test', () {
    String strTest = """
    var multiple_test_1 = and(not(and(true, false)), true)
    """;
    Analyser().run(Analyser().analyseCodes(strTest));
    expect(ins.getValueType('multiple_test_1')?.data, true);
  });

  test('return Test', () {
    String strTest = """
    numberTest0 < 0
    """;
    String strTest1 = """ 
    numberTest4 >= 19
    """;
    var recursiveData = Analyser().analyseSingleLine(strTest);
    expect(Analyser().check(recursiveData) as bool, true);

    recursiveData = Analyser().analyseSingleLine(strTest1);
    expect(Analyser().check(recursiveData) as bool, false);
  });

  test('global variable Test', () {
    String strTest = """
    let globalTest = 123
    """;
    String strGlobalTest = """
    if(globalTest == 123){
      var T = true
    }else{
      var T2 = false
    }
    var existTest = exist("T")
    var existTest2 = exist("T2")
    """;
    Analyser().run(Analyser().analyseCodes(strTest));
    ins.clearLocalVariable();
    Analyser().run(Analyser().analyseCodes(strGlobalTest));
    expect(ins.getValueType('T')?.data, true);
    expect(ins.getValueType('existTest')?.data, true);
    expect(ins.getValueType('existTest2')?.data, false);
  });
  test('comment test', (){
    String strTest = """
      var commentTest = 123
      //이건 해석하면 안되는 문장. var asb = 0
      var commentTest1 = 0
    """;
    ins.clearLocalVariable();
    Analyser().run(Analyser().analyseCodes(strTest));
    expect(ins.getValueType('commentTest')?.data, 123);
    expect(ins.getValueType('asb')?.data, null);
    expect(ins.getValueType('commentTest1')?.data, 0);
  });

  test('ifTest', () {
    String strTest = """
    var numberTest0 = -5.5
    if(numberTest0 == -5.5){
      var alpha = 11
    }else{
      var beta = 15
    }
    if(numberTest0 == -5.5){
      var gamma = 12
    }
    """;
    Analyser().run(Analyser().analyseCodes(strTest));
    expect(ins.getValueType('alpha')?.data, 11);
    expect(ins.getValueType('beta')?.data, null);
    expect(ins.getValueType('gamma')?.data, 12);
  });
}
