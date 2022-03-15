import 'dart:typed_data';

import 'check_distribute_vm.dart'
if(dart.library.html) 'check_distribute_web.dart';

abstract class Distribute{
  bool isDistribute() => false;
  Future<Uint8List?> getFileDistributed();
}

DistributeImp getDistribute() => DistributeImp();