import 'dart:async';
import 'package:flutter/material.dart';

PageController controladorPaginas = PageController(initialPage: 0);
StreamController controllerAnimacao = StreamController.broadcast();

bool openMenu = false;
int tempoAnimacao = 300;

Color corAppBarConteudo = Colors.blue[700].withOpacity(0.9);
Color corAppBarMenu = Colors.blue[600].withOpacity(0.8);
Color corMenuConteudo = Color(0xFF222d32);
