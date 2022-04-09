import 'dart:typed_data';

import 'package:cyoap_flutter/main.dart';
import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

class ImageDB {
  static final ImageDB _instance = ImageDB._init();

  factory ImageDB(){
    return _instance;
  }

  ImageDB._init() {
    if (ConstList.isOnlyFileAccept()) {
      var idbFactory = getIdbFactory()!;
      idbFactory.open(
        databaseName,
        version: ConstList.versionBuild,
        onUpgradeNeeded: (VersionChangeEvent event) {
          var database = event.database;

          if(database.objectStoreNames.contains(objectStore)){
            database.deleteObjectStore(objectStore);
          }
          database.createObjectStore(objectStore, autoIncrement: true);
        },
      ).then((value) {
        database = value;
      });
    }
  }

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
  late Database database;

  ObjectStore get notesWritableTxn {
    var txn = database.transaction(objectStore, idbModeReadWrite);
    var store = txn.objectStore(objectStore);
    return store;
  }

  ObjectStore get notesReadableTxn {
    var txn = database.transaction(objectStore, idbModeReadOnly);
    var store = txn.objectStore(objectStore);
    return store;
  }

  Future<void> uploadImages(String name, Uint8List data) async {
    if (_dirImageUint8Map.containsKey(name)) {
      return;
    }
    _dirImageUint8Map[name] = null;
    if (ConstList.isOnlyFileAccept()) {
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
      if (ConstList.isOnlyFileAccept()) {
        await notesWritableTxn.put(value, name);
      } else {
        _dirImageUint8Map[name] = value;
      }
    });
  }

  Future<Uint8List?> getImage(String name) async {
    if (ConstList.isOnlyFileAccept()) {
      return await notesReadableTxn.getObject(name) as Uint8List;
    } else {
      return _dirImageUint8Map[name];
    }
  }

  Future<String?> getImageAsString(String name) async {
    if (ConstList.isOnlyFileAccept()) {
      var value = await notesReadableTxn.getObject(name) as Uint8List;
      return String.fromCharCodes(value);
    } else {
      return String.fromCharCodes(_dirImageUint8Map[name]!);
    }
  }

  Future<bool> hasImage(String name) async {
    if (ConstList.isOnlyFileAccept()) {
      var value = await notesReadableTxn.getObject(name);
      return value != null;
    }
    return _dirImageUint8Map.containsKey(name);
  }
}
