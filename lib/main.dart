import 'dart:io';
import 'dart:ui';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart'
    deferred as platform_specified;
import 'package:cyoap_flutter/view/view_make_platform.dart' deferred as v_make;
import 'package:cyoap_flutter/view/view_play.dart' deferred as v_play;
import 'package:cyoap_flutter/view/view_start.dart' deferred as v_start;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tuple/tuple.dart';

class ConstList {
  static const bool isDistributed =
      bool.fromEnvironment("isDistributed", defaultValue: false);
  static const double appBarSize = 38.0;
  static const double elevation = 6.0;
  static const double padding = 8.0;
  static const double paddingSmall = 4.0;

  static bool isWeb() {
    return isDistributed || kIsWeb;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isSmallDisplay(BuildContext context) {
    if (Platform.isAndroid) return true;
    if (getScreenWidth(context) < 1000) return true;
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

  static TextStyle defaultFont = GoogleFonts.notoSans(
      color: Colors.black,
      fontFeatures: const [FontFeature.proportionalFigures()]);

  static Map<String, TextStyle> textFontList = {
    "jua": GoogleFonts.jua(
        color: Colors.black,
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "notoSans": GoogleFonts.notoSans(
        color: Colors.black,
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "notoSerif": GoogleFonts.notoSerif(
        color: Colors.black,
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "나눔고딕": GoogleFonts.nanumGothic(
        color: Colors.black,
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "나눔손글씨 붓": GoogleFonts.nanumBrushScript(
        color: Colors.black,
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "나눔손글씨 펜": GoogleFonts.nanumPenScript(
        color: Colors.black,
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "Poor Story": GoogleFonts.poorStory(
        color: Colors.black,
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "East Sea Dokdo": GoogleFonts.eastSeaDokdo(
        color: Colors.black,
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "메이플스토리체": const TextStyle(
        fontFamily: 'MapleStory',
        color: Colors.black,
        fontFeatures: [FontFeature.proportionalFigures()]),
    "넥슨 Lv2 고딕": const TextStyle(
        fontFamily: 'NexonLv2Gothic',
        color: Colors.black,
        fontFeatures: [FontFeature.proportionalFigures()]),
    "Neo 둥근모": const TextStyle(
        fontFamily: 'NeoDGM',
        color: Colors.black,
        fontFeatures: [FontFeature.proportionalFigures()]),
  };

  static TextStyle getFont(String font) {
    return textFontList[font] ?? defaultFont;
  }

  static Future<void> preInit() async {
    await platform_specified.loadLibrary();
    platform_specified.PlatformSpecified().preInit();
    return;
  }

  static double scale(BuildContext context) {
    return isSmallDisplay(context) ? 0.85 : 1.0;
  }
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
      ProviderScope(
        child: MaterialApp(
          title: 'CYOAP',
          initialRoute: '/',
          routes: ConstList.isDistributed
              ? {'/': (context) => v_play.ViewPlay()}
              : {
                  '/': (context) => v_start.ViewStart(),
                  '/viewPlay': (context) => v_play.ViewPlay(),
                  '/viewMake': (context) => v_make.ViewMakePlatform(),
                },
          theme: appThemeData,
          debugShowCheckedModeBanner: false,
        ),
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
