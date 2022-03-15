import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import '../tuple.dart';
import 'check_distribute.dart';

class DistributeImp extends Distribute {
  @override
  Future<bool> isDistribute() async{
    var data = await _readFile('check_distributed.json');
    var decoded = jsonDecode(String.fromCharCodes(data));
    return decoded['is_distribute'];
  }

  @override
  Future<Tuple<List<String>, List<String>>> getImageNodeList() async {
    var imageListData = await _readFile('dist/images/list.json');
    var nodeListData = await _readFile('dist/nodes/list.json');
    var imageList =
    (jsonDecode(String.fromCharCodes(imageListData)) as List).map((e) => e.toString()).toList();
    var nodeList =
    (jsonDecode(String.fromCharCodes(nodeListData)) as List).map((e) => e.toString()).toList();

    return Tuple(imageList, nodeList);
  }

  @override
  Future<Uint8List?> getFile(String f) async {
    return await _readFile('dist/$f');
  }

  Future<Uint8List> _readFile(String path) async{
    var request = await HttpRequest.request(path, responseType: 'arraybuffer');
    var response = request.response as ByteBuffer;
    return response.asUint8List();
  }
}