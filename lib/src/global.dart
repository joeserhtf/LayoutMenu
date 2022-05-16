import 'dart:async';

import 'package:flutter/material.dart';
import 'package:layoutmenu/src/nav_page.dart';

StreamController animationController = StreamController.broadcast();

bool isLargeScreen(BuildContext context) => MediaQuery.of(context).size.width > 770;

bool activeMenu = false;
bool activeSubMenu = false;

double subMenuIndex = -1;

int animationTime = 300;

double maxWidthBar = 300;
double minWidthBar = 65;
double floatMenuWidth = 185;

String? initialPageKey;

List<NavPage>? globalPages;
NavPage? logOutPage;
bool logOutOnScroll = false;

Color appBarColor = Colors.blue[700]!.withOpacity(0.9);
Color headerColor = Colors.blue[600]!.withOpacity(0.8);
Color navigationColor = Color(0xFF222d32);
Color textAppBarColor = Colors.white;
Color textNavigationColor = Colors.white;
Color textHeaderColor = Colors.white;
Color selectedColor = Colors.blue[900]!;
