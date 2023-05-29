import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:layoutmenu/src/global.dart';
import 'package:layoutmenu/src/nav_page.dart';
import 'package:layoutmenu/src/utils/accents_remover.dart';
import 'package:layoutmenu/src/utils/media_query.dart';

class ExpandedSide extends StatefulWidget {
  final List<NavPage> menus;

  const ExpandedSide({Key? key, required this.menus}) : super(key: key);

  @override
  _ExpandedSideState createState() => _ExpandedSideState();
}

class _ExpandedSideState extends State<ExpandedSide> {
  List<NavPage> get menus => widget.menus;
  int selectedIndex = 1; //TODO currentPage.menuIndex.toInt();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidthBar,
      color: navigationColor,
      child: Stack(
        children: [
          ListView.builder(
            itemCount: menus.length,
            itemBuilder: (BuildContext context, int index) {
              NavPage menu = menus[index];
              if (menu.visible) {
                if (menu.subMenus == null) {
                  return _tileNavPage(menu);
                }
                return _expansionNavPage(menu);
              } else {
                return Container();
              }
            },
          ),
          if (logOutPage != null && !logOutOnScroll) ...{
            Positioned(width: maxWidthBar, bottom: 0, child: _tileNavPage(logOutPage!))
          },
        ],
      ),
    );
  }

  _tileNavPage(NavPage menu) {
    return ListTile(
      onTap: () {
        if (menu.isLogout) {
          activeSubMenu = false;
          activeMenu = false;
          isAuthenticated = false;
          context.pushReplacement("/login");
        } else {
          animationController.add(true);
          activeMenu = false;
          context.push("/${menu.path.toString()}".withoutDiacriticalMarks.replaceAll(' ', '').toLowerCase());

          if (menu.function != null) {
            menu.function!();
          }
        }
      },
      leading: menu.icon,
      title: Text(
        menu.title,
        style: TextStyle(
          color: textNavigationColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _expansionNavPage(NavPage menu) {
    bool selected = globalRouter.location
        .contains("/${menu.path ?? menu.title}".withoutDiacriticalMarks.replaceAll(' ', '').toLowerCase());
    ;
    return ExpansionTile(
      onExpansionChanged: (z) {
        setState(() {
          selectedIndex = z ? menu.menuIndex.toInt() : -1;
        });
      },
      leading: menu.icon,
      initiallyExpanded: false, //TODO currentPage.menuIndex == menu.menuIndex,
      title: Text(
        menu.title,
        style: TextStyle(
          color: textNavigationColor,
          fontSize: mediaQuery(context, 0.015).clamp(14, 17),
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        selected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: selected ? Colors.white : Colors.white70,
      ),
      children: menu.subMenus!.map((e) {
        return _subMenuButton(e, menu);
      }).toList(),
    );
  }

  Widget _subMenuButton(SubPage subMenu, NavPage menu) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      dense: true,
      onTap: () {
        activeMenu = false;
        activeSubMenu = false;

        context.go(
          "/${menu.path ?? menu.title}/${subMenu.path ?? subMenu.title}"
              .withoutDiacriticalMarks
              .replaceAll(' ', '')
              .toLowerCase(),
        );

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
            style: TextStyle(fontSize: mediaQuery(context, 0.015).clamp(12, 15), color: textNavigationColor),
          ),
        ),
      ),
    );
  }
}
