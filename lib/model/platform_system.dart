import '../main.dart';
import 'saveWithNonJS.dart'
  if(dart.library.js) 'saveWithJS.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'abstract_platform.dart';

class PlatformSystem{
  static PlatformSystem instance = PlatformSystem();
  PlatformFileSystem platformFileSystem = PlatformFileSystem();
  String? path;

  void openPlatformZip(PlatformFile file){
    var bytes = file.bytes;
    if(bytes == null)return;

    var archiveBytes = TarDecoder().decodeBytes(bytes);
    platformFileSystem.createFromTar(archiveBytes);
  }

  Future<void> openPlatformFolder(String path) async {
    this.path = path;
    await platformFileSystem.createFromFolder(path);
  }

  static Image getImage(String image){
    return instance.platformFileSystem.getImage(image);
  }

  static AbstractPlatform getPlatform(){
    return instance.platformFileSystem.platform;
  }


  void saveFile() async{
    if(ConstList.isFileSystem()){
      saveRaw('exported.tar', platformFileSystem);
    }else{
      saveZip(path!, platformFileSystem);
    }
  }
  void saveFolder() async{
    saveRaw(path!, platformFileSystem);
  }
}
