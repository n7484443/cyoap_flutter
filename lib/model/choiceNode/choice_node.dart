class ChoiceNodeBase {
  //grid 단위로 설정
  int x;
  int y;
  int width;//-1 = 무한대
  int height;//-1 = 무한대

  ChoiceNodeBase(this.x, this.y, this.width, this.height);

  ChoiceNodeBase.origin()
      : x = 0,
        y = 0,
        width = 1,
        height = 1;
}

class TextNode extends ChoiceNodeBase {
  String text;

  TextNode(int x, int y, int width, int height, this.text)
      : super(x, y, width, height);
}

class ImageNode extends ChoiceNodeBase {
  String imageString;

  ImageNode(int x, int y, int width, int height, this.imageString)
      : super(x, y, width, height);
}

class TextImageNode extends ChoiceNodeBase {
  String Text;
  String imageString;
  
  TextImageNode(int x, int y, int width, int height, this.Text, this.imageString)
      : super(x, y, width, height);
}
