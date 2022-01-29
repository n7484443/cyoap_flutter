import 'package:cyoap_flutter/model/platform_file_system.dart';
import 'dart:io';

void saveRaw(String name, PlatformFileSystem platformFileSystem) async{
  await platformFileSystem.saveToFolder(name);
  print('save Done!');
}