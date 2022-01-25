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
  String text;

  TextNode(int x, int y, int width, int height, this.text, bool isCard)
      : super(x, y, width, height, isCard ? 1 : 0, '', text);
}

class ImageNode extends ChoiceNodeBase {
  String imageString;

  ImageNode(int x, int y, int width, int height, this.imageString)
      : super(x, y, width, height, 2, '', '');
}

class TextImageNode extends ChoiceNodeBase {
  String Text;
  String imageString;
  
  TextImageNode(int x, int y, int width, int height, this.Text, this.imageString)
      : super(x, y, width, height, 3, '', Text);
}
