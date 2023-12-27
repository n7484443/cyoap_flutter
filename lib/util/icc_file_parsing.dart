import 'dart:convert';
import 'dart:math';

import 'package:cyoap_core/choiceNode/choice_line.dart';
import 'package:cyoap_core/choiceNode/choice_node.dart';
import 'package:cyoap_core/preset/node_preset.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../model/platform.dart';
import '../viewModel/vm_start.dart';
import 'base64_to_image.dart';

class IccProjectParser {
  String path;

  IccProjectParser(this.path);

  Future<Tuple2<AbstractPlatform, Map<String, Uint8List>>> getPlatform(
      String input, Ref ref) async {
    Map<String, dynamic> parsed = jsonDecode(input);
    Map<String, Uint8List> imageList = {};
    var platform = AbstractPlatform();
    if(parsed['rows'] == null){
      return Tuple2(platform, imageList);
    }
    var rows = parsed['rows'] as List;
    List<ChoiceNodeDesignPreset> nodePresets = [];
    var styles = parsed['styling'];

    int backgroundColor =
        HexColor.fromHex(styles['backgroundColor']).value; //background color
    int objectBackgroundColor =
        HexColor.fromHex(styles['objectBgColor']).value; //object color
    int rowBackgroundColor =
        HexColor.fromHex(styles['rowBgColor']).value; //row color
    int objectSelectBackgroundColor =
        HexColor.fromHex(styles['selFilterBgColor']).value; //select color

    for (int i = 0; i < rows.length; i++) {
      var row = rows[i];
      var rowTitle = row["title"] ?? parsed['defaultRowTitle'];
      var out = await checkImage(row, row["id"], rowTitle, ref);
      var imageName = out?.item1 ?? '';
      if (out != null && out.item2 != null) {
        imageList[imageName] = out.item2!;
      }
      var preset = checkContained(
        nodePresets,
        parseStyle(
          row["styling"],
          template: parseAsInt(row["template"]),
          isRow: true,
          globalSelectFilterBgColor: objectSelectBackgroundColor,
          globalObjectBackgroundColor: objectBackgroundColor,
          globalRowBackgroundColor: rowBackgroundColor,
        ),
      );
      var choiceRow = ChoiceNode(
        width: 0,
        title: rowTitle,
        contents: toContent(row["titleText"] ?? parsed['defaultRowText']),
        imageString: imageName,
      );
      choiceRow.choiceNodeOption =
          choiceRow.choiceNodeOption.copyWith(presetName: preset.name);
      choiceRow.choiceNodeMode = ChoiceNodeMode.unSelectableMode;
      var lineSetting = ChoiceLine(i)..addChildren(choiceRow);
      var rowWidth = int.tryParse((row['objectWidth'] as String? ?? '')
              .replaceAll("md-", "")
              .replaceAll("col-", "")) ??
          0;

      for (var object in row["objects"]) {
        var objectTitle = object["title"] ?? parsed['defaultChoiceTitle'];
        var out = await checkImage(object, object["id"], objectTitle, ref);
        var imageName = out?.item1 ?? '';
        if (out != null && out.item2 != null) {
          imageList[imageName] = out.item2!;
        }
        var preset = checkContained(
          nodePresets,
          parseStyle(
            object["styling"],
            template: parseAsInt(object["template"]),
            isRow: false,
            globalSelectFilterBgColor: objectSelectBackgroundColor,
            globalObjectBackgroundColor: objectBackgroundColor,
            globalRowBackgroundColor: rowBackgroundColor,
          ),
        );
        int width;
        if (object['objectWidth'] == null || object['objectWidth'].isEmpty) {
          width = rowWidth;
        } else {
          var str = object['objectWidth'] as String? ?? '';
          width = int.tryParse(str[str.length - 1]) ?? 0;
        }
        var choiceNode = ChoiceNode(
            width: width,
            title: objectTitle,
            contents: toContent(object["text"] ?? parsed['defaultChoiceText']),
            imageString: imageName);
        choiceNode.choiceNodeOption =
            choiceNode.choiceNodeOption.copyWith(presetName: preset.name);
        for (var addon in object['addons']) {
          var addonTitle = addon["title"] ?? parsed['defaultAddonTitle'];
          var out = await checkImage(addon, addon["id"], addonTitle, ref);
          var imageName = out?.item1 ?? '';
          if (out != null && out.item2 != null) {
            imageList[imageName] = out.item2!;
          }
          var addonNode = ChoiceNode(
              width: 0,
              title: addonTitle,
              contents: toContent(addon["text"] ?? parsed['defaultAddonText']),
              imageString: imageName);
          addonNode.choiceNodeOption =
              addonNode.choiceNodeOption.copyWith(presetName: preset.name);
          choiceNode.addChildren(addonNode);
        }
        lineSetting.addChildren(choiceNode);
      }
      platform.lineSettings.add(lineSetting);
    }
    platform.designSetting = platform.designSetting.copyWith(
      backgroundColorOption: ColorOption(
        color: backgroundColor,
        colorType: ColorType.solid,
      ),
      choiceNodePresetList: nodePresets,
    );

    return Tuple2(platform, imageList);
  }

