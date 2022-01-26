import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class ImageLoader {
  static late final ImageLoader instance = ImageLoader();
  late String? path;
  Map<String, Image> imageMap = <String, Image>{};
  Image noImage = Image.asset('images/noImage.png');

  Future<void> loadImages(String path) async {
    imageMap.clear();
    this.path = path;
    var folderImage = Directory(path + '/images');
    var folderImageExist = await folderImage.exists();
    if (!folderImageExist) {
      folderImage.create();
    } else {
      try {
        var dirList = folderImage.list();
        await for (FileSystemEntity f in dirList) {
          var name = basename(f.path);
          var type = isImageFile(name);
          if (f is File && type != -1) {
            print('add File "$name"');
            if(type == 1) {
              imageMap[name] = Image.file(f);
            }else{
              var site = await f.readAsString();
              imageMap[name] = Image.network(site);
            }
          }
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
  //1 = 일반 이미지, 0 = 웹 이미지, -1 = 이미지 아님.
  int isImageFile(String path) {
    var name = basename(path).toLowerCase();
    if(name.startsWith('http')){
      return 0;
    }
    if (name.endsWith('.webp')) {
      return 1;
    }
    if (name.endsWith('.png')) {
      return 1;
    }
    if (name.endsWith('.jpg')) {
      return 1;
    }
    if (name.endsWith('.bmp')) {
      return 1;
    }
    if (name.endsWith('.gif')) {
      return 1;
    }
    return -1;
  }

  Image getImage(String name){
    return imageMap[name] ?? noImage;
  }
}
