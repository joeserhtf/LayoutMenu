import 'package:flutter/material.dart';

///Função generica para calcular o tamanho da tela
double mediaQuery(BuildContext context, double value, {String direction = "H"}) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  Size size = mediaQuery.size;
  if (direction.toUpperCase() == 'H') {
    return size.width * value;
  } else {
    return size.height * value;
  }
}
