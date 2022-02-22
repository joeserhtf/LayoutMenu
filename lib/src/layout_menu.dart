import 'dart:async';

import 'package:flutter/material.dart';

import 'global.dart';
import 'nav_page.dart';
import 'side_bar.dart';

class LayoutMenu extends StatefulWidget {
  final List<Widget>? actionWidgets;
  final List<NavPage> pages;
  final String? initialPageKey;
  final String appName;
  final String appVersion;
  final Widget logo;
  final Widget? actionButton;
  final Color? backgroundColor;
  final Color? appBarColor;
  final Color? navigationColor;
  final Color? headerColor;
  final Color? textAppBarColor;
  final Color? textNavigationColor;
  final Color? textHeaderColor;
  final Color? selectedColor;
  final NavPage? logoutNav;
  final bool onHoverEnter;
  final bool onHoverExit;
  final bool hasAppBar;
  final bool onDragExpand;
  final double? floatWidth;

  LayoutMenu({
    this.actionWidgets,
    required this.pages,
    required this.appName,
    required this.appVersion,
    required this.logo,
    this.backgroundColor,
    this.initialPageKey,
    this.actionButton,
    this.appBarColor,
    this.headerColor,
    this.navigationColor,
    this.textAppBarColor,
    this.textHeaderColor,
    this.textNavigationColor,
    this.selectedColor,
    this.logoutNav,
    this.onHoverEnter = false,
    this.onHoverExit = true,
    this.onDragExpand = false,
    this.hasAppBar = true,
    this.floatWidth,
  });

  @override
  _LayoutMenuState createState() => _LayoutMenuState();
}

class _LayoutMenuState extends State<LayoutMenu> {
  @override
  void initState() {
    super.initState();
    _checkAndConfig();
    controllerInnerStream = StreamController();
  }

  @override
  Widget build(BuildContext context) {
    _checkLogOutButton();
    return Scaffold(
      floatingActionButton: widget.actionButton,
      drawerScrimColor: Colors.transparent,
      backgroundColor: widget.backgroundColor ?? Colors.transparent,
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
            left: isLargeScreen(context) ? minWidthBar : 0,
            top: widget.hasAppBar ? kToolbarHeight : 0.0,
          ),
          child: StreamBuilder(
            stream: controllerInnerStream.stream,
            builder: (context, snapshot) {
              if (snapshot.data == false) {
                return Container();
              }

              return currentPage.activeSubMenu?.page ?? currentPage.page;
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
                pages: globalPages?.cast<NavPage>() ?? [],
                hasAppBar: widget.hasAppBar,
                onHoverExit: widget.onHoverExit,
                onHoverEnter: widget.onHoverEnter,
                actionWidgets: widget.actionWidgets,
              ),
            );
          },
        ),
      ],
    );
  }

  void _checkAndConfig() {
    if (widget.appBarColor != null) appBarColor = widget.appBarColor!;
    if (widget.headerColor != null) headerColor = widget.headerColor!;
    if (widget.navigationColor != null) navigationColor = widget.navigationColor!;
    if (widget.textAppBarColor != null) textAppBarColor = widget.textAppBarColor!;
    if (widget.textHeaderColor != null) textHeaderColor = widget.textHeaderColor!;
    if (widget.textNavigationColor != null) textNavigationColor = widget.textNavigationColor!;
    if (widget.selectedColor != null) selectedColor = widget.selectedColor!;
    if (widget.logoutNav != null) logOutPage = widget.logoutNav!..isLogout = true;
    if (widget.floatWidth != null) floatMenuWidth = widget.floatWidth!;

    NavPage? hasInitialPage;

    widget.pages.asMap().entries.forEach((menu) {
      menu.value..isLogout = false;
      menu.value..menuIndex = menu.key.toDouble();
      if (menu.value.key == widget.initialPageKey) {
        hasInitialPage = menu.value;
      }
      menu.value.subMenus?.asMap().entries.forEach((subMenu) {
        subMenu.value..menuIndex = subMenu.key.toDouble();
        if (subMenu.value.key == widget.initialPageKey) {
          hasInitialPage = NavPage.copy(menu.value)..activeSubMenu = subMenu.value;
        }
      });
    });

    currentPage = hasInitialPage ?? widget.pages[0];

    initialPage = currentPage;

    globalPages = widget.pages;
  }

  void _checkLogOutButton() {
    if (mounted && widget.logoutNav != null && globalPages?.indexWhere((element) => element!.isLogout) == -1) {
      logOutOnScroll = MediaQuery.of(context).size.height < widget.pages.length * 64;
      if (logOutOnScroll) globalPages?.add(widget.logoutNav);
    }
  }
}

class ActionMenu {
  static void update() {
    animationController.add(true);
    controllerInnerStream.add(false);
    controllerInnerStream.add(true);
  }

  static getPage() {
    return currentPage;
  }

  static void goTo(String pageKey) {
    NavPage? toPage;

    for (NavPage? page in globalPages ?? []) {
      if (page?.key == pageKey && !page!.isLogout) {
        toPage = NavPage.copy(page);
        break;
      }
    }

    if (toPage == null) {
      for (NavPage? mainPage in globalPages ?? []) {
        if (mainPage!.subMenus != null && mainPage.subMenus!.isNotEmpty) {
          for (SubPage element in mainPage.subMenus!) {
            if (element.key == pageKey) {
              toPage = NavPage.copy(mainPage)..activeSubMenu = element;
              break;
            }
          }
        }
        if (toPage != null) break;
      }
    }

    if (toPage != null) {
      currentPage = toPage;
      controllerInnerStream.add(true);
      animationController.add(true);
    } else {
      print("Page Id Not Found");
    }
  }
}
