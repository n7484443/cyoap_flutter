import 'dart:convert';
import 'dart:typed_data';

import 'package:isolated_worker/js_isolated_worker.dart';

import '../tuple.dart';
import 'check_distribute.dart';

class DistributeImp extends Distribute {
  @override
  Future<bool> isDistribute() async {
    var data = await _readFileAsUint8('check_distributed.json');
    var decoded = jsonDecode(String.fromCharCodes(data));
    return decoded['is_distribute'];
  }

  @override
  Future<Tuple<List<String>, List<String>>> getImageNodeList() async {
    var imageListData = await getFile('images/list.json');
    var nodeListData = await getFile('nodes/list.json');
    var imageList = (jsonDecode(String.fromCharCodes(imageListData!)) as List)
        .map((e) => e.toString())
        .toList();
    var nodeList = (jsonDecode(String.fromCharCodes(nodeListData!)) as List)
        .map((e) => e.toString())
        .toList();

    return Tuple(imageList, nodeList);
  }

  @override
  Future<Uint8List?> getFile(String f) async {
    return await _readFileAsUint8('dist/$f');
  }

  Future<Uint8List> _readFileAsUint8(String path) async {
    await JsIsolatedWorker().importScripts(['request_multiple.js']);
    if (path.endsWith(".json")) {
      var output = await JsIsolatedWorker()
          .run(functionName: '_readFileFromAjaxWithJson', arguments: path);
      return Uint8List.fromList(utf8.encode(output as String));
    } else {
      var output = await JsIsolatedWorker()
          .run(functionName: '_readFileFromAjax', arguments: path);
      return (output as ByteBuffer).asUint8List();
    }
  }
}
