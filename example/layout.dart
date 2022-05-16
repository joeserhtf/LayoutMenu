import 'package:flutter/material.dart';
import 'package:layoutmenu/layout.dart';

import 'logout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _menu();
  }

  _menu() {
    return LayoutMenu(
      logo: Icon(Icons.pages),
      initialPageKey: "purple",
      appName: 'LayoutMenu',
      appVersion: '1.1.0',
      onHoverEnter: false,
      hasAppBar: true,
      backgroundColor: Colors.pink,
      pages: [
        NavPage(
          path: "router1",
          icon: Icon(
            Icons.ac_unit,
            color: Colors.white,
          ),
          visible: true,
          title: 'Menu 1',
          page: Container(
            color: Colors.amberAccent,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  4,
                  (index) => ListTile(
                    title: Text("Big List $index"),
                  ),
                ),
              ),
            ),
          ),
        ),
        NavPage(
          path: "router2",
          icon: Icon(
            Icons.ac_unit,
            color: Colors.white,
          ),
          visible: true,
          title: 'Menu',
          page: Container(
            color: Colors.purple,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  6,
                  (index) => ListTile(
                    title: Text("Big List $index"),
                  ),
                ),
              ),
            ),
          ),
        ),
        NavPage(
          path: "router3",
          icon: Icon(
            Icons.ac_unit,
            color: Colors.white,
          ),
          visible: true,
          title: 'Menu',
          page: Test(),
        ),
        /*NavPage(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.white,
            ),
            visible: true,
            title: 'DashBoard',
            page: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                child: TextButton(
                  child: Text("sususus"),
                  onPressed: () {
                    ActionMenu.goTo("purple");
                  },
                ),
              ),
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
          NavPage(
            icon: Icon(
              Icons.ac_unit,
              color: Colors.white,
            ),
            visible: false,
            title: 'Invisible',
            page: Scaffold(
              backgroundColor: Colors.green,
              body: Container(),
            ),
            function: () {},
          )*/
      ],
      logoutNav: NavPage(
        icon: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        visible: true,
        title: 'Logout',
        page: Logout(),
      ),
    );
  }
}

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("adasd"),
          onPressed: () {
            Navigator.pushNamed(
              context,
              "/router2",
            );
          },
        ),
      ),
    );
  }
}
