import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:cyoap_flutter/util/platform_specified_util/save_project_web.dart';
import 'package:url_strategy/url_strategy.dart';

class PlatformSpecifiedImp implements PlatformSpecified {
  @override
  void init() {
    PlatformSpecified().saveProject = SaveProjectImp();
  }

  @override
  void preInit() {
    setPathUrlStrategy();
  }

  @override
  SaveProject? saveProject;
}
