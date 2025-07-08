import 'package:flutter/material.dart';

class NavPage {
  String? path;
  Widget icon;
  bool visible;
  String title;
  Widget page;
  List<SubPage>? subMenus;
  Function? function;
  bool isLogout = false;
  double menuIndex = -1.0;

  SubPage? activeSubMenu;

  NavPage({
    required this.icon,
    required this.title,
    required this.page,
    this.path,
    this.visible = true,
    this.subMenus,
    this.function,
  });

  NavPage.copy(NavPage pageOrigin)
      : path = pageOrigin.path,
        icon = pageOrigin.icon,
        visible = pageOrigin.visible,
        title = pageOrigin.title,
        page = pageOrigin.page,
        subMenus = pageOrigin.subMenus,
        function = pageOrigin.function,
        menuIndex = pageOrigin.menuIndex;
}

class SubPage {
  String? path;
  String title;
  Widget page;
  Function? function;
  double menuIndex = -1.0;

  SubPage({
    required this.title,
    required this.page,
    this.function,
    this.path,
  });
}
