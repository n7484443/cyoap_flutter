import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';
import 'abstract_platform.dart';
import 'saveWithNonJS.dart'
  if(dart.library.js) 'saveWithJS.dart';

class PlatformSystem{
  static PlatformSystem instance = PlatformSystem();
  PlatformFileSystem platformFileSystem = PlatformFileSystem();
  String? path;

  void openPlatformZip(PlatformFile file){
    var bytes = file.bytes;
    if(bytes == null)return;

    var archiveBytes = ZipDecoder().decodeBytes(bytes);
    platformFileSystem.createFromZip(archiveBytes);
  }

  Future<void> openPlatformFolder(String path) async {
    this.path = path;
    await platformFileSystem.createFromFolder(path);
  }

  void openPlatformVoid(){
    platformFileSystem.createFromVoid();
  }

  static AbstractPlatform getPlatform(){
    return instance.platformFileSystem.platform;
  }


  void saveFile() async{
    if(ConstList.isFileSystem()){
      saveZip('exported.zip', platformFileSystem);
    }else{
      saveZip(path!, platformFileSystem);
    }
  }
  void saveFolder() async{
    if(ConstList.isFileSystem()){
      saveRaw('exported.zip', platformFileSystem);
    }else{
      saveRaw(path!, platformFileSystem);
    }
  }

  static List<Uint8List> getImageList() {
    return instance.platformFileSystem.getImageList();
  }

  static String getImageName(int index) {
    return instance.platformFileSystem.getImageName(index);
  }

  static Image getImage(String image){
    return instance.platformFileSystem.getImage(image);
  }

  static void addImage(String name, Uint8List data){
    instance.platformFileSystem.addImage(name, data);
  }

  void saveCapture(ui.Image image) async{
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if(byteData == null)return;
    if(ConstList.isFileSystem()) {
      downloadCapture('exported.jpg', byteData.buffer.asUint8List());
    }else{
      downloadCapture(path!, byteData.buffer.asUint8List());
    }
  }

  static int getImageIndex(String name) {
    return instance.platformFileSystem.getImageIndex(name);
  }

}
