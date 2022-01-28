class ChoiceNodeBase {
  //grid 단위로 설정
  int x;
  int y;
  int width; //-1 = 무한대
  int height;
  int type;
  String title;
  String contents;

  ChoiceNodeBase(this.x, this.y, this.width, this.height, this.type, this.title,
      this.contents);

  ChoiceNodeBase.origin()
      : x = 0,
        y = 0,
        width = 1,
        height = 1,
        type = 0,
        title = '',
        contents = '';
}

class TextNode extends ChoiceNodeBase {
  TextNode(int width, int height, String title, String contents, bool isCard)
      : super(0, 0, width, height, isCard ? 1 : 0, title, contents);
}

class ImageNode extends ChoiceNodeBase {
  String imageString;

  ImageNode(int width, int height, String title, this.imageString)
      : super(0, 0, width, height, 2, title, '');
}

class TextImageNode extends ChoiceNodeBase {
  String imageString;
  
  TextImageNode(int width, int height, String title, String contents, this.imageString)
      : super(0, 0, width, height, 3, title, contents);
}
