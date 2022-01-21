import 'package:flutter/material.dart';
import 'package:layoutmenu/layout.dart';
import 'package:layoutmenu/src/app_bar.dart';
import 'package:layoutmenu/src/expanded_side.dart';
import 'package:layoutmenu/src/global.dart';
import 'package:layoutmenu/src/small_side.dart';
import 'package:layoutmenu/src/utils/media_query.dart';

class SideBar extends StatefulWidget {
  final Widget logo;
  final String appName;
  final String? version;
  final List<NavPage> pages;
  final bool hasAppBar;
  final bool onHoverEnter;
  final bool onHoverExit;
  final actionWidgets;

  SideBar({
    required this.logo,
    required this.appName,
    required this.pages,
    required this.actionWidgets,
    this.version,
    required this.hasAppBar,
    required this.onHoverEnter,
    required this.onHoverExit,
  });

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  List<NavPage> get pages => widget.pages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: !widget.hasAppBar ? const EdgeInsets.symmetric(vertical: 1) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _leadingSideBar(),
              if (widget.hasAppBar) ...{
                Expanded(
                    child: CustomAppBar(
                  pages: pages,
                  actionWidgets: widget.actionWidgets ?? [],
                )),
              }
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidthBar,
              minWidth: minWidthBar,
              minHeight: MediaQuery.of(context).size.height - (kToolbarHeight + (!widget.hasAppBar ? 2 : 0)),
              maxHeight: (MediaQuery.of(context).size.height - (kToolbarHeight + (!widget.hasAppBar ? 2 : 0))),
            ),
            child: _menu(),
          ),
        ],
      ),
    );
  }

  _leadingSideBar() {
    return Container(
      width: activeMenu ? maxWidthBar : minWidthBar,
      child: Card(
        color: headerColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: !widget.hasAppBar ? Radius.circular(6) : Radius.zero,
          ),
        ),
        child: Container(
          height: kToolbarHeight,
          alignment: Alignment.center,
          child: !isLargeScreen(context) || activeMenu == false
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
                        fontWeight: FontWeight.w600,
                        color: textHeaderColor,
                      ),
                    ),
                    Text(
                      'Versão: ' + (widget.version ?? 'Deconhecida'),
                      style: TextStyle(
                        fontSize: mediaQuery(context, 0.01).clamp(11, 16),
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
        onExit: widget.onHoverExit
            ? (__) {
                activeMenu = false;
                animationController.add(true);
              }
            : null,
        child: ExpandedSide(
          menus: pages,
        ),
      );
    } else {
      return MouseRegion(
        onEnter: widget.onHoverEnter
            ? (__) {
                activeMenu = true;
                animationController.add(true);
              }
            : null,
        child: SmallSideBar(
          menus: pages,
          roundBorder: !widget.hasAppBar,
        ),
      );
    }
  }
}
