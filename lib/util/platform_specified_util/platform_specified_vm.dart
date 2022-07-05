import 'package:cyoap_flutter/util/platform_specified_util/check_distribute_vm.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:cyoap_flutter/util/platform_specified_util/save_project_vm.dart';

class PlatformSpecifiedImp implements PlatformSpecified {
  @override
  void init() {
    PlatformSpecified().distribute = DistributeImp();
    PlatformSpecified().saveProject = SaveProjectImp();
  }

  @override
  Distribute? distribute;

  @override
  SaveProject? saveProject;

  @override
  void preInit() {}
}
