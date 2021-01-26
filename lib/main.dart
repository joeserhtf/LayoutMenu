import 'package:flutter/material.dart';

import 'layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LayoutMenu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange,
      ),
      home: LayoutMenu(
        logoutPage: MyApp(),
        logo: '',
        appName: '',
        pages: [
          NavMenu(
            icon: Icons.ac_unit,
            visible: true,
            title: 'null',
            page: Container(),
            subMenus: null,
          ),
          NavMenu(
              icon: Icons.ac_unit,
              visible: true,
              title: 'null',
              page: Scaffold(
                backgroundColor: Colors.grey,
                body: Container(),
              ),
              subMenus: null,
              function: () {}),
          NavMenu(
              icon: Icons.ac_unit,
              visible: true,
              title: 'null',
              page: Scaffold(
                backgroundColor: Colors.green,
                body: Container(),
              ),
              subMenus: [
                NavMenu(
                  icon: Icons.ac_unit,
                  visible: true,
                  title: 'null',
                  page: Scaffold(
                    backgroundColor: Colors.purple,
                    body: Container(),
                  ),
                  subMenus: null,
                ),
                NavMenu(
                  icon: Icons.ac_unit,
                  visible: true,
                  title: 'null',
                  page: Scaffold(
                    backgroundColor: Colors.red,
                    body: Container(),
                  ),
                  subMenus: null,
                ),
                NavMenu(
                  icon: Icons.ac_unit,
                  visible: true,
                  title: 'null',
                  page: Scaffold(
                    backgroundColor: Colors.yellowAccent,
                    body: Container(),
                  ),
                  subMenus: null,
                ),
              ],
              function: () {}),
        ],
        appVersion: '',
      ),
    );
  }
}
