import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layoutmenu/src/nav_page.dart';
import 'package:layoutmenu/src/utils/accents_remover.dart';

import 'global.dart';
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
  final NavPage? loginPage;
  final bool onHoverEnter;
  final bool onHoverExit;
  final bool hasAppBar;
  final bool onDragExpand;
  final double? floatWidth;
  final bool needsAuth;
  final Widget? unknownPage;
  final ThemeData? themeData;

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
    this.loginPage,
    this.onHoverEnter = false,
    this.onHoverExit = true,
    this.onDragExpand = false,
    this.hasAppBar = true,
    this.floatWidth,
    this.needsAuth = false,
    this.unknownPage,
    this.themeData,
  });

  @override
  _LayoutMenuState createState() => _LayoutMenuState();
}

class _LayoutMenuState extends State<LayoutMenu> {
  List<GoRoute> routes = [];

  @override
  void initState() {
    super.initState();
    _checkAndConfig();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: globalRouter.routeInformationParser,
      routerDelegate: globalRouter.routerDelegate,
      theme: widget.themeData,
      title: widget.appName,
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
    if (widget.loginPage != null) logOutPage = widget.loginPage!..isLogout = true;
    if (widget.floatWidth != null) floatMenuWidth = widget.floatWidth!;

    routes.add(
      GoRoute(
        path: '/',
        redirect: (_) {
          return (widget.loginPage != null
                  ? widget.loginPage?.path ?? '/login'
                  : "/${widget.pages[0].path ?? widget.pages[0].title}")
              .withoutDiacriticalMarks
              .replaceAll(' ', '')
              .toLowerCase();
        },
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: widget.pages[0].page,
        ),
      ),
    );

    if (widget.loginPage != null) {
      routes.add(
        GoRoute(
          path: widget.loginPage?.path ?? '/login',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: widget.loginPage!.page,
          ),
        ),
      );
    }

    widget.pages.asMap().entries.forEach((menu) {
      String path = "/${menu.value.path ?? menu.value.title}".withoutDiacriticalMarks.replaceAll(' ', '').toLowerCase();

      List<GoRoute> subPaths = [];

      menu.value.subMenus?.asMap().entries.forEach((subMenu) {
        subMenu.value..menuIndex = subMenu.key.toDouble();
        String subPath =
            "${subMenu.value.path ?? subMenu.value.title}".withoutDiacriticalMarks.replaceAll(' ', '').toLowerCase();
        subPaths.add(
          GoRoute(
            path: subPath,
            pageBuilder: (context, state) => NoTransitionPage<void>(
              key: state.pageKey,
              child: subMenu.value.page,
            ),
          ),
        );
      });

      GoRoute confRout = GoRoute(
        path: path,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: menu.value.page,
        ),
        routes: subPaths,
      );

      menu.value..isLogout = false;
      menu.value..menuIndex = menu.key.toDouble();

      routes.add(confRout);
    });

    globalRouter = GoRouter(
      routes: routes,
      errorBuilder: widget.unknownPage == null ? null : (_, __) => widget.unknownPage!,
      redirect: (state) {
        if (state.location != '/login' && !isAuthenticated && widget.needsAuth) return '/login';
        return null;
      },
      navigatorBuilder: (context, state, child) {
        if (state.location == '/login' || state.error != null) return child;
        return LayoutBuilder(
          actionWidgets: widget.actionWidgets,
          pages: widget.pages,
          initialPageKey: widget.initialPageKey,
          appName: widget.appName,
          appVersion: widget.appVersion,
          logo: widget.logo,
          actionButton: widget.actionButton,
          backgroundColor: widget.backgroundColor,
          appBarColor: widget.appBarColor,
          navigationColor: widget.navigationColor,
          headerColor: widget.headerColor,
          textAppBarColor: widget.textAppBarColor,
          textNavigationColor: widget.textNavigationColor,
          textHeaderColor: widget.textHeaderColor,
          selectedColor: widget.selectedColor,
          logoutNav: widget.loginPage,
          onHoverEnter: widget.onHoverEnter,
          onHoverExit: widget.onHoverExit,
          hasAppBar: widget.hasAppBar,
          onDragExpand: widget.onDragExpand,
          floatWidth: widget.floatWidth,
          currentPage: child,
        );
      },
    );

    globalPages = widget.pages;
  }
}

class LayoutBuilder extends StatefulWidget {
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
  final Widget currentPage;

  LayoutBuilder({
    Key? key,
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
    required this.currentPage,
  }) : super(key: key);

  @override
  State<LayoutBuilder> createState() => _LayoutBuilderState();
}

class _LayoutBuilderState extends State<LayoutBuilder> {
  List<NavPage> emptyList = [];

  Widget get currentPage => widget.currentPage;

  @override
  void initState() {
    super.initState();
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
        child: _builderPages(),
      ),
    );
  }

  _builderPages() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: isLargeScreen(context) ? minWidthBar : 0,
            top: widget.hasAppBar ? kToolbarHeight : 0.0,
          ),
          child: currentPage,
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
                pages: globalPages ?? emptyList,
                hasAppBar: widget.hasAppBar,
                onHoverExit: widget.onHoverExit,
                onHoverEnter: widget.onHoverEnter,
                actionWidgets: widget.actionWidgets,
                currentPage: widget.currentPage,
              ),
            );
          },
        ),
      ],
    );
  }

  void _checkLogOutButton() {
    if (widget.logoutNav != null && globalPages?.indexWhere((element) => element.isLogout) == -1) {
      logOutOnScroll = MediaQuery.of(context).size.height < widget.pages.length * 64;
      if (logOutOnScroll) globalPages?.add(widget.logoutNav!);
    }
  }
}

class ActionMenu {
  static void goTo(String path) {
    globalRouter.routerDelegate.go(path);
  }

  static String currentPath() {
    return globalRouter.routerDelegate.location;
  }

  static void setLogged() {
    isAuthenticated = true;
  }

  static isLogged() => isAuthenticated;

  static void logout() {
    isAuthenticated = false;
  }
}
