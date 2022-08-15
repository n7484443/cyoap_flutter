import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pos.freezed.dart';
part 'pos.g.dart';

@freezed
class Pos with _$Pos {
  factory Pos({@Default([]) List<int> data}) = _Pos;

  factory Pos.fromJson(Map<String, dynamic> json) => _$PosFromJson(json);

  Pos._();

  bool get isValid => data.every((element) => element >= 0);

  get first => data.first;

  get last => data.last;

  get length => data.length;

  Pos addLast(int last) {
    return Pos(data: [...data, last]);
  }

  Pos removeLast() {
    return Pos(data: [...data]..removeLast());
  }

  bool equalExceptLast(Pos other) {
    if (data.length != other.data.length) return false;
    for (int i = 0; i < data.length - 1; i++) {
      if (data[i] != other.data[i]) return false;
    }
    return true;
  }

  bool contain(Pos other) {
    for (int i = 0; i < min(length, other.length); i++) {
      if (data[i] != other.data[i]) return false;
    }
    return true;
  }
}
