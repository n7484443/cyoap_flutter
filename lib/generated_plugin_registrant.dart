//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: depend_on_referenced_packages

import 'package:device_info_plus/src/device_info_plus_web.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:package_info_plus/src/package_info_plus_web.dart';
import 'package:sentry_flutter/sentry_flutter_web.dart';
import 'package:shared_preferences_web/shared_preferences_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  DeviceInfoPlusWebPlugin.registerWith(registrar);
  FilePickerWeb.registerWith(registrar);
  PackageInfoPlusWebPlugin.registerWith(registrar);
  SentryFlutterWeb.registerWith(registrar);
  SharedPreferencesPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
