import 'package:flutter/material.dart';
import 'package:layoutmenu/layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LayoutMenu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: LayoutMenu(
        logoutPage: MyApp(),
        logo: Icon(Icons.pages),
        appName: 'LayoutMenu',
        hoverAction: false,
        hasAppBar: true,
        pages: [
          NavMenu(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.white,
            ),
            visible: true,
            title: 'a',
            page: Container(),
          ),
          NavMenu(
              icon: Icon(
                Icons.ac_unit,
                color: Colors.white,
              ),
              visible: true,
              title: 'b',
              page: Scaffold(
                backgroundColor: Colors.grey,
                body: Container(),
              ),
              function: () {}),
          NavMenu(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.white,
            ),
            visible: true,
            title: 'c',
            page: Scaffold(
              backgroundColor: Colors.green,
              body: Container(),
            ),
            subMenus: [
              SubMenu(
                title: 'd',
                page: Scaffold(
                  backgroundColor: Colors.purple,
                  body: Container(),
                ),
              ),
              SubMenu(
                title: 'e',
                page: Scaffold(
                  backgroundColor: Colors.red,
                  body: Container(),
                ),
              ),
              SubMenu(
                title: 'Categorias',
                page: Scaffold(
                  backgroundColor: Colors.yellowAccent,
                  body: Container(),
                ),
              ),
            ],
            function: () {},
          ),
        ],
        appVersion: '1.1.0',
      ),
    );
  }
}
