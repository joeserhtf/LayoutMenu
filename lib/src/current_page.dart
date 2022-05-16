import 'package:flutter/material.dart';

class CurrentPage {
  String path;
  Widget page;
  String title;
  num index;

  CurrentPage(
    this.path,
    this.page,
    this.title,
    this.index,
  );
}
