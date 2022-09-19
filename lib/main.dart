import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart'
    deferred as platform_specified;
import 'package:cyoap_flutter/view/view_make_platform.dart' deferred as v_make;
import 'package:cyoap_flutter/view/view_play.dart' deferred as v_play;
import 'package:cyoap_flutter/view/view_start.dart' deferred as v_start;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tuple/tuple.dart';

import 'color_schemes.g.dart';

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

  static bool isMobile() {
    return !isWeb() && Platform.isAndroid;
  }

  static bool isDesktop() {
    return !isWeb() && Platform.isWindows;
  }

  static bool isRotatable(BuildContext context) {
    return ConstList.isMobile() ||
        (ConstList.isWeb() &&
            ConstList.isSmallDisplay(context) &&
            !ConstList.isDistributed);
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isSmallDisplay(BuildContext context) {
    if (isMobile()) return true;
    if (getScreenWidth(context) < 1000) return true;
    return false;
  }

  static String? _version;

  static String get version => _version ?? '';

  static Future<void> init() async {
    platform_specified.PlatformSpecified().init();
    var packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;

    var userInfo = {
      'platform': isWeb()
          ? 'web'
          : isMobile()
              ? 'mobile'
              : 'desktop',
      'version': _version,
    };
    if (isMobile()) {
      userInfo['androidVersion'] =
          (await DeviceInfoPlugin().androidInfo).version.sdkInt.toString();
    }
    Sentry.configureScope((scope) => scope.setContexts('USER_INFO', userInfo));
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
    "Black Han Sans": GoogleFonts.blackHanSans(
        color: Colors.black,
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "Black And White Picture": GoogleFonts.blackAndWhitePicture(
        color: Colors.black,
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "Neo 둥근모": const TextStyle(
        fontFamily: 'NeoDGM',
        color: Colors.black,
        fontFeatures: [FontFeature.proportionalFigures()]),
  };

  static TextStyle getFont(String font) {
    return textFontList[font] ?? textFontList["notoSans"]!;
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

const String sentryDsn =
    'https://300bedade0de419fb189b2c5634ca1d8@o1393272.ingest.sentry.io/6714767';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ConstList.preInit().then((value) async {
    await v_play.loadLibrary();
    if (!ConstList.isDistributed) {
      await v_start.loadLibrary();
      await v_make.loadLibrary();
    }
    runZonedGuarded(() async {
      await SentryFlutter.init(
        (options) {
          options.dsn = kDebugMode ? '' : sentryDsn;
          options.attachStacktrace = true;
        },
        appRunner: () => runApp(
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
              theme: appThemeLight,
              darkTheme: appThemeDark,
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      );
    }, (error, stack) async {
      await Sentry.captureException(error, stackTrace: stack);
    });
  }).then((value) => ConstList.init());
}

final ThemeData appThemeLight = ThemeData.from(
  colorScheme: lightColorScheme,
  textTheme: GoogleFonts.notoSansTextTheme(),
  useMaterial3: true,
).copyWith(
  appBarTheme: const AppBarTheme(
    toolbarHeight: ConstList.appBarSize,
  ),
);

final ThemeData appThemeDark = ThemeData.from(
  colorScheme: darkColorScheme,
  textTheme: GoogleFonts.notoSansTextTheme().apply(
    bodyColor: darkColorScheme.onSurface,
    displayColor: darkColorScheme.onSurface,
  ),
  useMaterial3: true,
).copyWith(
  appBarTheme: const AppBarTheme(
    toolbarHeight: ConstList.appBarSize,
  ),
);
