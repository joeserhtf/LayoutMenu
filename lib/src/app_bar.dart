import 'package:flutter/material.dart';
import 'package:layoutmenu/layout.dart';

import 'global.dart';

class CustomAppBar extends StatelessWidget {
  List<Widget>? actionWidgets;
  List<NavMenu> pages;
  CustomAppBar({Key? key, this.actionWidgets, required this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appBarColor,
      height: kToolbarHeight,
      child: Card(
        color: appBarColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Row(
          children: [
            StreamBuilder(
              stream: animationController.stream,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.menu,
                            color: textAppBarColor,
                          ),
                          onPressed: () {
                            activeMenu = !activeMenu;
                            animationController.add(true);
                          }),
                      Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          _titleComposition(currentPageIndex),
                          style: TextStyle(color: textAppBarColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Row(
              children: actionWidgets ?? [],
            )
          ],
        ),
      ),
    );
  }

  _titleComposition(double index) {
    double subPageIndex = index % 1;
    if (pages[index.toInt()].subMenus != null) {
      return "${pages[index.toInt()].title} "
          "- ${pages[index.toInt()].subMenus![((subPageIndex * 10).round())].title}";
    } else {
      return pages[index.round()].title;
    }
  }
}
