import 'generable_parser.dart';
import 'choice_line.dart';

// TODO: page 시스템 구현
class ChoicePage extends GenerableParserAndPosition{
  int _page;
  List<LineSetting> lineSettings = List.empty(growable: true);
  ChoicePage(this._page);

  @override
  void generateParser() {
  }

  @override
  void initValueTypeWrapper() {
  }

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  int get currentPos => _page;
  @override
  set currentPos(int pos) => _page = pos;

}