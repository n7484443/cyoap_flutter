class AnalyserConst {
  /// 정수
  static const int ints = 1;
  /// 소수점 붙음
  static const int doubles = 2;
  /// boolean
  static const int bools = 3;
  /// string, "" 혹은 ''로 판단
  static const int strings = 4;

  /// = 기호
  static const int equal = 0;

  /// 변수명
  static const int variableName = 10;

  static const int functionUnspecified = 20;
  static const int function = 21;
  /// (
  static const int functionStart = 30;
  /// )
  static const int functionEnd = 31;
  /// ,
  static const int functionComma = 40;
}
