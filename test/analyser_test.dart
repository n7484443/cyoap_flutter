import 'dart:convert';

import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:cyoap_flutter/model/grammar/analyser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var ins = VariableDataBase.getInstance();
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
                
                stringTest = "문자열테스트String1"
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
                """;
  var recursiveData = Analyser.analyseCodes(strTest);
  for(var recursive in recursiveData){
    recursive.unzip();
  }

  var epsilon = 0.00001;
  test('numberTest', (){
    expect(ins.getValue('numberTest0')?.data, closeTo(-5.5, epsilon));
    expect(ins.getValue('numberTest1')?.data, 3);
    expect(ins.getValue('numberTest2')?.data, 8);
    expect(ins.getValue('numberTest3')?.data, closeTo(0.5, epsilon));
    expect(ins.getValue('numberTest4')?.data, 18);
    expect(ins.getValue('numberTest5')?.data, 2);
  });

  test('boolTest', (){
    expect(ins.getValue('boolTest1')?.data, true);
    expect(ins.getValue('boolTest2')?.data, false);
  });

  test('funcTest', (){
    expect(ins.getValue('roundTest')?.data, 5);
    expect(ins.getValue('ceilTest')?.data, 5);
    expect(ins.getValue('floorTest')?.data, 4);
  });

  test('stringTest', (){
    expect(ins.getValue('stringTest')?.data, "문자열테스트String1");
    expect(ins.getValue('stringAddTest')?.data, "문자열테스트1");
  });

  test('compTest', (){
    expect(ins.getValue('comp1')?.data, true);
    expect(ins.getValue('comp2')?.data, true);
    expect(ins.getValue('comp3')?.data, false);
  });

  test('ifTest', (){
    expect(ins.getValue('alpha')?.data, 11);
    expect(ins.getValue('beta')?.data, null);
    expect(ins.getValue('gamma')?.data, null);
    expect(ins.getValue('omega')?.data, 16);
  });
  test('addTest', (){
    expect(ins.getValue('test_alpha')?.data, 4);
    expect(ins.getValue('test_beta')?.data, -4);
  });
}