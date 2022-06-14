import 'dart:io';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart'
    deferred as platform_specified;
import 'package:cyoap_flutter/view/view_make_platform.dart' deferred as v_make;
import 'package:cyoap_flutter/view/view_play.dart' deferred as v_play;
import 'package:cyoap_flutter/view/view_start.dart' deferred as v_start;
import 'package:cyoap_flutter/viewModel/vm_design_setting.dart';
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
  static const double padding = 8.0;
  static late final PlatformType actualPlatformType;

  static bool isWeb() {
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

  static Map<String, TextStyle> textFontList = {
    "jua": GoogleFonts.jua(color: Colors.black),
    "notoSans": GoogleFonts.notoSans(color: Colors.black),
    "notoSerif": GoogleFonts.notoSerif(color: Colors.black),
    "나눔고딕": GoogleFonts.nanumGothic(color: Colors.black),
    "나눔손글씨 붓": GoogleFonts.nanumBrushScript(color: Colors.black),
    "나눔손글씨 펜": GoogleFonts.nanumPenScript(color: Colors.black),
    "Poor Story": GoogleFonts.poorStory(color: Colors.black),
    "East Sea Dokdo": GoogleFonts.eastSeaDokdo(color: Colors.black),
    "메이플스토리체": const TextStyle(fontFamily: 'MapleStory', color: Colors.black),
    "넥슨 Lv2 고딕":
        const TextStyle(fontFamily: 'NexonLv2Gothic', color: Colors.black),
    "Neo 둥근모": const TextStyle(fontFamily: 'NeoDGM', color: Colors.black),
  };

  static TextStyle getFont(String font) {
    return textFontList[font] ?? defaultFont;
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
                  binding: BindingsBuilder.put(() => VMDesignSetting()),
                );
              default:
                return GetPage(
                  name: '/viewMake',
                  page: () => v_make.ViewMakePlatform(),
                  binding: BindingsBuilder.put(() => VMDesignSetting()),
                );
            }
          }
        }),
        theme: appThemeData,
        defaultTransition: Transition.fade,
        debugShowCheckedModeBanner: false,
      ),
    );
  }).then((value) => ConstList.init());
}

final ThemeData appThemeData = ThemeData(
  colorSchemeSeed: Colors.blueAccent,
  textTheme: GoogleFonts.notoSansTextTheme(),
  appBarTheme: const AppBarTheme(
    toolbarHeight: ConstList.appBarSize,
  ),
  useMaterial3: true,
);