import 'package:flutter/material.dart';
import 'package:layoutmenu/src/app_bar.dart';
import 'package:layoutmenu/src/expanded_side.dart';
import 'package:layoutmenu/src/small_side.dart';

import '../layout.dart';
import 'global.dart';

class SideBar extends StatefulWidget {
  Widget logo;
  String appName;
  String? version;
  List<NavMenu> pages;
  Widget logoutPage;
  bool hasAppBar;
  bool onHoverEnter;
  bool onHoverExit;

  SideBar({
    required this.logo,
    required this.appName,
    required this.pages,
    this.version,
    required this.logoutPage,
    required this.hasAppBar,
    required this.onHoverEnter,
    required this.onHoverExit,
  });

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  List<NavMenu> get pages => widget.pages;

  @override
  Widget build(BuildContext context) {
    return _listMenus();
  }

  _listMenus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _leadingSideBar(),
            if (widget.hasAppBar) ...{
              Expanded(
                  child: CustomAppBar(
                pages: widget.pages,
                actionWidgets: [],
              )),
            }
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 300,
            minWidth: 65,
            //TODO creat variables
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
            maxHeight: MediaQuery.of(context).size.height - kToolbarHeight,
          ),
          child: _menu(),
        ),
      ],
    );
  }

  _leadingSideBar() {
    return Container(
      width: activeMenu ? 300 : 65,
      child: Card(
        color: headerColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Container(
          height: kToolbarHeight,
          alignment: Alignment.center,
          color: headerColor,
          //Todo check checkPlatformSize
          child: checkPlatformSize(context) && activeMenu == false
              ? Center(
                  child: widget.logo,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      'Versão: ' + (widget.version ?? 'Deconhecida'),
                      style: TextStyle(
                        fontSize: 11,
                        color: textHeaderColor,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _menu() {
    if (activeMenu) {
      return MouseRegion(
        //Todo new bool to separate enter and exit
        onExit: widget.onHoverExit
            ? (__) {
                activeMenu = false;
                animationController.add(true);
              }
            : null,
        child: ExpandedSide(menus: pages),
      );
    } else {
      return MouseRegion(
        onEnter: widget.onHoverEnter
            ? (__) {
                activeMenu = true;
                animationController.add(true);
              }
            : null,
        child: SmallSideBar(menus: pages),
      );
    }
  }
}
