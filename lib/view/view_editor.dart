import 'dart:typed_data';
import 'dart:ui';

import 'package:cyoap_flutter/model/platform_system.dart';
import 'package:cyoap_flutter/view/view_variable_table.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/src/translations/toolbar.i18n.dart'
    as quill_translate;
import 'package:flutter_quill/src/utils/color.dart' as quill_color;
import 'package:get/get.dart';
import 'package:image_cropping/image_cropping.dart';

import '../main.dart';
import '../viewModel/vm_editor.dart';

class ViewEditor extends StatelessWidget {
  const ViewEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VMEditor controller = Get.put(VMEditor());

    var alert = AlertDialog(
      title: const Text('뒤로가기'),
      content: const Text('저장되지 않은 내용이 있습니다. 저장하시겠습니까?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            controller.isChanged = false;
            Get.back();
            Get.back();
          },
          child: const Text('아니오'),
        ),
        ElevatedButton(
          onPressed: () {
            controller.isChanged = false;
            controller.save();
            Get.back();
            Get.back();
          },
          child: const Text('예'),
        ),
      ],
    );

    var appbarWidget = PreferredSize(
      preferredSize: Size.fromHeight(ConstList.appBarSize),
      child: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if(controller.isChanged){
              showDialog(
                context: context,
                builder: (_) => alert,
              );
            }else{
              Get.back();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Get.find<VMEditor>().save();
            },
          ),
        ],
      ),
    );

    var editingNodeValues = SizedBox(
      child: GetBuilder<VMEditor>(
        builder: (_) => Column(
          children: [
            Row(
              children: [
                const Text(
                  '카드 모드',
                  style: TextStyle(color: Colors.black),
                ),
                Switch(
                  onChanged: (bool value) {
                    controller.setCard(value);
                  },
                  value: controller.isCard,
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  '선택 가능',
                  style: TextStyle(color: Colors.black),
                ),
                Switch(
                  onChanged: (bool value) {
                    controller.setSelectable(value);
                  },
                  value: controller.isSelectable,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (ConstList.isSmallDisplay(context)) {
      return WillPopScope(
        child: Scaffold(
          appBar: appbarWidget,
          drawer: const ViewVariable(),
          body: Column(
            children: [
              Container(
                color: Colors.black12,
                child: TextField(
                  controller: controller.controllerTitle,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: '제목'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ViewEditorTyping(),
                      ),
                    ),
                    editingNodeValues,
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: (){
          return showDialog(
            context: context,
            builder: (_) => alert,
          ) as Future<bool>;
        },
      );
    } else {
      return Scaffold(
        appBar: appbarWidget,
        body: Row(
          children: [
            const ViewVariable(),
            Expanded(
              child: Column(
                children: [
                  Container(
                    color: Colors.black12,
                    child: TextField(
                      controller: controller.controllerTitle,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(hintText: '제목'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: ViewEditorTyping(),
                          ),
                        ),
                        editingNodeValues,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class ViewEditorTyping extends StatelessWidget {
  const ViewEditorTyping({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final VMEditor controller = Get.put(VMEditor());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: getQuillToolbar(controller.quillController),
        ),
        Expanded(
          flex: 3,
          child: Card(
            elevation: 5.0,
            child: quill.QuillEditor(
              padding: const EdgeInsets.all(3),
              controller: controller.quillController,
              focusNode: FocusNode(),
              expands: true,
              scrollable: true,
              autoFocus: false,
              readOnly: false,
              scrollController: ScrollController(),
              customStyles: ConstList.getDefaultThemeData(context, 1, fontStyle: ConstList.getFont(getPlatform().mainFont)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                child: const Text('Edit Code'),
                onPressed: () {
                  Get.toNamed('/viewCodeEditor');
                },
              ),
              const SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(hintText: '포인트 증감'),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        var name = controller.addImage();
                        name.then((String name) {
                          if (controller.imageLast != null) {
                            ImageCropping.cropImage(
                              context: context,
                              imageBytes: controller.imageLast!,
                              onImageDoneListener: (data) => controller
                                  .addImageCrop(name, data as Uint8List),
                            );
                          }
                        });
                      },
                      icon: const Icon(Icons.add)),
                ],
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(4.0, 4.0),
                        color: Colors.black38,
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      )
                    ],
                  ),
                  child: ScrollConfiguration(
                    behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    }),
                    child: GetBuilder<VMEditor>(
                      builder: (_) => ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        controller: ScrollController(),
                        itemCount: controller.getImageLength(),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 3,
                                  color: index == controller.index
                                      ? Colors.redAccent
                                      : Colors.white,
                                ),
                              ),
                              child: GestureDetector(
                                child: Image.memory(controller.getImage(index)),
                                onDoubleTap: () {
                                  controller.setImage(index);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

quill.QuillToolbar getQuillToolbar(quill.QuillController controller) {
  var quillToolbar = quill.QuillToolbar.basic(
    controller: controller,
    showListCheck: false,
    showInlineCode: false,
    showVideoButton: false,
    showCameraButton: false,
    showImageButton: false,
    showLink: false,
    showCodeBlock: false,
    showHeaderStyle: false,
    showAlignmentButtons: true,
  );
  bool b = true;
  List<Widget> children = quillToolbar.children.map((e) {
    if (e is quill.ColorButton) {
      if (b) {
        var button = ColorButtonExtension(
          icon: Icons.color_lens,
          iconSize: quill.kDefaultIconSize,
          controller: controller,
          background: false,
        );
        b = false;
        return button;
      } else {
        var button = ColorButtonExtension(
          icon: Icons.format_color_fill,
          iconSize: quill.kDefaultIconSize,
          controller: controller,
          background: true,
        );
        return button;
      }
    }
    return e;
  }).toList();
  return quill.QuillToolbar(
    children: children,
  );
}

class ColorButtonExtension extends StatefulWidget {
  const ColorButtonExtension({
    required this.icon,
    required this.controller,
    required this.background,
    this.iconSize = quill.kDefaultIconSize,
    this.iconTheme,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final bool background;
  final quill.QuillController controller;
  final quill.QuillIconTheme? iconTheme;

  @override
  _ColorButtonExtensionState createState() => _ColorButtonExtensionState();
}

class _ColorButtonExtensionState extends State<ColorButtonExtension> {
  late bool _isToggledColor;
  late bool _isToggledBackground;
  late bool _isWhite;
  late bool _isWhiteBackground;

  quill.Style get _selectionStyle => widget.controller.getSelectionStyle();

  void _didChangeEditingValue() {
    setState(() {
      _isToggledColor =
          _getIsToggledColor(widget.controller.getSelectionStyle().attributes);
      _isToggledBackground = _getIsToggledBackground(
          widget.controller.getSelectionStyle().attributes);
      _isWhite = _isToggledColor &&
          _selectionStyle.attributes['color']!.value == '#ffffff';
      _isWhiteBackground = _isToggledBackground &&
          _selectionStyle.attributes['background']!.value == '#ffffff';
    });
  }

  @override
  void initState() {
    super.initState();
    _isToggledColor = _getIsToggledColor(_selectionStyle.attributes);
    _isToggledBackground = _getIsToggledBackground(_selectionStyle.attributes);
    _isWhite = _isToggledColor &&
        _selectionStyle.attributes['color']!.value == '#ffffff';
    _isWhiteBackground = _isToggledBackground &&
        _selectionStyle.attributes['background']!.value == '#ffffff';
    widget.controller.addListener(_didChangeEditingValue);
  }

  bool _getIsToggledColor(Map<String, quill.Attribute> attrs) {
    return attrs.containsKey(quill.Attribute.color.key);
  }

  bool _getIsToggledBackground(Map<String, quill.Attribute> attrs) {
    return attrs.containsKey(quill.Attribute.background.key);
  }

  @override
  void didUpdateWidget(covariant ColorButtonExtension oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_didChangeEditingValue);
      widget.controller.addListener(_didChangeEditingValue);
      _isToggledColor = _getIsToggledColor(_selectionStyle.attributes);
      _isToggledBackground =
          _getIsToggledBackground(_selectionStyle.attributes);
      _isWhite = _isToggledColor &&
          _selectionStyle.attributes['color']!.value == '#ffffff';
      _isWhiteBackground = _isToggledBackground &&
          _selectionStyle.attributes['background']!.value == '#ffffff';
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_didChangeEditingValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = _isToggledColor && !widget.background && !_isWhite
        ? quill_color.stringToColor(_selectionStyle.attributes['color']!.value)
        : (widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color);

    final iconColorBackground =
        _isToggledBackground && widget.background && !_isWhiteBackground
            ? quill_color
                .stringToColor(_selectionStyle.attributes['background']!.value)
            : (widget.iconTheme?.iconUnselectedColor ?? theme.iconTheme.color);

    final fillColor = _isToggledColor && !widget.background && _isWhite
        ? quill_color.stringToColor('#ffffff')
        : (widget.iconTheme?.iconUnselectedFillColor ?? theme.canvasColor);
    final fillColorBackground =
        _isToggledBackground && widget.background && _isWhiteBackground
            ? quill_color.stringToColor('#ffffff')
            : (widget.iconTheme?.iconUnselectedFillColor ?? theme.canvasColor);

    return quill.QuillIconButton(
      highlightElevation: 0,
      hoverElevation: 0,
      size: widget.iconSize * quill.kIconButtonFactor,
      icon: Icon(widget.icon,
          size: widget.iconSize,
          color: widget.background ? iconColorBackground : iconColor),
      fillColor: widget.background ? fillColorBackground : fillColor,
      onPressed: _showColorPicker,
    );
  }

  void _changeColor(BuildContext context, Color color) {
    var hex = color.value.toRadixString(16);
    if (hex.startsWith('ff')) {
      hex = hex.substring(2);
    }
    hex = '#$hex';
    widget.controller.formatSelection(widget.background
        ? quill.BackgroundAttribute(hex)
        : quill.ColorAttribute(hex));
  }

  void _showColorPicker() {
    Color newColor = const Color(0x00000000);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Color'.i18n),
        backgroundColor: Theme.of(context).canvasColor,
        content: ColorPicker(
          pickersEnabled: {ColorPickerType.wheel: true},
          color: const Color(0x00000000),
          onColorChanged: (color) {
            newColor = color;
          },
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _changeColor(context, newColor);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
