import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/util/platform_specified_util/check_distribute_web.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:cyoap_flutter/util/platform_specified_util/save_project_web.dart';
import 'package:url_strategy/url_strategy.dart';

class PlatformSpecifiedImp implements PlatformSpecified {
  @override
  void init() {
    if (ConstList.isDistributed) {
      PlatformSpecified().distribute = DistributeImp();
      PlatformSpecified().saveProject = null;
    } else {
      PlatformSpecified().distribute = null;
      PlatformSpecified().saveProject = SaveProjectImp();
    }
  }

  @override
  void preInit() {
    setPathUrlStrategy();
  }

  @override
  Distribute? distribute;

  @override
  SaveProject? saveProject;
}