  int parseAsInt(dynamic input) {
    if (input is int) {
      return input;
    }
    return int.tryParse(input) ?? 0;
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

  ChoiceNodeDesignPreset checkContained(
      List<ChoiceNodeDesignPreset> lists, ChoiceNodeDesignPreset target) {
    var targetJson = target.toJson();
    targetJson.remove("name");
    for (var item in lists) {
      var itemJson = item.toJson();
      itemJson.remove("name");
      if (mapEquals(targetJson, itemJson)) {
        return item;
      }
    }

    lists.add(target);
    return target;
  }

  ChoiceNodeDesignPreset parseStyle(Map<String, dynamic>? styles,
      {required int template,
      required bool isRow,
      required globalObjectBackgroundColor,
      required globalRowBackgroundColor,
      required globalSelectFilterBgColor}) {
    if (styles == null) {
      return ChoiceNodeDesignPreset(
        name: generateRandomString(10),
        imagePosition: template == 4 ? 1 : template,
        defaultColorOption:
            isRow ? globalRowBackgroundColor : globalObjectBackgroundColor,
        defaultOutlineOption: OutlineOption(
          outlineColor: ColorOption(
            color: isRow ? globalRowBackgroundColor : globalSelectFilterBgColor,
            colorType: ColorType.solid,
          ),
        ),
      );
    }
    // var backgroundColor =
    //     HexColor.fromHex(styles['backgroundColor']).value; //selected color
    var objectBackgroundColor =
        HexColor.fromHex(styles['objectBgColor']).value; //required color
    var rowBackgroundColor =
        HexColor.fromHex(styles['rowBgColor']).value; //required color
    var objectSelectBackgroundColor =
        HexColor.fromHex(styles['selFilterBgColor']).value; //required color
    if (isRow) {
      return ChoiceNodeDesignPreset(
        name: generateRandomString(10),
        imagePosition: template == 4 ? 1 : template,
        defaultColorOption: rowBackgroundColor == 0xFFFFFFFF
            ? globalRowBackgroundColor
            : rowBackgroundColor,
        defaultOutlineOption: OutlineOption(
          outlineColor: ColorOption(
            color: rowBackgroundColor == 0xFFFFFFFF
                ? globalRowBackgroundColor
                : rowBackgroundColor,
            colorType: ColorType.solid,
          ),
        ),
      );
    }
    return ChoiceNodeDesignPreset(
      name: generateRandomString(10),
      imagePosition: template == 4 ? 1 : template,
      defaultColorOption: objectBackgroundColor == 0xFFFFFFFF
          ? globalObjectBackgroundColor
          : objectBackgroundColor,
      defaultOutlineOption: OutlineOption(
        outlineColor: ColorOption(
          color: objectSelectBackgroundColor == 0xFFFFFFFF
              ? globalSelectFilterBgColor
              : objectSelectBackgroundColor,
          colorType: ColorType.solid,
        ),
      ),
    );
  }
}

String generateRandomString(int len) {
  var r = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "aabbccff" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 7) {
      buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
    } else {
      buffer.write(hexString.substring(7, 9));
      buffer.write(hexString.substring(1, 7));
    }
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
