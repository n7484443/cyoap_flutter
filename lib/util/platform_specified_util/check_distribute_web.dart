import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:http/http.dart' as http;

class DistributeImp extends Distribute {
  @override
  Future<List<String>> getNodeList() async {
    var nodeListData = await getFileAsJson('nodes/list.json');
    var nodeList =
        (jsonDecode(nodeListData) as List).map((e) => e.toString()).toList();

    return nodeList;
  }

  @override
  Future<Uint8List> getFileAsUint8(String f) async {
    var src = '${Uri.base.origin}/dist/$f';
    http.Response response = await http.get(Uri.parse(src));
    return response.bodyBytes;
  }

  @override
  Future<String> getFileAsJson(String f) async {
    return utf8.decode(await getFileAsUint8(f));
  }
}
