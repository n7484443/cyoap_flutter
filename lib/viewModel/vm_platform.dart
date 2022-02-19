import 'dart:convert';

import 'package:cyoap_flutter/main.dart';
import 'package:cyoap_flutter/model/variable_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:zefyr/zefyr.dart';

import '../model/choiceNode/choice_node.dart';
import '../model/editor.dart';
import '../model/platform_system.dart';
import '../util/tuple.dart';
import '../view/view_choice_node.dart';

class VMPlatform extends GetxController{
  List<List<Widget>> widgetList = List.empty(growable: true);
  Tuple<int, int>? drag;
  bool isChanged = false;
  Tuple<int, int> mouseHover = Tuple(-1, -1);
  Tuple<int, int> sizeSet = Tuple(1, 1);

  GlobalKey captureKey = GlobalKey();
  GlobalKey keyListView = GlobalKey();

  ScrollController scroller = ScrollController();

  void updateWidgetList(){
    widgetList.clear();

    var list = PlatformSystem.getPlatform().choiceNodes;
    for (int y = 0; y < list.length; y++) {
      widgetList.add(List.empty(growable: true));
      var xList = list[y];
      for (int x = 0; x < xList.data1.length; x++) {
        widgetList[y].insert(
            x, getWidgetFromType(xList.data1[x].getType(), xList.data1[x].isCard, x, y));
      }
    }
    update();
    isChanged = true;
  }

  Widget getWidgetFromType(int type, bool isCard, int x, int y) {
    Widget widget = ViewChoiceNodeTextWithImage(posX: x, posY: y);
    if (isCard) {
      return Card(
        elevation: 5.0,
        child: widget,
      );
    } else {
      return Material(
        color: Colors.white,
        child: widget,
      );
    }
  }

  void setHover(int x, int y){
    mouseHover = Tuple(x, y);
    update();
  }

  Tuple<int, int> getSize(Tuple<int, int> position) {
    var node = getNode(position.data1, position.data2)!;
    return Tuple(node.width, node.height);
  }

  void setSize(Tuple<int, int> position, Tuple<int, int> size) {
    var node = getNode(position.data1, position.data2)!;
    node.width = size.data1;
    node.height = size.data2;
  }

  ChoiceNodeBase createNodeForTemp(){
    return ChoiceNodeBase.noTitle(1, 1, false, '', '');
  }

  ChoiceNodeBase? getNode(int x, int y) {
    if(x == -1 && y == -1){
      return createNodeForTemp();
    }
    return PlatformSystem.getPlatform().getChoiceNode(x, y);
  }

  void setEdit(int posX, int posY) {
    var node = PlatformSystem.getPlatform().getChoiceNode(posX, posY);

    if(node == null){
      return;
    }
    ChoiceNodeBase nodeNonnull = node;
    NodeEditor.instance.setTarget(nodeNonnull);
  }

  ZefyrController? getNodeController(int x, int y){
    var node = getNode(x, y);
    if(node == null || node.contentsString.isEmpty){
      return ZefyrController();
    }else{
      var json = jsonDecode(node.contentsString);
      var document = NotusDocument.fromJson(json);
      return ZefyrController(document);
    }
  }

  void dragStart(int posX, int posY) {
    drag = Tuple(posX, posY);
    update();
  }
  void dragEnd() {
    drag = null;
    update();
  }

  void changeData(Tuple<int, int> data, Tuple<int, int> pos) {
    if(data == Tuple(-1, -1)){
      PlatformSystem.getPlatform().addData(pos.data1, pos.data2, createNodeForTemp());
      updateWidgetList();
    }else{
      PlatformSystem.getPlatform().changeData(data, pos);
      updateWidgetList();
    }
  }

  void removeData(Tuple<int, int> data) {
    PlatformSystem.getPlatform().removeData(data.data1, data.data2);
    updateWidgetList();
  }

  bool isEditable(){
    return PlatformSystem.getPlatform().isEditable;
  }

  void save(bool saveAsFile){
    PlatformSystem.getPlatform().compress();
    updateWidgetList();
    if(saveAsFile){
      PlatformSystem.instance.saveFile();
    }else{
      PlatformSystem.instance.saveFolder();
    }
    isChanged = false;
  }

