import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';
import 'package:cyoap_flutter/util/tuple.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../model/abstract_platform.dart';
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
      outputImage[out.data1] = out.data2;
    }
    var parent = File(path).path;
    for (var data in outputImage.keys) {
      File f = File("$parent/images/$data");
      await f.create(recursive: true);
      await f.writeAsBytes(outputImage[data]!);
    }

    return AbstractPlatform('', Colors.white, 0, ConstList.version ?? '');
  }

  Future<Tuple<String, Uint8List>?> checkImage(
      Map<String, dynamic> input) async {
    if (input.containsKey('image')) {
      if (input['image'] == null || (input['image'] as String).isEmpty)
        return null;
      return await Base64ToImage.convertToImage(input['image'], input['id']);
    }
    return null;
  }

  Future<ChoiceNodeBase?> parseToChoiceNode(Map<String, dynamic> input) async {
    return null;
  }
}
