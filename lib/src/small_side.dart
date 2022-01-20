import 'package:flutter/material.dart';
import 'package:layoutmenu/src/global.dart';
import 'package:layoutmenu/src/nav_menu.dart';

class SmallSideBar extends StatefulWidget {
  final List<NavMenu> menus;

  const SmallSideBar({Key? key, required this.menus}) : super(key: key);

  @override
  _SmallSideBarState createState() => _SmallSideBarState();
}

class _SmallSideBarState extends State<SmallSideBar> {
  List<NavMenu> get menus => widget.menus;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 65,
          height: size.height,
          color: navigationColor,
          child: ListView.builder(
            itemCount: menus.length,
            itemBuilder: (context, index) {
              NavMenu menu = menus[index]..menuIndex = index.toDouble();
              return menu.visible ? _simpleMenuIcon(menu) : Container();
            },
          ),
        ),
        if (activeSubMenu) ...{
          Container(
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
                fontSize: 21,
                color: Colors.white,
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
                        fontSize: 14,
                        color: Colors.white,
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