  void addNode() {
    PlatformSystem.getPlatform().addData(0, 0, ChoiceNodeBase.noTitle(1, 1, true, '', ''));
    PlatformSystem.getPlatform().checkDataCollect();
    updateWidgetList();
  }

  Future<void> exportAsImage() async {
    var boundary = captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    PlatformSystem.instance.saveCapture(await boundary.toImage());
  }

  void sizeChange(int x, int y){
    sizeSet.data1 += x;
    sizeSet.data2 += y;
    if (sizeSet.data1 < 1) {
      sizeSet.data1 = 1;
    }
    if (sizeSet.data2 < 1) {
      sizeSet.data2 = 1;
    }
    update();
  }

  void loadVariable() {
    VariableDataBase.instance.clear();
    for (var ys in PlatformSystem.getPlatform().choiceNodes) {
      for (var node in ys.data1) {
        if(node.executeCodeRecursive != null){
          for (var codes in node.executeCodeRecursive!) {
            codes.unzip();
          }
        }
      }
    }
  }

  void select(int posX, int posY) {
    if(getNode(posX, posY)!.isSelectableWithCheck()){
      PlatformSystem.getPlatform().setSelect(posX, posY);
      update();
    }
  }

  bool isSelect(int posX, int posY) {
    if(posX == -1 && posY == -1)return false;
    return PlatformSystem.getPlatform().isSelect(posX, posY);
  }

  bool isSelectable(int posX, int posY) {
    return getNode(posX, posY)?.isSelectableWithCheck() ?? false;
  }

  bool isSelectablePreCheck(int posX, int posY) {
    return getNode(posX, posY)!.isSelectableCheck;
  }

  void dragUpdate(BoxConstraints constrains, DragUpdateDetails details, BuildContext context){
    double topY = 0;
    double bottomY = topY + constrains.maxHeight;

    var detectedRange = constrains.maxHeight * 0.1;
    var moveDistance = ConstList.isSmallDisplay(context) ? 1.5 : 3;
    if (details.localPosition.dy < topY + detectedRange) {
      scroller.jumpTo(scroller.offset - moveDistance);
    }
    if (details.localPosition.dy > bottomY - detectedRange) {
      scroller.jumpTo(scroller.offset + moveDistance);
    }
  }

  double getScale() {
    var context = captureKey.currentContext;
    if (context == null) return 1;
    return ConstList.isSmallDisplay(context) ? 0.75 : 1;
  }

  ZefyrThemeData getZefyrThemeData(BuildContext context){
    final defaultStyle = DefaultTextStyle.of(context);
    final baseStyle = defaultStyle.style.copyWith(
      fontSize: 16.0 * getScale(),
      height: 1.3 * getScale(),
    );
    const baseSpacing = VerticalSpacing(top: 6.0, bottom: 10);
    var paragraph = TextBlockTheme(
      style: baseStyle,
      spacing: baseSpacing,
      // lineSpacing is not relevant for paragraphs since they consist of one line
    );
    var heading1 = TextBlockTheme(
      style: defaultStyle.style.copyWith(
        fontSize: 34.0 * getScale(),
        color: defaultStyle.style.color?.withOpacity(0.70),
        height: 1.15 * getScale(),
        fontWeight: FontWeight.w300,
      ),
      spacing: VerticalSpacing(top: 16.0 * getScale(), bottom: 0.0),
    );
    var heading2 = TextBlockTheme(
      style: TextStyle(
        fontSize: 24.0 * getScale(),
        color: defaultStyle.style.color?.withOpacity(0.70),
        height: 1.15 * getScale(),
        fontWeight: FontWeight.normal,
      ),
      spacing: VerticalSpacing(bottom: 0.0, top: 8.0 * getScale()),
    );
    var heading3 = TextBlockTheme(
      style: TextStyle(
        fontSize: 20.0 * getScale(),
        color: defaultStyle.style.color?.withOpacity(0.70),
        height: 1.25 * getScale(),
        fontWeight: FontWeight.w500,
      ),
      spacing: VerticalSpacing(bottom: 0.0, top: 8.0 * getScale()),
    );

    return ZefyrThemeData.fallback(context).copyWith(
      heading1: heading1,
      heading2: heading2,
      heading3: heading3,
      paragraph: paragraph,
    );
  }
}