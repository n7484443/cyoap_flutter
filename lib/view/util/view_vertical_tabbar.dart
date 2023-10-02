import 'package:flutter/material.dart';

class VerticalTabBar extends StatelessWidget {
  final bool isUnable;
  final int? currentIndex;
  final List<String> tabList;
  final bool isVertical;
  final Function(int? index) onChange;

  const VerticalTabBar(
      {super.key, this.isUnable = true, this.isVertical = true, required this.tabList, required this.currentIndex, required this.onChange});

  @override
  Widget build(BuildContext context) {
    var inner = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(
          tabList.length,
              (index) {
            index = tabList.length - 1 - index;
            return Ink(
              color:
              index != currentIndex ? Colors.transparent : Colors.red,
              child: InkWell(
                child: SizedBox(
                  width: 80,
                  child: Center(child: Text(tabList[index])),
                ),
                onTap: () {
                  if (isUnable && index == currentIndex) {
                    onChange(null);
                  } else {
                    onChange(index);
                  }
                },
              ),
            );
          }),
    );
    if(isVertical){
      return RotatedBox(
        quarterTurns: 3,
        child: inner,
      );
    }
    return inner;
  }
}