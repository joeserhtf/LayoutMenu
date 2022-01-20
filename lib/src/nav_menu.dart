import 'package:flutter/material.dart';

class NavMenu {
  Widget icon;
  bool visible;
  String title;
  Widget page;
  List<SubMenu>? subMenus;
  Function? function;
  bool isLogout = false;
  double menuIndex = -1.0;

  NavMenu({
    required this.icon,
    required this.visible,
    required this.title,
    required this.page,
    this.subMenus,
    this.function,
  });
}

class SubMenu {
  String title;
  Widget page;
  Function? function;
  double menuIndex = -1.0;

  SubMenu({
    required this.title,
    required this.page,
    this.function,
  });
}
