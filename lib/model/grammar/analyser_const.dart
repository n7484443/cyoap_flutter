class AnalyserConst {
  /// 정수
  static const int ints = 1;
  /// 소수점 붙음
  static const int doubles = 2;
  /// boolean
  static const int bools = 3;
  /// string, "" 혹은 ''로 판단
  static const int strings = 4;
  /// 판단 X
  static const int unspecified = 5;

  /// 변수 사용
  static const int variableName = 10;
  /// 전역 변수 설정, let
  static const int variableLet = 15;
  /// 지역 변수 설정, var
  static const int variableVar = 16;

  static const int functionUnspecified = 20;
  static const int function = 21;
  /// (
  static const int functionStart = 30;
  /// )
  static const int functionEnd = 31;
  /// ,
  static const int functionComma = 40;
}
