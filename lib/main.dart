import 'package:flutter/material.dart';
import 'package:layoutmenu/layoutmenu.dart';

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
        logoutPage: Container(),
        logo: '',
        nomeApp: '',
        pages: [
          NavMenu(
            icone: Icons.ac_unit,
            visivel: true,
            titulo: 'null',
            pagina: Scaffold(
              backgroundColor: Colors.blue,
              body: Container(),
            ),
            submenu: null,
          ),
          NavMenu(
              icone: Icons.ac_unit,
              visivel: true,
              titulo: 'null',
              pagina: Scaffold(
                backgroundColor: Colors.grey,
                body: Container(),
              ),
              submenu: null,
              function: () {}),
          NavMenu(
              icone: Icons.ac_unit,
              visivel: true,
              titulo: 'null',
              pagina: Scaffold(
                backgroundColor: Colors.green,
                body: Container(),
              ),
              submenu: null,
              function: () {}),
        ],
        versaoApp: '',
      ),
    );
  }
}
