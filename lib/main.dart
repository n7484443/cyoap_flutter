import 'dart:io';

import 'package:cyoap_flutter/view/view_code_editor.dart';
import 'package:cyoap_flutter/view/view_editor.dart';
import 'package:cyoap_flutter/view/view_global_settings.dart';
import 'package:cyoap_flutter/view/view_make.dart';
import 'package:cyoap_flutter/view/view_play.dart';
import 'package:cyoap_flutter/view/view_source.dart';
import 'package:cyoap_flutter/view/view_start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';

//flutter build web --base-href=/FlutterCyoapWeb/

class ConstList{
  static const double appBarSize = 40.0;
  static const double elevation = 6.0;
  static late final PlatformType actualPlatformType;

  static bool isOnlyFileAccept() {
    return actualPlatformType == PlatformType.web;
  }

  static bool isMobile() {
    return actualPlatformType == PlatformType.mobile;
  }

  static bool isSmallDisplay(BuildContext context) {
    if (isMobile()) return true;
    if (MediaQuery.of(context).size.width < 1000) return true;
    return false;
  }

  static String? version;

  static Future<void> init() async {
    try {
      if (Platform.isAndroid) {
        ConstList.actualPlatformType = PlatformType.mobile;
      } else if (Platform.isWindows) {
        ConstList.actualPlatformType = PlatformType.desktop;
      } else {
        ConstList.actualPlatformType = PlatformType.web;
      }
    } catch (e) {
      ConstList.actualPlatformType = PlatformType.web;
    }

    var packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  static DefaultStyles getDefaultThemeData(BuildContext context, double scale,
      {TextStyle? fontStyle}) {
    var defaultTextStyle = fontStyle ?? DefaultTextStyle.of(context).style;
    var baseStyle = defaultTextStyle.copyWith(
      fontSize: 16 * scale,
      height: 1.3 * scale,
    );
    var baseStyle2 = defaultTextStyle.copyWith(
      fontSize: 16 * scale * 0.75,
      height: 1.3 * scale,
    );
    return DefaultStyles(
      paragraph: DefaultTextBlockStyle(
          baseStyle, const Tuple2(0, 0), const Tuple2(0, 0), null),
      small: baseStyle2,
    );
  }

  static TextStyle defaultFont = GoogleFonts.notoSans(color: Colors.black);
  static Map<String, TextStyle> textFontMap = {
    "jua": GoogleFonts.jua(color: Colors.black),
    "notoSans": GoogleFonts.notoSans(color: Colors.black),
    "나눔고딕": GoogleFonts.nanumGothic(color:Colors.black),
  };

  static TextStyle getFont(String font) {
    return textFontMap[font] ?? defaultFont;
  }
}
enum PlatformType{
  desktop, mobile, web,
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    GetMaterialApp(
      title: 'CYOAP',
      home: const ViewStart(),
      getPages: [
        GetPage(name: '/viewMake', page: () => const ViewMake()),
        GetPage(name: '/viewPlay', page: () => const ViewPlay()),
        GetPage(name: '/viewStart', page: () => const ViewStart()),
        GetPage(name: '/viewEditor', page: () => const ViewEditor()),
        GetPage(name: '/viewCodeEditor', page: () => const ViewCodeEditor()),
        GetPage(
            name: '/viewGlobalSetting', page: () => const ViewGlobalSetting()),
        GetPage(
            name: '/viewSource', page: () => const ViewSource()),
      ],
      theme: appThemeData,
      defaultTransition: Transition.fade,
    ),
  );
  ConstList.init();
}

final ThemeData appThemeData = ThemeData(
  primaryColor: Colors.black,
  textTheme: GoogleFonts.notoSansTextTheme(),
  scaffoldBackgroundColor: Colors.white,
  iconTheme: const IconThemeData(
      color: Colors.black
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
        color: Colors.black
    ),
    color: Colors.white,
    elevation: ConstList.elevation,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    elevation: 1,
  ),
  useMaterial3: true,
);
