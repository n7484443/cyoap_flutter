import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

class DistributeImp extends Distribute {
  @override
  Future<Tuple2<List<String>, List<String>>> getImageNodeList() async {
    var imageListData = await getFileAsJson('images/list.json');
    var nodeListData = await getFileAsJson('nodes/list.json');
    var imageList =
        (jsonDecode(imageListData) as List).map((e) => e.toString()).toList();
    var nodeList =
        (jsonDecode(nodeListData) as List).map((e) => e.toString()).toList();

    return Tuple2(imageList, nodeList);
  }

  @override
  Future<Uint8List> getFileAsUint8(String f) async {
    var src = '/dist/$f';
    http.Response response = await http.get(Uri.parse(src));
    return response.bodyBytes;
  }

  @override
  Future<String> getFileAsJson(String f) async {
    return utf8.decode(await getFileAsUint8(f));
  }
}
