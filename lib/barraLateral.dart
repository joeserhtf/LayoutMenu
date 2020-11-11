import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'globalResponsivo.dart';
import 'layoutmenu.dart';

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
      backgroundColor: navColor,
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
                        color: textHeaderColor,
                      ),
                    ),
                    Text(
                      'Versão: ' + widget.versao ?? 'Deconhecida',
                      style: TextStyle(fontSize: 11, color: textHeaderColor),
                    ),
                  ],
                ),
        ),
        backgroundColor: headerColor,
      ),
      body: _listMenus(),
    );
  }

  _listMenus() {
    return ListView.builder(
      itemCount: widget.pages.length,
      itemBuilder: (context, index) {
        return widget.pages[index].visivel
            ? _menu(widget.pages[index].icone, widget.pages[index].titulo, index)
            : Container();
      },
    );
  }

  _menu(IconData icon, String text, int index) {
    if (openMenu) {
      if (widget.pages[index].submenu != null) {
        return SingleChildScrollView(
          child: ExpansionTile(
            initiallyExpanded: false,
            leading: Icon(
              icon,
              color: textnavColor,
            ),
            title: Text(
              text,
              style: TextStyle(color: textnavColor, fontWeight: FontWeight.bold,),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down,
              color: textnavColor,
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
                        color: textnavColor,
                        size: 12,
                      ),
                      title: Text(
                        widget.pages[index].submenu[i].titulo,
                        style: TextStyle(
                          color: textnavColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        if (widget.pages.length - 1 == index) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.logoutPage));
                        } else {
                          openMenu = false;
                          if(controladorPaginas.page.round() != index) controladorPaginas.jumpToPage(index);
                          controladorSubs[index].jumpToPage(i);
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
            color: textnavColor,
          ),
          title: Text(
            text,
            style: TextStyle(color: textnavColor, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            if (widget.pages.length - 1 == index) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.logoutPage));
            } else {
              controladorPaginas.jumpToPage(index);
              openMenu = false;
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
          color: controladorPaginas.page == index ? selectedColor : navColor,
          alignment: Alignment.centerRight,
          child: Container(
            width: 60,
            height: 60,
            color: navColor,
            child: ListTile(
              leading: Icon(
                icon,
                color: textnavColor,
              ),
              onTap: () {
                if (widget.pages[index].submenu != null) {
                  openMenu = true;
                  controllerAnimacao.add(true);
                } else {
                  if (widget.pages.length - 1 == index) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget.logoutPage));
                  } else {
                    controladorPaginas.jumpToPage(index);
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
