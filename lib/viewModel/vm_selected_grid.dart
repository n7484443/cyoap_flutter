import 'package:cyoap_core/choiceNode/pos.dart';
import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedChoiceNodeProvider = Provider.autoDispose<List<Pos>>((ref) {
  return getPlatform.selectedPos;
});
