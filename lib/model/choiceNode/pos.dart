import 'package:freezed_annotation/freezed_annotation.dart';

part 'pos.g.dart';
part 'pos.freezed.dart';

@freezed
class Pos with _$Pos {
  factory Pos({@Default([]) List<int> data}) = _Pos;

  factory Pos.fromJson(Map<String, dynamic> json) => _$PosFromJson(json);

  Pos._();

  bool get isValid => data.every((element) => element >= 0);

  Pos addLast(int last){
    return Pos(data: [...data, last]);
  }
}
