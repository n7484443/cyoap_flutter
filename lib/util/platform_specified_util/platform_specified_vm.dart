import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:cyoap_flutter/util/platform_specified_util/check_distribute_vm.dart';
import 'package:cyoap_flutter/util/platform_specified_util/save_project_vm.dart';

class PlatformSpecifiedImp extends PlatformSpecified{
  @override
  void init(){
    PlatformSpecified.instance.distribute = DistributeImp();
    PlatformSpecified.instance.saveProject = SaveProjectImp();
  }
}