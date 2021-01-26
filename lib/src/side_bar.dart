import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../layout.dart';
import 'global.dart';

class SideBar extends StatefulWidget {
  String logo;
  String appName;
  String version;
  List<NavMenu> pages;
  Widget logoutPage;

  SideBar({
    this.logo,
    this.appName,
    @required this.pages,
    @required this.version,
    @required this.logoutPage,
  });

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navigationColor,
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: checkPlatformSize(context) && activeMenu == false
              ? Image.network(
                  widget.logo,
                  alignment: Alignment.center,
                )
              : Column(
                  children: [
                    Text(
                      widget.appName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textHeaderColor,
                      ),
                    ),
                    Text(
                      'Versão: ' + widget.version ?? 'Deconhecida',
                      style: TextStyle(
                        fontSize: 11,
                        color: textHeaderColor,
                      ),
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
        return widget.pages[index].visible
            ? _menu(widget.pages[index].icon, widget.pages[index].title, index)
            : Container();
      },
    );
  }

  _menu(IconData icon, String text, int index) {
    if (activeMenu) {
      if (widget.pages[index].subMenus != null) {
        return SingleChildScrollView(
          child: ExpansionTile(
            initiallyExpanded: false,
            leading: Icon(
              icon,
              color: textNavigationColor,
            ),
            title: Text(
              text,
              style: TextStyle(
                color: textNavigationColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_down,
              color: textNavigationColor,
            ),
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.pages[index].subMenus.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return Container(
                    width: (activeMenu ? 300 : 65) * 0.9,
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.only(left: (activeMenu ? 300 : 65) * 0.1),
                      dense: true,
                      leading: Icon(
                        widget.pages[index].subMenus[i].icon,
                        color: textNavigationColor,
                        size: 12,
                      ),
                      title: Text(
                        widget.pages[index].subMenus[i].title,
                        style: TextStyle(
                          color: textNavigationColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        if (widget.pages.length - 1 == index) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => widget.logoutPage));
                        } else {
                          activeMenu = false;
                          if (pagesController.page.round() != index) {
                            pagesController.jumpToPage(index);
                            await Future.delayed(Duration(milliseconds: 100));
                          }
                          subMenusController[index].jumpToPage(i);
                        }

                        if (widget.pages[index].function != null)
                          widget.pages[index].function();
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
            color: textNavigationColor,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: textNavigationColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            if (widget.pages.length - 1 == index) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => widget.logoutPage),
              );
            } else {
              pagesController.jumpToPage(index);
              activeMenu = false;
            }
            if (widget.pages[index].function != null)
              widget.pages[index].function();
          },
        );
      }
    } else {
      return Tooltip(
        message: text,
        child: Container(
          width: 65,
          height: 60,
          color:
              pagesController.page == index ? selectedColor : navigationColor,
          alignment: Alignment.centerRight,
          child: Container(
            width: 60,
            height: 60,
            color: navigationColor,
            child: ListTile(
              leading: Icon(
                icon,
                color: textNavigationColor,
              ),
              onTap: () {
                if (widget.pages[index].subMenus != null) {
                  activeMenu = true;
                  animationController.add(true);
                } else {
                  if (widget.pages.length - 1 == index) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => widget.logoutPage),
                    );
                  } else {
                    pagesController.jumpToPage(index);
                  }
                }
                if (widget.pages[index].function != null)
                  widget.pages[index].function();
              },
            ),
          ),
        ),
      );
    }
  }
}
