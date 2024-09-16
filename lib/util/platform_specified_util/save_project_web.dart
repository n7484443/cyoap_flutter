import 'dart:convert';
import 'dart:typed_data';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:js/js.dart';

class SaveProjectImp extends SaveProject {
  @override
  Future<void> saveZip(String? path, Map<String, Uint8List> dataInput) async {
    await JsIsolatedWorker().importScripts(['save_web.js', 'jszip.js']);
    Uint8List output = await JsIsolatedWorker()
        .run(functionName: '_compressToZip', arguments: jsonEncode(dataInput));
    downloadCapture("", path!, output);
  }

  @override
  Future<void> downloadCapture(String path, String name, Uint8List data) async {
    _exportRaw(name, data);
  }
}

@JS()
external void _exportRaw(String name, Uint8List data);
