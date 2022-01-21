import 'package:flutter/material.dart';

class NavMenu {
  String? key;
  Widget icon;
  bool visible;
  String title;
  Widget page;
  List<SubMenu>? subMenus;
  Function? function;
  bool isLogout = false;
  double menuIndex = -1.0;

  SubMenu? activeSubMenu;

  NavMenu({
    required this.icon,
    required this.title,
    required this.page,
    this.key,
    this.visible = true,
    this.subMenus,
    this.function,
  });

  NavMenu.copy(NavMenu pageOrigin)
      : key = pageOrigin.key,
        icon = pageOrigin.icon,
        visible = pageOrigin.visible,
        title = pageOrigin.title,
        page = pageOrigin.page,
        subMenus = pageOrigin.subMenus,
        function = pageOrigin.function,
        menuIndex = pageOrigin.menuIndex;
}

class SubMenu {
  String? key;
  String title;
  Widget page;
  Function? function;
  double menuIndex = -1.0;

  SubMenu({
    required this.title,
    required this.page,
    this.function,
    this.key,
  });
}
