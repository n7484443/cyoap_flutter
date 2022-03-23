import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:isolated_worker/js_isolated_worker.dart';

import '../tuple.dart';

class DistributeImp extends Distribute {
  @override
  Future<Tuple<List<String>, List<String>>> getImageNodeList() async {
    var imageListData = await getFileWithJson('images/list.json');
    var nodeListData = await getFileWithJson('nodes/list.json');
    var imageList =
        (jsonDecode(imageListData) as List).map((e) => e.toString()).toList();
    var nodeList =
        (jsonDecode(nodeListData) as List).map((e) => e.toString()).toList();

    return Tuple(imageList, nodeList);
  }

  @override
  Future<Uint8List> getFile(String f) async {
    return await _readFileAsUint8('/dist/$f');
  }

  @override
  Future<String> getFileWithJson(String f) async {
    return await _readFileAsString('/dist/$f');
  }

  Future<Uint8List> _readFileAsUint8(String path) async {
    await JsIsolatedWorker().importScripts(['request_multiple.js']);
    var output = await JsIsolatedWorker()
        .run(functionName: '_readFileFromAjax', arguments: path);
    return (output as ByteBuffer).asUint8List();
  }

  Future<String> _readFileAsString(String path) async {
    await JsIsolatedWorker().importScripts(['request_multiple.js']);
    String output = await JsIsolatedWorker()
        .run(functionName: '_readFileFromAjaxWithJson', arguments: path);
    return output;
  }
}
