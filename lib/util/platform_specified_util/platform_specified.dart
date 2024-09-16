import 'dart:typed_data';

import 'vm/export_list.dart' if (dart.library.html) 'web/export_list.dart';

class PlatformUtil{
  static final PlatformUtil _instance = PlatformUtil._internal();
  final PlatformSpecified platform = PlatformSpecifiedImp();

  factory PlatformUtil() {
    return _instance;
  }

  PlatformUtil._internal();
}

abstract class PlatformSpecified {
  SaveProject saveProject = SaveProjectImp();
  WebpConverter webpConverter = WebpConverterImp();

  void init() {
    webpConverter.init();
  }

  void preInit() {}
}

abstract class Distribute {
  Future<List<String>> getNodeList() async {
    throw UnimplementedError();
  }

  Future<Uint8List> getFileAsUint8(String f) async {
    throw UnimplementedError();
  }

  Future<String> getFileAsJson(String f) async {
    throw UnimplementedError();
  }
}

abstract class SaveProject {
  Future<void> downloadCapture(String path, String name, Uint8List data) async {
    throw UnimplementedError();
  }

  Future<void> saveZip(String? path, Map<String, Uint8List> dataInput) async {
    throw UnimplementedError();
  }

  Future<void> saveRaw(String path, Map<String, Uint8List> dataInput) async {}

  Future<void> saveBackup(String path, Map<String, Uint8List> dataInput) async {
    throw UnimplementedError();
  }
}

abstract class WebpConverter {
  Future<(String, Uint8List)> convert(Uint8List input, String name) async =>
      throw "doesn't work in this platform";

  void init() async {}
  bool saveAsWebp = false;
  bool get canConvert => false;
}