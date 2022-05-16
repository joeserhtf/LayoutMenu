import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layoutmenu/src/current_page.dart';
import 'package:layoutmenu/src/nav_page.dart';
import 'package:layoutmenu/src/utils/accents_remover.dart';

import 'global.dart';
import 'side_bar.dart';

late GoRouter _router;
late BuildContext gContext;

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
  List<GoRoute> routes = [];

  @override
  void initState() {
    super.initState();
    _checkAndConfig();
  }

  @override
  Widget build(BuildContext context) {
    gContext = context;
    return MaterialApp.router(
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
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
    if (widget.logoutNav != null) logOutPage = widget.logoutNav!..isLogout = true;
    if (widget.floatWidth != null) floatMenuWidth = widget.floatWidth!;

    LayoutBuilder body = LayoutBuilder(
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
      logoutNav: widget.logoutNav,
      onHoverEnter: widget.onHoverEnter,
      onHoverExit: widget.onHoverExit,
      hasAppBar: widget.hasAppBar,
      onDragExpand: widget.onDragExpand,
      floatWidth: widget.floatWidth,
      currentPage: CurrentPage('/', Container(), 'Main', 0),
    );

    routes.add(
      GoRoute(
        path: '/',
        redirect: (_) => "/${widget.pages[0].path ?? widget.pages[0].title}"
            .withoutDiacriticalMarks
            .replaceAll(' ', '')
            .toLowerCase(),
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: body,
        ),
      ),
    );

    if (widget.logoutNav != null) {
      routes.add(
        GoRoute(
          path: '/login',
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: widget.logoutNav!.page,
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
              child: body
                ..currentPage = CurrentPage(
                  subPath,
                  subMenu.value.page,
                  "${menu.value.title} - ${subMenu.value.title}",
                  double.parse("${menu.key.toDouble()}.${subMenu.key.toDouble()}"),
                ),
            ),
          ),
        );
      });

      GoRoute confRout = GoRoute(
        path: path,
        pageBuilder: (context, state) => NoTransitionPage<void>(
          key: state.pageKey,
          child: body
            ..currentPage = CurrentPage(
              path,
              menu.value.page,
              "${menu.value.title}",
              menu.key.toDouble(),
            ),
        ),
        routes: subPaths,
      );

      menu.value..isLogout = false;
      menu.value..menuIndex = menu.key.toDouble();

      routes.add(confRout);
    });

    _router = GoRouter(routes: routes);

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
  CurrentPage currentPage;

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

  CurrentPage get currentPage => widget.currentPage;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _checkLogOutButton(context);
    return _body(context);
  }

  _body(context) {
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
        child: _builderPages(context),
      ),
    );
  }

  _builderPages(context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: isLargeScreen(context) ? minWidthBar : 0,
            top: widget.hasAppBar ? kToolbarHeight : 0.0,
          ),
          child: currentPage.page,
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

  void _checkLogOutButton(context) {
    if (widget.logoutNav != null && globalPages?.indexWhere((element) => element.isLogout) == -1) {
      logOutOnScroll = MediaQuery.of(context).size.height < widget.pages.length * 64;
      if (logOutOnScroll) globalPages?.add(widget.logoutNav!);
    }
  }
}

class ActionMenu {
  static void goTo(String path) {
    gContext.go("/login");
  }
}
