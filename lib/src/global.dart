import 'dart:async';

import 'package:flutter/material.dart';

import 'nav_menu.dart';

StreamController animationController = StreamController.broadcast();
StreamController controllerInnerStream = StreamController();

bool checkPlatformSize(BuildContext context) => MediaQuery.of(context).size.width > 770;

bool activeMenu = false;
bool activeSubMenu = false;
double subMenuIndex = -1;
int animationTime = 300;
double currentPageIndex = 0;
Widget currentPageWidget = Container();
List<NavMenu>? globalPages;

Color appBarColor = Colors.blue[700]!.withOpacity(0.9);
Color headerColor = Colors.blue[600]!.withOpacity(0.8);
Color navigationColor = Color(0xFF222d32);
Color textAppBarColor = Colors.white;
Color textNavigationColor = Colors.white;
Color textHeaderColor = Colors.white;
Color selectedColor = Colors.blue[900]!;
