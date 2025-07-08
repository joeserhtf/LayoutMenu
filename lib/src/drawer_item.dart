import 'package:flutter/material.dart';

class DrawerItem {
  final String title;
  final Icon icon;
  final Function function;

  DrawerItem({
    required this.title,
    required this.icon,
    required this.function,
  });
}
