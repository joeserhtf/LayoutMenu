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
  int currentPage = 0;
  PageController pageController =
      PageController(initialPage: 0, keepPage: false);

  @override
  void initState() {
    super.initState();
    pagesController = pageController;
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

    pagesController.addListener(() {
      if (pagesController.page.round() != currentPage) {
        setState(() {
          currentPage = pagesController.page.round();
        });
      }
    });
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
                return PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: pagesController,
                  children: [
                    for (int k = 0; k < widget.pages.length; k++)
                      widget.pages[k].subMenus == null
                          ? page(widget.pages[k])
                          : _subList(widget.pages[k], k)
                  ],
                );
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

  Widget page(NavMenu e) {
    subMenusController.add(PageController(initialPage: 0));
    return e.page;
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
                    right: 16),
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
              widget.pages[currentPage].title,
              style: TextStyle(color: textAppBarColor),
            ),
          ),
        ],
      ),
      backgroundColor: appBarColor,
    );
  }

  Widget _subList(NavMenu e, index) {
    subMenusController.add(PageController(initialPage: 0));
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: subMenusController[index],
      children: e.subMenus.map((pag) => pag.page).toList(),
    );
  }
}

class ActionMenu {
  static void update() {
    animationController.add(true);
    controllerInnerStream.add(false);
    controllerInnerStream.add(true);
  }

  static getPage() {
    return pagesController.page;
  }

  static void goTo(int pageIndex) {
    pagesController.jumpToPage(pageIndex);
  }
}
