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
            ? _menu(
                widget.pages[index].icon,
                widget.pages[index].title,
                index,
              )
            : Container();
      },
    );
  }

  _menu(Widget icon, String text, int index) {
    if (activeMenu) {
      if (widget.pages[index].subMenus != null) {
        return SingleChildScrollView(
          child: ExpansionTile(
            initiallyExpanded: false,
            leading: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 24,
                maxWidth: 24,
              ),
              child: Theme(
                data: ThemeData(
                  iconTheme: IconThemeData(
                    color: currentPageIndex.round() == index
                        ? selectedColor
                        : textNavigationColor,
                  ),
                ),
                child: icon,
              ),
            ),
            title: Text(
              text,
              style: TextStyle(
                color: textNavigationColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.pages[index].subMenus.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return Container(
                    height: 50,
                    child: Stack(
                      children: [
                        Container(
                          width: 5,
                          color: currentPageIndex ==
                                  double.parse("$index.${i + 1}")
                              ? selectedColor
                              : navigationColor,
                          alignment: Alignment.centerRight,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.only(
                              left: (activeMenu ? 300 : 65) * 0.1),
                          dense: true,
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 14,
                              maxWidth: 14,
                            ),
                            child: Theme(
                              data: ThemeData(
                                iconTheme:
                                    IconThemeData(color: textNavigationColor),
                              ),
                              child: widget.pages[index].subMenus[i].icon,
                            ),
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
                              currentPageWidget = widget.pages[0].page;
                              currentPageIndex = 0;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => widget.logoutPage,
                                ),
                              );
                            } else {
                              activeMenu = false;
                              currentPageWidget =
                                  widget.pages[index].subMenus[i].page;
                              currentPageIndex =
                                  double.parse("$index.${i + 1}");
                              controllerInnerStream.add(true);
                              animationController.add(true);
                            }

                            if (widget.pages[index].function != null) {
                              widget.pages[index].function();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        return Stack(
          children: [
            Container(
              width: 5,
              height: 60,
              color:
                  currentPageIndex == index ? selectedColor : navigationColor,
              alignment: Alignment.centerRight,
            ),
            ListTile(
              leading: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 24,
                  maxWidth: 24,
                ),
                child: Theme(
                  data: ThemeData(
                    iconTheme: IconThemeData(color: textNavigationColor),
                  ),
                  child: icon,
                ),
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
                  currentPageWidget = widget.pages[0].page;
                  currentPageIndex = 0;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => widget.logoutPage),
                  );
                } else {
                  currentPageIndex = double.parse(index.toString());
                  currentPageWidget = widget.pages[index].page;
                  controllerInnerStream.add(true);
                  animationController.add(true);
                  activeMenu = false;
                  //pagesController.jumpToPage(index);
                }
                if (widget.pages[index].function != null) {
                  widget.pages[index].function();
                }
              },
            ),
          ],
        );
      }
    } else {
      if (widget.pages[index].subMenus != null) {
        return SingleChildScrollView(
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 8),
            initiallyExpanded: false,
            title: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 24,
                maxWidth: 24,
              ),
              child: Theme(
                data: ThemeData(
                  iconTheme: IconThemeData(
                    color: currentPageIndex.round() == index
                        ? selectedColor
                        : textNavigationColor,
                  ),
                ),
                child: widget.pages[index].icon,
              ),
            ),
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.pages[index].subMenus.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return Tooltip(
                    message: widget.pages[index].subMenus[i].title,
                    child: Container(
                      width: 5,
                      height: 50,
                      color: currentPageIndex == double.parse("$index.${i + 1}")
                          ? selectedColor
                          : navigationColor,
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 60,
                        height: 50,
                        color: navigationColor,
                        child: InkWell(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 14,
                              maxWidth: 14,
                            ),
                            child: Theme(
                              data: ThemeData(
                                iconTheme: IconThemeData(
                                  color: textNavigationColor,
                                ),
                              ),
                              child: widget.pages[index].subMenus[i].icon,
                            ),
                          ),
                          onTap: () {
                            if (widget.pages.length - 1 == index) {
                              currentPageWidget = widget.pages[0].page;
                              currentPageIndex = 0;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => widget.logoutPage,
                                ),
                              );
                            } else {
                              activeMenu = false;
                              currentPageWidget =
                                  widget.pages[index].subMenus[i].page;
                              currentPageIndex =
                                  double.parse("$index.${i + 1}");
                              controllerInnerStream.add(true);
                              animationController.add(true);
                            }

                            if (widget.pages[index].function != null) {
                              widget.pages[index].function();
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        return Tooltip(
          message: text,
          child: Container(
            width: 5,
            height: 60,
            color: currentPageIndex == index ? selectedColor : navigationColor,
            alignment: Alignment.centerRight,
            child: Container(
              width: 60,
              height: 60,
              color: navigationColor,
              child: ListTile(
                leading: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 24,
                    maxWidth: 24,
                  ),
                  child: Theme(
                    data: ThemeData(
                      iconTheme: IconThemeData(
                        color: textNavigationColor,
                      ),
                    ),
                    child: icon,
                  ),
                ),
                onTap: () {
                  if (widget.pages[index].subMenus != null) {
                    //Todo make expandable without activating menu
                    activeMenu = true;
                    animationController.add(true);
                  } else {
                    if (widget.pages.length - 1 == index) {
                      currentPageWidget = widget.pages[0].page;
                      currentPageIndex = 0;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => widget.logoutPage,
                        ),
                      );
                    } else {
                      currentPageIndex = double.parse(index.toString());
                      currentPageWidget = widget.pages[index].page;
                      controllerInnerStream.add(true);
                      animationController.add(true);
                      //pagesController.jumpToPage(index);
                    }
                  }
                  if (widget.pages[index].function != null) {
                    widget.pages[index].function();
                  }
                },
              ),
            ),
          ),
        );
      }
    }
  }
}
