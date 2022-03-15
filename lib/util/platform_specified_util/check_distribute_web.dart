import 'dart:html';
import 'dart:typed_data';

import 'package:js/js.dart';
import 'check_distribute.dart';

class DistributeImp extends Distribute{
  @override
  bool isDistribute(){
    return _isDistributed();
  }

  @override
  Future<Uint8List?> getFileDistributed() async {
    var output = await _readFile('dist/dist.png');

    //역전통 파일임.
    return output;
  }
}

Future<Uint8List> _readFile(String path) async{
  var request = await HttpRequest.request(path, responseType: 'arraybuffer', mimeType: 'application/zip');
  var response = request.response as ByteBuffer;
  return response.asUint8List();
}

@JS()
external bool _isDistributed();