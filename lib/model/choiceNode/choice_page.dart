import 'generable_parser.dart';
import 'line_setting.dart';

// TODO: page 시스템 구현
class ChoicePage extends GenerableParser{
  int page;
  List<LineSetting> lineSettings = List.empty(growable: true);
  ChoicePage(this.page);

  @override
  void generateParser() {
    // TODO: implement generateParser
  }

  @override
  void initValueTypeWrapper() {
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

}