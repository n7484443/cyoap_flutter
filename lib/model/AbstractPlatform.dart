import 'dart:convert';
import 'dart:io';

class AbstractPlatform {
  static late AbstractPlatform instance;
  int halfWidth;
  int halfHeight;
  int localX;
  int localY;
  double scale;
  String stringImageName;
  String colorBackground;
  int flag;

  AbstractPlatform(this.halfWidth, this.halfHeight, this.localX, this.localY,
      this.scale, this.stringImageName, this.colorBackground, this.flag);

  AbstractPlatform.fromJson(Map<String, dynamic> json)
      : halfWidth = json['halfWidth'],
        halfHeight = json['halfHeight'],
        localX = json['localX'],
        localY = json['localY'],
        scale = json['scale'],
        stringImageName = json['stringImageName'],
        colorBackground = json['colorBackground'],
        flag = json['flag'];

  Map<String, dynamic> toJson() => {
    'halfWidth' : halfWidth,
    'halfHeight' : halfHeight,
    'localX' : localX,
    'localY' : localY,
    'scale' : scale,
    'stringImageName' : stringImageName,
    'colorBackground' : colorBackground,
    'flag' : flag,

  };

  static Future<void> createPlatform(String directory) async {
    var dataPlatform = File(directory + '/platform.json');
    if(await dataPlatform.exists()){
      instance = AbstractPlatform.fromJson(jsonDecode(await dataPlatform.readAsString()));
    }else{
      instance = AbstractPlatform(800, 800, 0, 0, 1, '', '#909090', 0);
    }
  }

  int getMinX() => -halfWidth;

  int getMinY() => -halfHeight;

  int getMaxX() => halfWidth;

  int getMaxY() => halfHeight;

  int getWidth() => halfWidth * 2;

  int getHeight() => halfHeight * 2;
}
