import 'package:flutter/material.dart';

import 'global.dart';
import 'nav_menu.dart';
import 'side_bar.dart';

class LayoutMenu extends StatefulWidget {
  List<Widget>? actionWidgets;
  List<NavMenu> pages;
  String appName;
  String appVersion;
  Widget logo;
  Widget? actionButton;
  Color? appBarColor;
  Color? navigationColor;
  Color? headerColor;
  Color? textAppBarColor;
  Color? textNavigationColor;
  Color? textHeaderColor;
  Color? selectedColor;
  Widget logoutPage;
  bool onHoverEnter;
  bool onHoverExit;
  bool hasAppBar;
  bool onDragExpand;

  LayoutMenu({
    this.actionWidgets,
    required this.pages,
    required this.appName,
    required this.appVersion,
    required this.logo,
    this.actionButton,
    this.appBarColor,
    this.headerColor,
    this.navigationColor,
    this.textAppBarColor,
    this.textHeaderColor,
    this.textNavigationColor,
    this.selectedColor,
    required this.logoutPage,
    this.onHoverEnter = false,
    this.onHoverExit = true,
    this.onDragExpand = false,
    this.hasAppBar = true,
  });

  @override
  _LayoutMenuState createState() => _LayoutMenuState();
}

class _LayoutMenuState extends State<LayoutMenu> {
  @override
  void initState() {
    super.initState();
    if (widget.appBarColor != null) appBarColor = widget.appBarColor!;
    if (widget.headerColor != null) headerColor = widget.headerColor!;
    if (widget.navigationColor != null) navigationColor = widget.navigationColor!;
    if (widget.textAppBarColor != null) textAppBarColor = widget.textAppBarColor!;
    if (widget.textHeaderColor != null) textHeaderColor = widget.textHeaderColor!;
    if (widget.textNavigationColor != null) textNavigationColor = widget.textNavigationColor!;
    if (widget.selectedColor != null) selectedColor = widget.selectedColor!;

    widget.pages.add(
      NavMenu(
        icon: Icon(Icons.exit_to_app),
        visible: true,
        title: 'Logout',
        page: widget.logoutPage,
        subMenus: null,
      )..isLogout = true,
    );

    currentPageWidget = widget.pages[0].page;

    globalPages = widget.pages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.actionButton,
      drawerScrimColor: Colors.transparent,
      body: GestureDetector(
        onHorizontalDragEnd: widget.onDragExpand
            ? (mov) {
                if (mov.primaryVelocity! > 0) {
                  activeMenu = true;
                  animationController.add(true);
                } else {
                  activeMenu = false;
                  animationController.add(true);
                }
              }
            : null,
        child: _body(),
      ),
    );
  }

  _body() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: checkPlatformSize(context) ? 65 : 0,
            top: widget.hasAppBar ? kToolbarHeight : 0.0,
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
        StreamBuilder(
          stream: animationController.stream,
          builder: (context, child) {
            return AnimatedContainer(
              duration: Duration(milliseconds: animationTime),
              child: SideBar(
                logo: widget.logo,
                appName: widget.appName,
                version: widget.appVersion,
                pages: widget.pages,
                logoutPage: widget.logoutPage,
                hasAppBar: widget.hasAppBar,
                onHoverExit: widget.onHoverExit,
                onHoverEnter: widget.onHoverEnter,
              ),
            );
          },
        ),
      ],
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
    return currentPageIndex;
  }

  static void goTo(double pageIndex) {
    double subPageIndex = pageIndex % 1;
    if (pageIndex % 1 != 0) {
      currentPageWidget = globalPages![pageIndex.round()].subMenus![((subPageIndex * 10).round() - 1)].page;
      currentPageIndex = double.parse("${pageIndex.round()}.${((subPageIndex * 10).round() - 1)}");
      controllerInnerStream.add(true);
      animationController.add(true);
    } else {
      currentPageWidget = globalPages![pageIndex.round()].page;
      currentPageIndex = pageIndex;
      controllerInnerStream.add(true);
      animationController.add(true);
    }
  }
}
