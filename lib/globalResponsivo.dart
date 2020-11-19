import 'dart:async';
import 'package:flutter/material.dart';

PageController controladorPaginas = PageController(initialPage: 0, keepPage: false);
List<PageController> controladorSubs = [];
StreamController controllerAnimacao = StreamController.broadcast();
bool checkPlatformSize(BuildContext context) => MediaQuery.of(context).size.width > 770;

bool activeMenu = false;
int tempoAnimacao = 300;

Color appBarColor = Colors.blue[700].withOpacity(0.9);
Color headerColor = Colors.blue[600].withOpacity(0.8);
Color navColor = Color(0xFF222d32);
Color textAppBarColor = Colors.white;
Color textnavColor = Colors.white;
Color textHeaderColor = Colors.white;
Color selectedColor = Colors.blue[900];
