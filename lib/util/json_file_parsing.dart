import 'dart:convert';
import 'dart:io';

import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

import '../main.dart';
import '../model/platform.dart';
import 'base64_to_image.dart';

class JsonProjectParser {
  String path;
  JsonProjectParser(this.path);
  Future<AbstractPlatform> getPlatform(String input) async {
    Map<String, dynamic> parsed = jsonDecode(input);
    Map<String, Uint8List> outputImage = {};

    var row = parsed['rows'] as List;
    for (var choice in row) {
      var out = await compute(checkImage, choice as Map<String, dynamic>);
      if (out == null) continue;
      outputImage[out.item1] = out.item2;
    }
    var parent = File(path).path;
    for (var data in outputImage.keys) {
      File f = File("$parent/images/$data");
      await f.create(recursive: true);
      await f.writeAsBytes(outputImage[data]!);
    }

    return AbstractPlatform('', ConstList.version);
  }

  Future<Tuple2<String, Uint8List>?> checkImage(
      Map<String, dynamic> input) async {
    if (input.containsKey('image')) {
      if (input['image'] == null || (input['image'] as String).isEmpty) {
        return null;
      }
      return await Base64ToImage.convertToImage(input['image'], input['id']);
    }
    return null;
  }

  Future<ChoiceNode?> parseToChoiceNode(Map<String, dynamic> input) async {
    return null;
  }
}
