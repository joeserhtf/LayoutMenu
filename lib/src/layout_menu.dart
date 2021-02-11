import 'package:flutter/material.dart';

import 'global.dart';
import 'nav_menu.dart';
import 'side_bar.dart';

class LayoutMenu extends StatefulWidget {
  List<Widget> actionWidgets;
  List<NavMenu> pages;
  String appName;
  String appVersion;
  String logo;
  Widget actionButton;
  Color appBarColor;
  Color navigationColor;
  Color headerColor;
  Color textAppBarColor;
  Color textNavigationColor;
  Color textHeaderColor;
  Color selectedColor;
  Widget logoutPage;

  LayoutMenu({
    this.actionWidgets,
    @required this.pages,
    @required this.appName,
    @required this.appVersion,
    @required this.logo,
    this.actionButton,
    this.appBarColor,
    this.headerColor,
    this.navigationColor,
    this.textAppBarColor,
    this.textHeaderColor,
    this.textNavigationColor,
    this.selectedColor,
    @required this.logoutPage,
  });

  @override
  _LayoutMenuState createState() => _LayoutMenuState();
}

class _LayoutMenuState extends State<LayoutMenu> {
  @override
  void initState() {
    super.initState();
    if (widget.appBarColor != null) appBarColor = widget.appBarColor;
    if (widget.headerColor != null) headerColor = widget.headerColor;
    if (widget.navigationColor != null)
      navigationColor = widget.navigationColor;
    if (widget.textAppBarColor != null)
      textAppBarColor = widget.textAppBarColor;
    if (widget.textHeaderColor != null)
      textHeaderColor = widget.textHeaderColor;
    if (widget.textNavigationColor != null)
      textNavigationColor = widget.textNavigationColor;
    if (widget.selectedColor != null) selectedColor = widget.selectedColor;

    widget.pages.add(NavMenu(
      icon: Icons.exit_to_app,
      visible: true,
      title: 'Logout',
      page: Container(),
      subMenus: null,
    ));

    currentPageWidget = widget.pages[0].page;

    globalPages = widget.pages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.actionButton,
      body: GestureDetector(
        onHorizontalDragEnd: (mov) {
          if (mov.primaryVelocity > 0) {
            activeMenu = true;
            animationController.add(true);
          } else {
            activeMenu = false;
            animationController.add(true);
          }
        },
        child: _body(),
      ),
    );
  }

  _body() {
    return Stack(
      children: [
        Scaffold(
          appBar: _appBar(),
          body: Padding(
            padding: EdgeInsets.only(
              left: checkPlatformSize(context) ? 65 : 0,
            ),
            child: StreamBuilder(
              stream: controllerInnerStream.stream,
              builder: (context, snapshot) {
                if (snapshot.data == false) {
                  return Container();
                }
                return currentPageWidget;
              },
            ),
          ),
        ),
        StreamBuilder(
          stream: animationController.stream,
          builder: (context, child) {
            return AnimatedPositioned(
              left: checkPlatformSize(context)
                  ? 0
                  : activeMenu
                      ? 0
                      : -65,
              height: MediaQuery.of(context).size.height,
              duration: Duration(milliseconds: animationTime),
              child: AnimatedContainer(
                duration: Duration(milliseconds: animationTime),
                width: activeMenu ? 300 : 65,
                height: 100,
                color: navigationColor,
                child: SideBar(
                  logo: widget.logo,
                  appName: widget.appName,
                  version: widget.appVersion,
                  pages: widget.pages,
                  logoutPage: widget.logoutPage,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  _appBar() {
    return AppBar(
      actions: widget.actionWidgets,
      title: Row(
        children: [
          StreamBuilder(
            stream: animationController.stream,
            builder: (context, child) {
              return AnimatedPadding(
                duration: Duration(milliseconds: animationTime),
                padding: EdgeInsets.only(
                  left: checkPlatformSize(context)
                      ? activeMenu
                          ? 292
                          : 57
                      : activeMenu
                          ? 292
                          : 0,
                  right: 16,
                ),
                child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: textAppBarColor,
                    ),
                    onPressed: () {
                      activeMenu = !activeMenu;
                      animationController.add(true);
                    }),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              _titleComposition(),
              style: TextStyle(color: textAppBarColor),
            ),
          ),
        ],
      ),
      backgroundColor: appBarColor,
    );
  }

  String _titleComposition() {
    double subPageIndex = currentPageIndex % 1;
    String title = '';
    if (currentPageIndex % 1 != 0) {
      title = "${widget.pages[currentPageIndex.round()].title} "
          "- ${widget.pages[currentPageIndex.round()].subMenus[subPageIndex.round()].title}";
    } else {
      title = widget.pages[currentPageIndex.round()].title;
    }
    return title;
  }
}

class ActionMenu {
  static void update() {
    animationController.add(true);
    controllerInnerStream.add(false);
    controllerInnerStream.add(true);
  }

  static getPage() {
    return currentPageIndex;
  }

  static void goTo(double pageIndex) {
    double subPageIndex = pageIndex % 1;
    if (pageIndex % 1 != 0) {
      currentPageWidget =
          globalPages[pageIndex.round()].subMenus[subPageIndex.round()].page;
      currentPageIndex = double.parse("${pageIndex.round()}.$subPageIndex");
      controllerInnerStream.add(true);
      animationController.add(true);
    } else {
      currentPageWidget = globalPages[pageIndex.round()].page;
      currentPageIndex = pageIndex;
      controllerInnerStream.add(true);
      animationController.add(true);
    }
  }
}
