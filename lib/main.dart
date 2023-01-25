import 'package:flutter/material.dart';
import 'package:layoutmenu/layout.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutMenu(
      logo: Icon(Icons.pages),
      initialPageKey: "purple",
      appName: 'LayoutMenu',
      appVersion: '2.0.0',
      onHoverEnter: false,
      hasAppBar: true,
      needsAuth: true,
      backgroundColor: Colors.pink,
      pages: [
        NavPage(
          path: "routera",
          icon: Icon(
            Icons.ac_unit,
            color: Colors.white,
          ),
          visible: true,
          title: 'Menu 1',
          page: Scaffold(
            body: Container(
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
        ),
        NavPage(
          path: "Relatórios",
          icon: Icon(Icons.ac_unit, color: Colors.white),
          visible: true,
          title: 'Menu',
          page: Scaffold(
            body: Container(
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
        ),
        NavPage(
          path: "routerc",
          icon: Icon(
            Icons.ac_unit,
            color: Colors.white,
          ),
          visible: true,
          title: 'Menu',
          page: Scaffold(
            backgroundColor: Colors.cyan,
            body: Container(),
          ),
        ),
        NavPage(
          icon: Icon(
            Icons.ac_unit,
            color: Colors.white,
          ),
          visible: true,
          title: 'routerd',
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
          subMenus: [
            SubPage(
              path: "purple",
              title: 'Purple',
              page: Scaffold(
                backgroundColor: Colors.purple,
                body: Container(),
              ),
            ),
            SubPage(
              path: "red",
              title: 'Red Main',
              page: Scaffold(
                backgroundColor: Colors.red,
                body: Container(),
              ),
            ),
            SubPage(
              path: "yellow",
              title: 'Yellow Menu',
              page: Scaffold(
                backgroundColor: Colors.yellowAccent,
                body: Container(),
              ),
            ),
          ],
        ),
      ],
      loginPage: NavPage(
        icon: Icon(
          Icons.ac_unit,
          color: Colors.white,
        ),
        title: 'Login',
        page: Login(),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: TextButton(
            onPressed: () {
              ActionMenu.setLogged();
              ActionMenu.goTo('/routera');
            },
            child: Text("Enter"),
          ),
        ),
      ),
    );
  }
}
