import 'package:cyoap_flutter/model/choiceNode/recursive_status.dart';

abstract class GenerableParserAndPosition {
  void generateParser();
  void initValueTypeWrapper();
  Map<String, dynamic> toJson();

  int get currentPos;
  GenerableParserAndPosition? parent;
  RecursiveStatus? recursiveStatus;
}
