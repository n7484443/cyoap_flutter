import 'dart:typed_data';

import 'package:cyoap_flutter/main.dart';
import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

class ImageDB {
  static final ImageDB instance = ImageDB();

  final Map<String, Uint8List?> _dirImageUint8Map = {};

  List<String> get imageList => _dirImageUint8Map.keys.toList();

  Future<Map<String, String>> get imageMap async {
    Map<String, String> output = {};
    for (var key in _dirImageUint8Map.keys) {
      output[key] = await instance.getImageAsString(key) ?? "";
    }
    return output;
  }

  String databaseName = "cyoap_image.db";
  String objectStore = "image";
  late Database database;

  bool _init = false;

  Future<void> init() async {
    if (!_init) {
      if (ConstList.isOnlyFileAccept()) {
        var idbFactory = getIdbFactory()!;
        database = await idbFactory.open(
          databaseName,
          version: 1,
          onUpgradeNeeded: (VersionChangeEvent event) {
            database = event.database;
            database.createObjectStore(objectStore, autoIncrement: true);
          },
        );
      }
      _init = true;
    }
  }

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

    await init();
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

    await init();
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
    await init();
    if (ConstList.isOnlyFileAccept()) {
      return await notesReadableTxn.getObject(name) as Uint8List;
    } else {
      return _dirImageUint8Map[name];
    }
  }

  Future<String?> getImageAsString(String name) async {
    await init();
    if (ConstList.isOnlyFileAccept()) {
      var value = await notesReadableTxn.getObject(name) as Uint8List;
      return String.fromCharCodes(value);
    } else {
      return String.fromCharCodes(_dirImageUint8Map[name]!);
    }
  }

  Future<bool> hasImage(String name) async {
    await init();
    if (ConstList.isOnlyFileAccept()) {
      var value = await notesReadableTxn.getObject(name);
      return value != null;
    }
    return _dirImageUint8Map.containsKey(name);
  }
}
