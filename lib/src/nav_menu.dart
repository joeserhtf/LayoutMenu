import 'package:flutter/material.dart';

class NavMenu {
  Widget icon;
  bool visible;
  String title;
  Widget page;
  List<NavMenu> subMenus;
  Function function;

  NavMenu({
    @required this.icon,
    @required this.visible,
    @required this.title,
    @required this.page,
    @required this.subMenus,
    this.function,
  });
}
