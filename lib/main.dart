import 'dart:io';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart'
    deferred as platform_specified;
import 'package:cyoap_flutter/view/view_make_platform.dart' deferred as v_make;
import 'package:cyoap_flutter/view/view_play.dart' deferred as v_play;
import 'package:cyoap_flutter/view/view_start.dart' deferred as v_start;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';

class ConstList {
  static const bool isDistributed =
      bool.fromEnvironment("isDistributed", defaultValue: false);
  static const double appBarSize = 40.0;
  static const double elevation = 6.0;
  static late final PlatformType actualPlatformType;

  static bool isOnlyFileAccept() {
    return isDistributed || actualPlatformType == PlatformType.web;
  }

  static bool isMobile() {
    return actualPlatformType == PlatformType.mobile;
  }

  static bool isDesktop() {
    return actualPlatformType == PlatformType.desktop;
  }

  static bool isSmallDisplay(BuildContext context) {
    if (isMobile()) return true;
    if (MediaQuery.of(context).size.width < 1000) return true;
    return false;
  }

  static String? _version;

  static String get version => _version ?? '';

  static Future<void> init() async {
    platform_specified.PlatformSpecified().init();
    var packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
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

  static List<String> textFontList = [
    "jua",
    "notoSans",
    "나눔고딕",
    "나눔손글씨 붓",
    "나눔손글씨 펜",
    "메이플스토리체",
    "넥슨 Lv2 고딕",
    "Neo 둥근모",
  ];

  static TextStyle getFont(String font) {
    switch (font) {
      case 'jua':
        return GoogleFonts.jua(color: Colors.black);
      case 'notoSans':
        return GoogleFonts.notoSans(color: Colors.black);
      case '나눔고딕':
        return GoogleFonts.nanumGothic(color: Colors.black);
      case '나눔손글씨 붓':
        return GoogleFonts.nanumBrushScript(color: Colors.black);
      case '나눔손글씨 펜':
        return GoogleFonts.nanumPenScript(color: Colors.black);
      case '메이플스토리체':
        return const TextStyle(fontFamily: 'MapleStory', color: Colors.black);
      case '넥슨 Lv2 고딕':
        return const TextStyle(
            fontFamily: 'NexonLv2Gothic', color: Colors.black);
      case 'Neo 둥근모':
        return const TextStyle(fontFamily: 'NeoDGM', color: Colors.black);
      default:
        return defaultFont;
    }
  }

  static Future<void> preInit() async {
    if (isDistributed) {
      ConstList.actualPlatformType = PlatformType.web;
    } else {
      if (kIsWeb) {
        ConstList.actualPlatformType = PlatformType.web;
      } else if (Platform.isAndroid) {
        ConstList.actualPlatformType = PlatformType.mobile;
      } else if (Platform.isWindows) {
        ConstList.actualPlatformType = PlatformType.desktop;
      }
    }
    await platform_specified.loadLibrary();
    platform_specified.PlatformSpecified().preInit();
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
    if (!ConstList.isDistributed) {
      await v_start.loadLibrary();
      await v_make.loadLibrary();
    }
    runApp(
      GetMaterialApp(
        title: 'CYOAP',
        initialRoute: '/',
        getPages: List.generate(ConstList.isDistributed ? 1 : 3, (index) {
          if (ConstList.isDistributed) {
            return GetPage(
              name: '/',
              page: () => v_play.ViewPlay(),
            );
          } else {
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
