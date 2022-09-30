import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../model/platform.dart';
import '../viewModel/vm_start.dart';
import 'base64_to_image.dart';

class JsonProjectParser {
  String path;

  JsonProjectParser(this.path);

  Future<Tuple2<AbstractPlatform, Map<String, Uint8List>>> getPlatform(
      String input, Ref ref) async {
    Map<String, dynamic> parsed = jsonDecode(input);
    Map<String, Uint8List> imageList = {};
    var rows = parsed['rows'] as List;
    var platform = AbstractPlatform();
    for (int i = 0; i < rows.length; i++) {
      var row = rows[i];
      var rowTitle = row["title"] ?? parsed['defaultRowTitle'];
      var out = await checkImage(row, row["id"], rowTitle, ref);
      var imageName = out?.item1 ?? '';
      if (out != null && out.item2 != null) {
        imageList[imageName] = out.item2!;
      }
      var lineSetting = LineSetting(i);
      lineSetting.addChildren(ChoiceNode(0, rowTitle,
          toContent(row["titleText"] ?? parsed['defaultRowText']), imageName));
      var objectWidth = row['objectWidth'] as String? ?? '';
      var width = int.tryParse(
              objectWidth.replaceAll("md-", "").replaceAll("col-", "")) ??
          0;
      for (var object in row["objects"]) {
        var objectTitle = object["title"] ?? parsed['defaultChoiceTitle'];
        var out = await checkImage(object, object["id"], objectTitle, ref);
        var imageName = out?.item1 ?? '';
        if (out != null && out.item2 != null) {
          imageList[imageName] = out.item2!;
        }
        var choiceNode = ChoiceNode(0, objectTitle,
            toContent(object["text"] ?? parsed['defaultChoiceText']), imageName)
          ..width = width;
        for (var addon in object['addons']) {
          var addonTitle = addon["title"] ?? parsed['defaultAddonTitle'];
          var out = await checkImage(addon, addon["id"], addonTitle, ref);
          var imageName = out?.item1 ?? '';
          if (out != null && out.item2 != null) {
            imageList[imageName] = out.item2!;
          }
          choiceNode.addChildren(ChoiceNode(
              0,
              addonTitle,
              toContent(addon["text"] ?? parsed['defaultAddonText']),
              imageName));
        }
        lineSetting.addChildren(choiceNode);
      }
      platform.lineSettings.add(lineSetting);
    }

    return Tuple2(platform, imageList);
  }

  Future<Tuple2<String, Uint8List?>?> checkImage(
      dynamic input, String? first, String second, Ref ref) async {
    var image = input['image'] as String?;
    if (image == null || image.isEmpty) {
      return null;
    }
    var out = await compute(Base64ToImage.convertToImage, image);
    String name;
    if (out == null) {
      name = image;
    } else {
      String sub = (first == null || first.isEmpty) ? second : first;
      if (sub.isEmpty) {
        sub = Random().nextInt(999999).toString();
      }
      name = "$sub.${out.item1}";
    }
    ref.read(loadProjectStateProvider.notifier).state = "이미지 파일 로딩중 : $name";
    return Tuple2(name, out?.item2);
  }

  Future<ChoiceNode?> parseToChoiceNode(Map<String, dynamic> input) async {
    return null;
  }

  String toContent(String input) {
    return jsonEncode([
      {'insert': '$input\n'}
    ]);
  }
}
