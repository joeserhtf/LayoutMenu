import 'package:flutter/material.dart';
import 'package:layoutmenu/layout.dart';

import 'global.dart';

class CustomAppBar extends StatelessWidget {
  final List<Widget>? actionWidgets;
  final List<NavPage> pages;

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
                          "${currentPage.activeSubMenu != null ? "${currentPage.title} - ${currentPage.activeSubMenu!.title}" : currentPage.title}",
                          style: TextStyle(
                            color: textAppBarColor,
                          ),
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
}
