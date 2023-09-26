import 'package:flutter/material.dart';

class VerticalTabBar extends StatelessWidget {
  final int? currentIndex;
  final List<String> tabList;
  final Function(int? index) onChange;
  const VerticalTabBar({super.key, required this.tabList, required this.currentIndex, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: Row(
        children: List.generate(
            tabList.length,
                (index) => Ink(
              color:
              index != currentIndex ? Colors.transparent : Colors.red,
              child: InkWell(
                child: SizedBox(
                  width: 80,
                  child: Center(child: Text(tabList[index])),
                ),
                onTap: () {
                  if (index == currentIndex) {
                    onChange(null);
                  } else {
                    onChange(index);
                  }
                },
              ),
            )),
      ),
    );
  }
}