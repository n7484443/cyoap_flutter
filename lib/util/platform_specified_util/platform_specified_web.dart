import 'dart:html';

import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:cyoap_flutter/util/platform_specified_util/check_distribute_web.dart';
import 'package:cyoap_flutter/util/platform_specified_util/save_project_web.dart';
import 'package:url_strategy/url_strategy.dart';

class PlatformSpecifiedImp extends PlatformSpecified{
  @override
  void init(){
    if(ConstList.isDistributed){
      PlatformSpecified.instance.distribute = DistributeImp();
      PlatformSpecified.instance.saveProject = null;
    }else{
      PlatformSpecified.instance.distribute = null;
      PlatformSpecified.instance.saveProject = SaveProjectImp();
    }
  }
  @override
  void preInit(){
    setPathUrlStrategy();
  }
  @override
  void reload(){
    window.location.reload();
  }
}