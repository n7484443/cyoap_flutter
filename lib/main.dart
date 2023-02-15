import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cyoap_core/option.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart'
    deferred as platform_specified;
import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';
import 'package:cyoap_flutter/view/view_font_source.dart';
import 'package:cyoap_flutter/view/view_make_platform.dart';
import 'package:cyoap_flutter/view/view_play.dart';
import 'package:cyoap_flutter/view/view_start.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/i18n_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tuple/tuple.dart';

import 'color_schemes.g.dart';
import 'model/device_preference.dart';

class ConstList {
  static const double appBarSize = 38.0;
  static const double elevation = 6.0;
  static const double padding = 8.0;
  static const double paddingSmall = 4.0;

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile() {
    return !isWeb() && Platform.isAndroid;
  }

  static bool isDesktop() {
    return !isWeb() && Platform.isWindows;
  }

  static bool isRotatable(BuildContext context) {
    return ConstList.isMobile() ||
        (ConstList.isWeb() && ConstList.isSmallDisplay(context));
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
    WebpConverter.instance?.init();
    Option().isDebugMode = false;
    Option().enableCode = true;
    Option().enableToken = true;
    Option().enableSelectLog = true;
    Option().enableRecursiveResult = true;
    Option().enableRecursiveStack = true;
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
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "notoSans": GoogleFonts.notoSans(
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "notoSerif": GoogleFonts.notoSerif(
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "나눔고딕": GoogleFonts.nanumGothic(
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "나눔손글씨 붓": GoogleFonts.nanumBrushScript(
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "나눔손글씨 펜": GoogleFonts.nanumPenScript(
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "Poor Story": GoogleFonts.poorStory(
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "East Sea Dokdo": GoogleFonts.eastSeaDokdo(
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "Black Han Sans": GoogleFonts.blackHanSans(
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "Black And White Picture": GoogleFonts.blackAndWhitePicture(
        fontFeatures: const [FontFeature.proportionalFigures()]),
    "Neo 둥근모": const TextStyle(
        fontFamily: 'NeoDGM',
        fontFeatures: [FontFeature.proportionalFigures()]),
  };

  static TextStyle getFont(String font) {
    return textFontList[font] ?? textFontList["notoSans"]!;
  }

  static TextStyle getFontWithColor(String font) {
    return getFont(font).copyWith(color: Colors.black);
  }

  static Future<void> preInit() async {
    await platform_specified.loadLibrary();
    platform_specified.PlatformSpecified().preInit();
    currentLocaleName = (await DevicePreference.getLocaleName())?.trim();
    currentThemeMode = await DevicePreference.getThemeMode();
    return;
  }

  static double scale(BuildContext context) {
    return isSmallDisplay(context) ? 0.85 : 1.0;
  }

  static String? currentLocaleName;

  static Locale? get currentLocale =>
      currentLocaleName == null ? null : localeMap[currentLocaleName];

  static ThemeMode currentThemeMode = ThemeMode.light;

  static Map<String, Locale> localeMap = const {
    'English': Locale('en', 'US'),
    '한국어': Locale('ko', 'KR'),
  };
}

const String sentryDsn =
    'https://300bedade0de419fb189b2c5634ca1d8@o1393272.ingest.sentry.io/6714767';

final localeStateProvider = StateProvider<Locale?>((ref) {
  return ConstList.currentLocale;
});

final themeStateProvider = StateProvider<ThemeMode>((ref) {
  ref.listenSelf((previous, next) {
    DevicePreference.setThemeMode(next);
  });
  return ConstList.currentThemeMode;
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ConstList.preInit().then((value) async {
    runZonedGuarded(() async {
      await SentryFlutter.init(
        (options) {
          options.dsn = kDebugMode ? '' : sentryDsn;
          options.attachStacktrace = true;
        },
        appRunner: () => runApp(
          ProviderScope(
            child: I18n(
              initialLocale: ConstList.currentLocale,
              child: Consumer(
                builder: (context, ref, child) {
                  return MaterialApp(
                    locale: ref.watch(localeStateProvider),
                    localizationsDelegates: [
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                    ],
                    supportedLocales: [
                      const Locale('en', "US"),
                      const Locale('ko', "KR"),
                    ],
                    title: 'CYOAP',
                    initialRoute: '/',
                    routes: {
                      '/': (context) => const ViewStart(),
                      '/viewPlay': (context) => const ViewPlay(),
                      '/viewMake': (context) => const ViewMakePlatform(),
                      '/viewLicense': (context) => const ViewFontSource(),
                    },
                    theme: appThemeLight,
                    darkTheme: appThemeDark,
                    themeMode: ref.watch(themeStateProvider),
                    debugShowCheckedModeBanner: false,
                  );
                },
              ),
            ),
          ),
        ),
      );
    }, (error, stack) async {
      await Sentry.captureException(error, stackTrace: stack);
      if (ConstList.isDesktop()) {
        var f = File(
            '${Directory.current.path}/error-${DateTime.now().toString()}.log');
        await f.writeAsString("$error \r\n $stack");
      }
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
  sliderTheme: const SliderThemeData(
    showValueIndicator: ShowValueIndicator.always,
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
  sliderTheme: const SliderThemeData(
    showValueIndicator: ShowValueIndicator.always,
  ),
);
