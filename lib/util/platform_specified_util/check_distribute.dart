import 'dart:typed_data';

import '../tuple.dart';
import 'check_distribute_vm.dart'
    if (dart.library.html) 'check_distribute_web.dart';

abstract class Distribute {
  Future<Tuple<List<String>, List<String>>> getImageNodeList() async {
    throw UnimplementedError();
  }

  Future<Uint8List> getFile(String f) async {
    throw UnimplementedError();
  }
  Future<String> getFileWithJson(String f) async {
    throw UnimplementedError();
  }
}

DistributeImp getDistribute() => DistributeImp();
