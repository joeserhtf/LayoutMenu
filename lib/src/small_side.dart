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
  List<NavMenu> get menus => widget.menus;
  bool onSidebar = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: minWithBar,
          height: size.height,
          decoration: BoxDecoration(
            color: navigationColor,
            borderRadius: BorderRadius.only(
              bottomRight: widget.roundBorder ? Radius.circular(6) : Radius.zero,
            ),
          ),
          child: ListView.builder(
            itemCount: menus.length,
            itemBuilder: (context, index) {
              NavMenu menu = menus[index]..menuIndex = index.toDouble();
              return menu.visible ? _simpleMenuIcon(menu) : Container();
            },
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
              width: 135,
              height: size.height,
              child: Stack(
                children: [
                  Positioned(
                    top: subMenuIndex * 64,
                    child: Container(
                      child: _subList(menus[subMenuIndex.toInt()].subMenus),
                    ),
                  )
                ],
              ),
            ),
          )
        }
      ],
    );
  }

  _simpleMenuIcon(NavMenu menu) {
    return Tooltip(
      message: menu.title,
      child: Container(
        width: 5,
        height: 60,
        color: currentPageIndex.toInt() == menu.menuIndex ? selectedColor : navigationColor,
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
                  currentPageWidget = menu.page;
                  currentPageIndex = 0;
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
                  currentPageIndex = menu.menuIndex;
                  currentPageWidget = menu.page;
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
    );
  }

  _subList(List<SubMenu>? submenus) {
    return Container(
      width: 135,
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
            submenus!.asMap().entries.map((e) {
              SubMenu subMenu = e.value..menuIndex = e.key.toDouble();
              return ListTile(
                visualDensity: VisualDensity.compact,
                dense: true,
                onTap: () {
                  activeSubMenu = false;
                  onSidebar = false;
                  currentPageIndex = double.parse("${menus[subMenuIndex.toInt()].menuIndex}.${subMenu.menuIndex}");

                  currentPageWidget = subMenu.page;
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
