import 'package:cyoap_flutter/model/choiceNode/choice_node.dart';

class AbstractPlatform {
  int halfWidth;
  int halfHeight;
  int localX;
  int localY;
  double scale;
  String stringImageName;
  String colorBackground;
  int flag;
  List<ChoiceNodeBase> choiceNodes = [
    TextNode(0, 0, 2, 1, 'asdf', false),
    TextNode(0, 1, 1, 1, 'asdf', true),
    ImageNode(1, 1, 1, 1, 'asdf'),
    TextImageNode(0, 2, 1, 1, 'asdf', 'asdf')
  ];

  AbstractPlatform(this.halfWidth, this.halfHeight, this.localX, this.localY,
      this.scale, this.stringImageName, this.colorBackground, this.flag);

  AbstractPlatform.none()
      : halfWidth = 800,
        halfHeight = 400,
        localX = 0,
        localY = 0,
        scale = 1.0,
        stringImageName = '',
        colorBackground = '#909090',
        flag = 0;

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

  int getMinX() => -halfWidth;

  int getMinY() => -halfHeight;

  int getMaxX() => halfWidth;

  int getMaxY() => halfHeight;

  int getWidth() => halfWidth * 2;

  int getHeight() => halfHeight * 2;

  ChoiceNodeBase? getChoiceNode(int posX, int posY){
    for(var node in choiceNodes){
      if(node.x == posX && node.y == posY)return node;
    }
    return null;
  }
}
