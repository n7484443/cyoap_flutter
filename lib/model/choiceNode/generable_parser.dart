abstract class GenerableParserAndPosition {
  void generateParser();
  void initValueTypeWrapper();
  Map<String, dynamic> toJson();
  int get currentPos;
  GenerableParserAndPosition? parent;
}
