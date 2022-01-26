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
        logo: Icon(Icons.pages),
        initialPageKey: "purple",
        appName: 'LayoutMenu',
        appVersion: '1.1.0',
        onHoverEnter: false,
        hasAppBar: false,
        backgroundColor: Colors.pink,
        pages: [
          NavPage(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.white,
            ),
            visible: true,
            title: 'Menu 1',
            page: Container(
              height: 3000,
              width: 1200,
              color: Colors.amberAccent,
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      80,
                      (index) => ListTile(
                            title: Text("Big List $index"),
                          )),
                ),
              ),
            ),
          ),
          NavPage(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.white,
            ),
            visible: true,
            title: 'DashBoard',
            page: Scaffold(
              backgroundColor: Colors.grey,
              body: Container(),
            ),
            function: () {},
          ),
          NavPage(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.white,
            ),
            visible: true,
            title: 'Categories',
            key: "cat",
            page: Scaffold(
              backgroundColor: Colors.green,
              body: Container(),
            ),
            subMenus: [
              SubPage(
                key: "purple",
                title: 'Purple Main',
                page: Scaffold(
                  backgroundColor: Colors.purple,
                  body: Container(),
                ),
              ),
              SubPage(
                title: 'Red Main',
                page: Scaffold(
                  backgroundColor: Colors.red,
                  body: Container(),
                ),
              ),
              SubPage(
                title: 'Yellow Menu',
                page: Scaffold(
                  backgroundColor: Colors.yellowAccent,
                  body: Container(),
                ),
              ),
            ],
            function: () {},
          ),
          NavPage(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.white,
            ),
            visible: true,
            title: 'Categories',
            page: Scaffold(
              backgroundColor: Colors.green,
              body: Container(),
            ),
            subMenus: [
              SubPage(
                title: 'Purple Main',
                page: Scaffold(
                  backgroundColor: Colors.purple,
                  body: Container(),
                ),
              ),
              SubPage(
                title: 'Red Main',
                page: Scaffold(
                  backgroundColor: Colors.red,
                  body: Container(),
                ),
              ),
              SubPage(
                title: 'Yellow Menu',
                page: Scaffold(
                  backgroundColor: Colors.yellowAccent,
                  body: Container(),
                ),
              ),
            ],
            function: () {},
          ),
          NavPage(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.white,
            ),
            visible: true,
            title: 'Categories',
            page: Scaffold(
              backgroundColor: Colors.green,
              body: Container(),
            ),
            subMenus: [
              SubPage(
                title: 'Purple Main',
                page: Scaffold(
                  backgroundColor: Colors.purple,
                  body: Container(),
                ),
              ),
              SubPage(
                title: 'Red Main',
                page: Scaffold(
                  backgroundColor: Colors.red,
                  body: Container(),
                ),
              ),
              SubPage(
                title: 'Yellow Menu',
                page: Scaffold(
                  backgroundColor: Colors.yellowAccent,
                  body: Container(),
                ),
              ),
            ],
            function: () {},
          ),
        ],
        logoutNav: NavPage(
          icon: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          visible: true,
          title: 'Logout',
          page: Container(),
        ),
      ),
    );
  }
}
