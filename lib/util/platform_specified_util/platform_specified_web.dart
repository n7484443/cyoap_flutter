import 'dart:html';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:cyoap_flutter/util/platform_specified_util/check_distribute_web.dart';
import 'package:cyoap_flutter/util/platform_specified_util/save_project_web.dart';
import 'package:qlevar_router/qlevar_router.dart';

class PlatformSpecifiedImp extends PlatformSpecified{
  @override
  void init(){
    distribute = DistributeImp();
    saveProject = SaveProjectImp();
  }
  @override
  void preInit(){
    QR.setUrlStrategy();
  }
  @override
  void reload(){
    window.location.reload();
  }
}