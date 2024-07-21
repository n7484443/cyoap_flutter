import 'dart:io';

import 'package:cyoap_flutter/model/device_preference_util.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';

class DevicePreference {
  static final DevicePreference _instance = DevicePreference._init();

  factory DevicePreference() {
    return _instance;
  }

  DevicePreference._init();

  final DevicePreferenceUtil _util = DevicePreferenceUtil();

  Map<String, dynamic> data = {
    "save_as_webp": false,
    "force_wide": true,
    "clipboard_maximum_capacity": 10,
    "backup_frequency": 30,
    "cyoap_frequent_path": <String>[],
    "cyoap_language": "en",
    "cyoap_theme": "light",
  };

  final Map<String, Type> dataType = {
    "save_as_webp": bool,
    "force_wide": bool,
    "clipboard_maximum_capacity": int,
    "backup_frequency": int,
    "cyoap_frequent_path": List,
    "cyoap_language": String,
    "cyoap_theme": String,
  };

  Future<void> load() async {
    for (var name in data.keys) {
      var type = dataType[name];
      var value = data[name];
      switch (type) {
        case const (bool):
          value = await _util.getBoolVariable(name, defaultValue: value);
          break;
        case const (int):
          value = await _util.getIntVariable(name, defaultValue: value);
          break;
        case const (String):
          value = await _util.getStringVariable(name, defaultValue: value);
          break;
        case const (List):
          value = await _util.getStringListVariable(name, defaultValue: value);
          break;
      }
      data[name] = value;
    }
    if (ConstList.isMobile()) {
      var dir = await getProjectFolder(null);
      var directory = Directory(dir);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      data["cyoap_frequent_path"] =
          directory.listSync().map((e) => e.path).toList();
    }
  }

  Future<void> save() {
    List<Future> outputFutures = [];
    for (var name in data.keys) {
      var type = dataType[name];
      var value = data[name];
      Future future;
      switch (type) {
        case const (bool):
          future = _util.setBoolVariable(name, value as bool);
          break;
        case const (int):
          future = _util.setIntVariable(name, value as int);
          break;
        case const (String):
          future = _util.setStringVariable(name, value as String);
          break;
        default:
          future = _util.setStringListVariable(name, value);
          break;
      }
      outputFutures.add(future);
    }
    return Future.wait(outputFutures);
  }

  void update(String name, dynamic value) {
    data[name] = value;
    save();
  }

  static Future<String> getDownloadFolder() async {
    if (ConstList.isDesktop()) {
      return (await getDownloadsDirectory())!.path;
    }
    var directory = Directory("/storage/emulated/0/Download");
    if (!await directory.exists()) {
      return (await getExternalStorageDirectory())!.path;
    }
    return "/storage/emulated/0/Download";
  }

  static Future<String> getProjectFolder(String? name) async {
    if (ConstList.isMobile()) {
      var dir = (await getExternalStorageDirectory())!;
      if (name == null) {
        return "${dir.path}/project";
      }
      return "${dir.path}/project/$name";
    }
    return name!;
  }

  ThemeMode getThemeMode() {
    return data['cyoap_theme'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  static Map<String, String> localeMap = const {
    'en': 'English',
    'ko': '한국어',
  };

  Locale getLocale() {
    return Locale(data['cyoap_language'] ?? 'en');
  }

  void setThemeMode(ThemeMode mode) {
    if (mode == ThemeMode.light) {
      data['cyoap_theme'] == 'light';
    } else {
      data['cyoap_theme'] == 'dark';
    }
  }
}
