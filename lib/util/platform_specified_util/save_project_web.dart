import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:js/js.dart';

class SaveProjectImp extends SaveProject {
  @override
  Future<void> saveZip(String name, Map<String, dynamic> dataInput) async {
    var map = await getMap(dataInput);

    await JsIsolatedWorker().importScripts(['save_web.js', 'jszip.js']);
    Uint8List output = await JsIsolatedWorker()
        .run(functionName: '_compressToZip', arguments: jsonEncode(map));
    downloadCapture(name, output);
  }

  @override
  Future<void> downloadCapture(String name, Uint8List data) async {
    _exportRaw(name, data);
  }
}

@JS()
external void _exportRaw(String name, Uint8List data);
