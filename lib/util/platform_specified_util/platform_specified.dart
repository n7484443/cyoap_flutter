import 'dart:typed_data';

import 'platform_specified_vm.dart'
    if (dart.library.html) 'platform_specified_web.dart';

abstract class PlatformSpecified {
  static final PlatformSpecified _instance = PlatformSpecifiedImp();
  factory PlatformSpecified() {
    return _instance;
  }
  late final SaveProject? saveProject;
  void init() {}
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

  Future<void> saveZip(String name, Map<String, Uint8List> dataInput) async {
    throw UnimplementedError();
  }

  Future<void> saveRaw(String path, Map<String, Uint8List> dataInput) async {}
}
