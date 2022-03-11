import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class ImageDB{
  late SharedPreferences sharedPreferences;
  void init() async{
    sharedPreferences = await SharedPreferences.getInstance();
  }

  void uploadImages(String name, Uint8List data){
    sharedPreferences.setString(name, String.fromCharCodes(data));
  }

  Uint8List? getImages(String name){
    if(!sharedPreferences.containsKey(name))return null;
    return Uint8List.fromList(sharedPreferences.getString(name)!.codeUnits);
  }

  void clearImages(List<String> names){
    for(var name in names){
      sharedPreferences.remove(name);
    }
  }
}