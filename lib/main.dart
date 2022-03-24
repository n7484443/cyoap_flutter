import 'dart:io';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart';
import 'package:cyoap_flutter/view/view_make_platform.dart' deferred as v_make;
import 'package:cyoap_flutter/view/view_play.dart' deferred as v_play;
import 'package:cyoap_flutter/view/view_start.dart' deferred as v_start;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';

//flutter build web --base-href=/FlutterCyoapWeb/

class ConstList {
  static const bool isDistributed = bool.fromEnvironment("isDistributed", defaultValue: false);
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

  static String? versionInner;

  static String get version => versionInner ?? '';

  static Future<void> init() async {
    PlatformSpecified.instance.init();
    var packageInfo = await PackageInfo.fromPlatform();
    versionInner = packageInfo.version;
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
    "나눔고딕": GoogleFonts.nanumGothic(color: Colors.black),
    "나눔손글씨 붓": GoogleFonts.nanumBrushScript(color: Colors.black),
    "나눔손글씨 펜": GoogleFonts.nanumPenScript(color: Colors.black),
    "이순신체": const TextStyle(fontFamily: 'YiSunShin', color: Colors.black),
    "메이플스토리체": const TextStyle(fontFamily: 'MapleStory', color: Colors.black),
    "넥슨 Lv2 고딕":
        const TextStyle(fontFamily: 'NexonLv2Gothic', color: Colors.black),
    "Neo 둥근모": const TextStyle(fontFamily: 'NeoDGM', color: Colors.black),
  };

  static TextStyle getFont(String font) {
    return textFontMap[font] ?? defaultFont;
  }

  static Future<void> preInit() async {
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
    PlatformSpecified.instance.preInit();
    return;
  }
}

enum PlatformType {
  desktop,
  mobile,
  web,
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ConstList.preInit().then((value) async {
    await v_play.loadLibrary();
    if(ConstList.isDistributed){
      await v_start.loadLibrary();
      await v_make.loadLibrary();
    }
    runApp(
      GetMaterialApp(
        title: 'CYOAP',
        initialRoute: '/',
        getPages: List.generate(ConstList.isDistributed ? 1 : 3, (index)  {
          if(ConstList.isDistributed){
            return GetPage(
              name: '/',
              page: () => v_play.ViewPlay(),
            );
          }else{
            switch (index) {
              case 0:
                return GetPage(
                  name: '/',
                  page: () => v_start.ViewStart(),
                );
              case 1:
                return GetPage(
                  name: '/viewPlay',
                  page: () => v_play.ViewPlay(),
                );
              default:
                return GetPage(
                  name: '/viewMake',
                  page: () => v_make.ViewMakePlatform(),
                );
            }
          }
        }),
        theme: appThemeData,
        defaultTransition: Transition.fade,
      ),
    );
  }).then((value) => ConstList.init());
}

final ThemeData appThemeData = ThemeData(
  primaryColor: Colors.black,
  textTheme: GoogleFonts.notoSansTextTheme(),
  scaffoldBackgroundColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.black),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(color: Colors.black),
    color: Colors.white,
    elevation: ConstList.elevation,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.white,
    elevation: ConstList.elevation,
  ),
  useMaterial3: true,
);
