import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:layoutmenu/globalResponsivo.dart';
import 'package:layoutmenu/layoutmenu.dart';

class BarraLateral extends StatefulWidget {
  String logo;
  String nomeApp;
  String versao;
  List<ItemMenu> pages;
  Widget logoutPage;

  BarraLateral({this.logo, this.nomeApp, @required this.pages, @required this.versao, @required this.logoutPage});

  @override
  _BarraLateralState createState() => _BarraLateralState();
}

class _BarraLateralState extends State<BarraLateral> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corMenuConteudo,
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: MediaQuery.of(context).size.width > 770 && openMenu == false
              ? Image.network(
                  widget.logo,
                  alignment: Alignment.center,
                )
              : Column(
                  children: [
                    Text(
                      widget.nomeApp,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Versão: ' + widget.versao ?? 'Deconhecida',
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ],
                ),
        ),
        backgroundColor: corAppBarMenu,
      ),
      body: _listMenus(),
    );
  }

  _listMenus() {
    return ListView.builder(
      itemCount: widget.pages.length,
      itemBuilder: (context, index) {
        return _menu(Colors.white, widget.pages[index].icone, Colors.white, widget.pages[index].titulo, index);
      },
    );
  }

  _menu(Color textColor, IconData icon, Color iconColor, String text, int index) {
    if (openMenu) {
      if (widget.pages[index].submenu != null) {
        return SingleChildScrollView(
          child: ExpansionTile(
            initiallyExpanded: false,
            leading: Icon(
              icon,
              color: iconColor,
            ),
            title: Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down,
              color: iconColor,
            ),
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.pages[index].submenu.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return Container(
                    width: (openMenu ? 300 : 65) * 0.9,
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: (openMenu ? 300 : 65) * 0.1),
                      dense: true,
                      leading: Icon(
                        widget.pages[index].submenu[i].icone,
                        color: iconColor,
                        size: 12,
                      ),
                      title: Text(
                        widget.pages[index].submenu[i].titulo,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        if (widget.pages.length - 1 == index) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.logoutPage));
                        } else {
                          setState(() {
                            controladorPaginas.jumpToPage(index);
                          });
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        return ListTile(
          leading: Icon(
            icon,
            color: iconColor,
          ),
          title: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            if (widget.pages.length - 1 == index) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.logoutPage));
            } else {
              setState(() {
                controladorPaginas.jumpToPage(index);
              });
            }
          },
        );
      }
    } else {
      return Tooltip(
        message: text,
        child: Container(
          width: 65,
          height: 60,
          color: controladorPaginas.page == index ? Colors.blue[900] : corMenuConteudo,
          alignment: Alignment.centerRight,
          child: Container(
            width: 60,
            height: 60,
            color: corMenuConteudo,
            child: ListTile(
              leading: Icon(
                icon,
                color: iconColor,
              ),
              onTap: () {
                if (widget.pages[index].submenu != null) {
                  openMenu = true;
                  controllerAnimacao.add(true);
                } else {
                  if (widget.pages.length - 1 == index) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.logoutPage));
                  } else {
                    setState(() {
                      controladorPaginas.jumpToPage(index);
                    });
                  }
                }
              },
            ),
          ),
        ),
      );
    }
  }
}
