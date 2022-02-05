import 'dart:io';

import 'package:cyoap_flutter/view/view_code_editor.dart';
import 'package:cyoap_flutter/view/view_editor.dart';
import 'package:cyoap_flutter/view/view_global_settings.dart';
import 'package:cyoap_flutter/view/view_make.dart';
import 'package:cyoap_flutter/view/view_play.dart';
import 'package:cyoap_flutter/view/view_start.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

//flutter build web --base-href=/FlutterCyoapWeb/

class ConstList{
  static double appBarSize = 40.0;
  static late final platformType actualPlatformType;

  static bool isFileSystem() {
    return actualPlatformType == platformType.web;
  }

  static bool isMobile() {
    return actualPlatformType == platformType.mobile;
  }
}
enum platformType{
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
        GetPage(name: '/viewGlobalSetting', page: () => const ViewGlobalSetting()),
      ],
      theme: appThemeData,
      defaultTransition: Transition.fade,
    ),
  );
  try{
    if (Platform.isAndroid) {
      ConstList.actualPlatformType = platformType.mobile;
    }else if(Platform.isWindows){
      ConstList.actualPlatformType =  platformType.desktop;
    }else{
      ConstList.actualPlatformType =  platformType.web;
    }
  }catch(e){
    ConstList.actualPlatformType =  platformType.web;
  }
}

final ThemeData appThemeData = ThemeData(
  primaryColor: Colors.black,
  textTheme: GoogleFonts.notoSansTextTheme(),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    elevation: 0,
  )
);
