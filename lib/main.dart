import 'dart:async';
import 'dart:io';

import 'package:context_menus/context_menus.dart';
import 'package:cyoap_core/option.dart';
import 'package:cyoap_flutter/util/platform_specified_util/platform_specified.dart'
    deferred as platform_specified;
import 'package:cyoap_flutter/util/platform_specified_util/webp_converter.dart';
import 'package:cyoap_flutter/view/edit/view_make_platform.dart';
import 'package:cyoap_flutter/view/view_font_source.dart';
import 'package:cyoap_flutter/view/view_play.dart';
import 'package:cyoap_flutter/view/view_start.dart';
import 'package:cyoap_flutter/viewModel/vm_start.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:i18n_extension/i18n_extension.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:window_manager/window_manager.dart';

import 'color_schemes.g.dart';
import 'model/device_preference.dart';

enum DisplaySize {
  small,
  medium,
  large;
}

extension DisplaySizeExtension on DisplaySize {
  static DisplaySize getDisplaySize(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    if (width < 640) return DisplaySize.small;
    if (width > 1008) return DisplaySize.large;
    return DisplaySize.medium;
  }

  bool isSmall() {
    return this == DisplaySize.small;
  }

  bool isLarge() {
    return this == DisplaySize.large;
  }
}

class ConstList {
  static const Duration debounceDuration = Duration(milliseconds: 50);
  static const Duration durationAnimation = Duration(milliseconds: 150);
  static const double appBarSize = 36.0;
  static const double elevation = 1.0;
  static const double padding = 10.0;
  static const double paddingHuge = 20.0;
  static const double paddingSmall = 5.0;

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
    if (DisplaySizeExtension.getDisplaySize(context).isSmall()) return true;
    return false;
  }

  static bool isLargeDisplay(BuildContext context) {
    if (DisplaySizeExtension.getDisplaySize(context).isLarge()) return true;
    return true;
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
    return DefaultStyles(
      paragraph: DefaultTextBlockStyle(
          defaultTextStyle,
          const HorizontalSpacing(0, 0),
          const VerticalSpacing(0, 0),
          const VerticalSpacing(0, 0),
          null),
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
    "IBM Plex Sans KR": GoogleFonts.ibmPlexSansKr(
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
    await DevicePreference().load();
    platform_specified.PlatformSpecified().preInit();
    // currentLocaleName = (await DevicePreferenceUtil.getLocaleName())?.trim();
    return;
  }

  static double scale(BuildContext context) {
    return isSmallDisplay(context) ? 0.85 : 1.0;
  }

  static TextTheme getCurrentFont(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  static int clipboardMaximumCapacity = 10;
}

const String sentryDsn =
    'https://300bedade0de419fb189b2c5634ca1d8@o1393272.ingest.sentry.io/6714767';

final localeStateProvider = StateProvider<Locale?>((ref) {
  ref.listenSelf((previous, next) {
    ref
        .read(devicePreferenceStateProvider.notifier)
        .update("cyoap_language", next?.toString().toLowerCase());
    Option().locale = next?.toString().toLowerCase();
  });
  return DevicePreference().getLocale();
});

final themeStateProvider = StateProvider<ThemeMode>((ref) {
  ref.listenSelf((previous, next) {
    ref
        .read(devicePreferenceStateProvider.notifier)
        .update("cyoap_theme", next == ThemeMode.dark ? "dark" : "light");
  });
  return DevicePreference().getThemeMode();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConstList.preInit();
  if (ConstList.isDesktop()) {
    await windowManager.ensureInitialized();
    var windowOptions = const WindowOptions(
      size: Size(1280, 720),
      center: true,
      minimumSize: Size(960, 640),
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    windowManager.setTitleBarStyle(TitleBarStyle.normal);
  }
  await SentryFlutter.init(
    (options) {
      options.dsn = kDebugMode ? '' : sentryDsn;
      options.attachStacktrace = true;
    },
    appRunner: () => runApp(
      ProviderScope(
        child: Consumer(builder: (context, ref, child) {
          return I18n(
            initialLocale: ref.watch(localeStateProvider),
            child: ContextMenuOverlay(
              child: MaterialApp(
                locale: ref.watch(localeStateProvider),
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en'),
                  const Locale('ko'),
                ],
                title: 'CYOAP',
                initialRoute: '/',
                routes: {
                  '/': (context) => const ViewStart(),
                  '/viewPlay': (context) => const ViewPlay(),
                  '/viewEdit': (context) => const ViewMakePlatform(),
                  '/viewLicense': (context) => const ViewFontSource(),
                },
                theme: appThemeLight,
                darkTheme: appThemeDark,
                themeMode: ref.watch(themeStateProvider),
                debugShowCheckedModeBanner: false,
              ),
            ),
          );
        }),
      ),
    ),
  );
  ConstList.init();
}

final ThemeData appThemeLight = ThemeData.from(
  colorScheme: MaterialTheme.lightScheme(),
  textTheme: GoogleFonts.notoSansTextTheme(),
).copyWith(
  appBarTheme: const AppBarTheme(
    toolbarHeight: ConstList.appBarSize,
    scrolledUnderElevation: 0.0,
  ),
  sliderTheme: const SliderThemeData(
    showValueIndicator: ShowValueIndicator.always,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
  ),
  dialogTheme: const DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
  ),
);

final ThemeData appThemeDark = ThemeData.from(
  colorScheme: MaterialTheme.darkScheme(),
).copyWith(
  appBarTheme: const AppBarTheme(
    toolbarHeight: ConstList.appBarSize,
    scrolledUnderElevation: 0.0,
  ),
  sliderTheme: const SliderThemeData(
    showValueIndicator: ShowValueIndicator.always,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
  ),
  dialogTheme: const DialogTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
  ),
);
