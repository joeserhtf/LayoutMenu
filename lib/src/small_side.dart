import 'package:flutter/material.dart';
import 'package:layoutmenu/src/global.dart';
import 'package:layoutmenu/src/nav_menu.dart';
import 'package:layoutmenu/src/utils/media_query.dart';

class SmallSideBar extends StatefulWidget {
  final List<NavMenu> menus;
  final bool roundBorder;

  const SmallSideBar({
    Key? key,
    required this.menus,
    this.roundBorder = false,
  }) : super(key: key);

  @override
  _SmallSideBarState createState() => _SmallSideBarState();
}

class _SmallSideBarState extends State<SmallSideBar> {
  double mousePosition = 64;

  List<NavMenu> get menus => widget.menus;
  bool onSidebar = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: minWidthBar,
          height: size.height,
          decoration: BoxDecoration(
            color: navigationColor,
            borderRadius: BorderRadius.only(
              bottomRight: widget.roundBorder ? Radius.circular(6) : Radius.zero,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Stack(
              children: [
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: menus.length,
                  itemBuilder: (context, index) => menus[index].visible
                      ? menus[index].isLogout
                          ? _simpleMenuIcon(logOutPage!)
                          : _simpleMenuIcon(menus[index])
                      : Container(),
                ),
                if (logOutPage != null && !logOutOnScroll) ...{
                  Positioned(
                    width: minWidthBar,
                    bottom: 0,
                    child: _simpleMenuIcon(logOutPage!),
                  )
                },
              ],
            ),
          ),
        ),
        if (activeSubMenu) ...{
          MouseRegion(
            onEnter: (_) {
              onSidebar = true;
            },
            onExit: (_) {
              if (onSidebar) {
                onSidebar = false;
                activeSubMenu = false;
                animationController.add(true);
              }
            },
            child: Container(
              width: floatMenuWidth,
              height: size.height,
              child: Stack(
                children: [
                  Positioned(
                    top: _positionCalc(size, true),
                    bottom: _positionCalc(size, false),
                    child: _subList(menus[subMenuIndex.toInt()].subMenus),
                  )
                ],
              ),
            ),
          )
        }
      ],
    );
  }

  _positionCalc(Size size, bool istTop) {
    return ((mousePosition.round() * 60) -
                kToolbarHeight +
                (50 + (menus[subMenuIndex.toInt()].subMenus!.length * 50))) >
            size.height
        ? istTop
            ? null
            : 0
        : istTop
            ? ((mousePosition.round() * 60) - kToolbarHeight)
            : null;
  }

  _simpleMenuIcon(NavMenu menu) {
    return MouseRegion(
      onHover: (details) {
        mousePosition = details.position.dy / 64;
      },
      child: Tooltip(
        message: menu.title,
        child: Container(
          height: 60,
          color: currentPage.menuIndex == menu.menuIndex ? selectedColor : navigationColor,
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
                  child: menu.icon,
                ),
              ),
              onTap: () {
                if (menu.subMenus != null) {
                  activeSubMenu = !activeSubMenu;
                  subMenuIndex = menu.menuIndex;
                  animationController.add(true);
                } else {
                  if (menu.isLogout) {
                    currentPage = initialPage;
                    activeSubMenu = false;
                    onSidebar = false;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => menu.page,
                      ),
                    );
                  } else {
                    activeSubMenu = false;
                    currentPage = menu;
                    controllerInnerStream.add(true);
                    animationController.add(true);
                  }

                  if (menu.function != null) {
                    menu.function!();
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  _subList(List<SubMenu>? submenus) {
    return Container(
      width: floatMenuWidth,
      decoration: BoxDecoration(
        color: navigationColor.withOpacity(0.7),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              menus[subMenuIndex.toInt()].title,
              style: TextStyle(
                fontSize: mediaQuery(context, 0.015).clamp(16, 18),
                color: textNavigationColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ]..addAll(
            submenus!.map((subMenu) {
              return ListTile(
                visualDensity: VisualDensity.compact,
                dense: true,
                onTap: () {
                  activeSubMenu = false;
                  onSidebar = false;

                  currentPage = NavMenu.copy(menus[subMenuIndex.toInt()])..activeSubMenu = subMenu;

                  controllerInnerStream.add(true);
                  animationController.add(true);

                  if (subMenu.function != null) {
                    subMenu.function!();
                  }
                },
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      subMenu.title,
                      style: TextStyle(
                        fontSize: mediaQuery(context, 0.015).clamp(12, 14),
                        color: textNavigationColor,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
      ),
    );
  }
}
