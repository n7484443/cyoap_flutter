import 'dart:collection';
import 'dart:typed_data';

import 'package:cyoap_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';
import 'package:tuple/tuple.dart';

import '../util/platform_specified_util/platform_specified.dart';

class ImageDB {
  static final ImageDB _instance = ImageDB._init();

  factory ImageDB() {
    return _instance;
  }

  ImageDB._init();

  Future<void> init() async {
    database ??= await getIdbFactory()!.open(
      databaseName,
      version: 100,
      onUpgradeNeeded: (VersionChangeEvent event) {
        var database = event.database;
        if (database.objectStoreNames.contains(objectStore)) {
          database.deleteObjectStore(objectStore);
        }
        database.createObjectStore(objectStore, autoIncrement: true);
      },
    );
  }

  Queue<String> temp = Queue();
  HashMap<String, Image> tempData = HashMap();

  final Map<String, Uint8List?> _dirImageUint8Map = {};

  List<String> get imageList => _dirImageUint8Map.keys.toList();

  Future<Map<String, String>> get imageMap async {
    Map<String, String> output = {};
    for (var key in _dirImageUint8Map.keys) {
      output[key] = await getImageAsString(key) ?? "";
    }
    return output;
  }

  static const String databaseName = "cyoap_image.db";
  static const String objectStore = "image";
  Database? database;

  ObjectStore get notesWritableTxn {
    var txn = database!.transaction(objectStore, idbModeReadWrite);
    var store = txn.objectStore(objectStore);
    return store;
  }

  ObjectStore get notesReadableTxn {
    var txn = database!.transaction(objectStore, idbModeReadOnly);
    var store = txn.objectStore(objectStore);
    return store;
  }

  Future<void> uploadImages(String name, Uint8List data) async {
    if (_dirImageUint8Map.containsKey(name)) {
      return;
    }
    _dirImageUint8Map[name] = null;
    if (ConstList.isWeb()) {
      await init();
      await notesWritableTxn.put(data, name);
    } else {
      _dirImageUint8Map[name] = data;
    }
  }

  Future<void> uploadImagesFuture(String name, Future<Uint8List> data) async {
    if (_dirImageUint8Map.containsKey(name)) {
      return;
    }
    _dirImageUint8Map[name] = null;
    data.then((value) async {
      if (ConstList.isWeb()) {
        await init();
        await notesWritableTxn.put(value, name);
      } else {
        _dirImageUint8Map[name] = value;
      }
    });
  }

  Future<Uint8List?> _getImage(String name) async {
    if (ConstList.isDistributed) {
      await init();
      if (!_dirImageUint8Map.containsKey(name)) {
        _dirImageUint8Map[name] = null;
        return PlatformSpecified().distribute!.getFileAsUint8('images/$name')
          ..then((value) async {
            await notesWritableTxn.put(value, name);
          });
      } else {
        return await notesReadableTxn.getObject(name) as Uint8List;
      }
    } else if (ConstList.isWeb()) {
      await init();
      return await notesReadableTxn.getObject(name) as Uint8List;
    } else {
      return _dirImageUint8Map[name];
    }
  }

  Future<String?> getImageAsString(String name) async {
    if (ConstList.isWeb()) {
      await init();
      var value = await notesReadableTxn.getObject(name) as Uint8List;
      return String.fromCharCodes(value);
    } else {
      return String.fromCharCodes(_dirImageUint8Map[name]!);
    }
  }

  String getImageName(int index) {
    if(index == -1){
      return "";
    }
    return ImageDB().imageList[index];
  }

  int getImageIndex(String name) {
    return ImageDB().imageList.indexOf(name);
  }

  void clearImageCache() {
    _dirImageUint8Map.clear();
  }

  Image noImage = Image.asset('images/noImage.png');

  Future<void> removeImage(String name) async{
    if (ConstList.isWeb()) {
      await init();
      await notesWritableTxn.delete(name);
    } else {
      _dirImageUint8Map.remove(name);
    }
    checkCache();
  }

  void checkCache(){
    temp = Queue.from(_dirImageUint8Map.keys);
  }

  bool isInCache(String name){
    return temp.contains(name);
  }

  bool isInData(String name){
    return _dirImageUint8Map.keys.contains(name);
  }

  Image getImageFromCache(String name){
    return tempData[name] ?? ImageDB().noImage;
  }

  Future<Image> getImage(String name) async {
    if(isInCache(name)){
      var tmp = tempData[name] ?? noImage;
      temp.remove(name);
      temp.add(name);
      return tmp;
    }
    Uint8List? image = await _getImage(name);
    if (image != null) {
      var output = Image.memory(
        image,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        fit: BoxFit.scaleDown,
      );
      temp.add(name);
      tempData[name] = output;
      return output;
    }

    return noImage;
  }
}
