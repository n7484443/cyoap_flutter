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
    Analyser().run(Analyser().analyseMultiLine(strTest));
    expect(ins.getValueType('numberTest0')?.dataUnzip, closeTo(-5.5, epsilon));
    expect(ins.getValueType('numberTest1')?.dataUnzip, 24);
    expect(ins.getValueType('numberTest2')?.dataUnzip, 14);
    expect(ins.getValueType('numberTest3')?.dataUnzip, closeTo(0.5, epsilon));
    expect(ins.getValueType('numberTest4')?.dataUnzip, 18);
    expect(ins.getValueType('numberTest5')?.dataUnzip, 2);
  });
  test('boolTest', () {
    String strTest = """                
    var boolTest1 = true
    var boolTest2 = false
    """;
    Analyser().run(Analyser().analyseMultiLine(strTest));
    expect(ins.getValueType('boolTest1')?.dataUnzip, true);
    expect(ins.getValueType('boolTest2')?.dataUnzip, false);
  });

  test('funcTest', () {
    String strTest = """
    var roundTest = round(4.8)
    var ceilTest = ceil(4.8)
    var floorTest = floor(4.8)
    """;
    Analyser().run(Analyser().analyseMultiLine(strTest));
    expect(ins.getValueType('roundTest')?.dataUnzip, 5);
    expect(ins.getValueType('ceilTest')?.dataUnzip, 5);
    expect(ins.getValueType('floorTest')?.dataUnzip, 4);
  });

  test('stringTest', () {
    String strTest = """
    var stringTest = "문자열 테스트String1"
    var stringAddTest = "문자" + "열테스트1"
    var stringAddTest1 = "문자열테스트1"
    var stringAddTest2 = stringAddTest == stringAddTest1
    """;
    Analyser().run(Analyser().analyseMultiLine(strTest));
    expect(ins.getValueType('stringTest')?.dataUnzip, "문자열 테스트String1");
    expect(ins.getValueType('stringAddTest')?.dataUnzip, "문자열테스트1");
    expect(ins.getValueType('stringAddTest1')?.dataUnzip, "문자열테스트1");
    expect(ins.getValueType('stringAddTest2')?.dataUnzip, true);
  });

  test('compTest', () {
    String strTest = """
    var comp1 = numberTest0==-5.5
    var comp2 = numberTest0 >= -5.5
    var comp3 = numberTest0 > -5.5
    """;
    Analyser().run(Analyser().analyseMultiLine(strTest));
    expect(ins.getValueType('comp1')?.dataUnzip, true);
    expect(ins.getValueType('comp2')?.dataUnzip, true);
    expect(ins.getValueType('comp3')?.dataUnzip, false);
  });
  test('addTest', () {
    var addTestStr = """
    var test_alpha = 1
    test_alpha+=3
    var test_beta = 1
    test_beta -= 5
    """;
    Analyser().run(Analyser().analyseMultiLine(addTestStr));
    expect(ins.getValueType('test_alpha')?.dataUnzip, 4);
    expect(ins.getValueType('test_beta')?.dataUnzip, -4);
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
    Analyser().run(Analyser().analyseMultiLine(andTestStr));

    expect(ins.getValueType('and_test_1')?.dataUnzip, true);
    expect(ins.getValueType('and_test_2')?.dataUnzip, false);
    expect(ins.getValueType('and_test_3')?.dataUnzip, false);
    expect(ins.getValueType('and_test_4')?.dataUnzip, false);
  });

  test('multiple Test', () {
    String strTest = """
    var multiple_test_1 = and(not(and(true, false)), true)
    """;
    Analyser().run(Analyser().analyseMultiLine(strTest));
    expect(ins.getValueType('multiple_test_1')?.dataUnzip, true);
  });

  test('return Test', () {
    String strTest = """
    numberTest0 < 0
    """;
    String strTest1 = """ 
    numberTest4 >= 19
    """;
    expect(Analyser().run(Analyser().analyseSingleLine(strTest)) as bool, true);
    expect(Analyser().run(Analyser().analyseSingleLine(strTest1)) as bool, false);
  });

  test('global variable Test', () {
    String strTest = """
    let globalTest = 123
    let globalTest_other = 123
    """;
    String strGlobalTest = """
    if(globalTest == 123){
      var T = true
    }else{
      var T2 = false
    }
    var existTest = exist("T")
    var existTest2 = exist("T2")
    setVisible("globalTest", true)
    setVisible("globalTest_other", false)
    var visibleTest = isVisible("globalTest")
    var visibleTest_other = isVisible("globalTest_other")
    """;
    Analyser().run(Analyser().analyseMultiLine(strTest));
    ins.clearLocalVariable();
    Analyser().run(Analyser().analyseMultiLine(strGlobalTest));
    expect(ins.getValueType('T')?.dataUnzip, true);
    expect(ins.getValueType('existTest')?.dataUnzip, true);
    expect(ins.getValueType('existTest2')?.dataUnzip, false);

    expect(ins.getValueTypeWrapper('globalTest')?.visible, true);
    expect(ins.getValueTypeWrapper('globalTest_other')?.visible, false);
    expect(ins.getValueType('visibleTest')?.dataUnzip, true);
    expect(ins.getValueType('visibleTest_other')?.dataUnzip, false);
  });
  test('comment test', () {
    String strTest = """
      var commentTest = 123
      //이건 해석하면 안되는 문장. var asb = 0
      var commentTest1 = 0
    """;
    ins.clearLocalVariable();
    Analyser().run(Analyser().analyseMultiLine(strTest));
    expect(ins.getValueType('commentTest')?.dataUnzip, 123);
    expect(ins.getValueType('asb')?.dataUnzip, null);
    expect(ins.getValueType('commentTest1')?.dataUnzip, 0);
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
    Analyser().run(Analyser().analyseMultiLine(strTest));
    expect(ins.getValueType('alpha')?.dataUnzip, 11);
    expect(ins.getValueType('beta')?.dataUnzip, null);
    expect(ins.getValueType('gamma')?.dataUnzip, 12);
  });

  test('simpleTest', (){
    String strTest1 = "true";
    var out = Analyser().run(Analyser().analyseSingleLine(strTest1));
    expect(out, true);
    String strTest2 = "false";
    out = Analyser().run(Analyser().analyseSingleLine(strTest2));
    expect(out, false);
  });
}
