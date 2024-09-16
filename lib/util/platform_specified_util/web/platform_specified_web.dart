import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:url_strategy/url_strategy.dart';

class PlatformSpecifiedImp extends PlatformSpecified {
  PlatformSpecifiedImp();

  @override
  void init() {
    super.init();
  }

  @override
  void preInit() {
    super.preInit();
    setPathUrlStrategy();
  }
}
