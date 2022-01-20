import 'package:flutter/material.dart';
import 'package:layoutmenu/src/global.dart';
import 'package:layoutmenu/src/nav_menu.dart';

class ExpandedSide extends StatefulWidget {
  final List<NavMenu> menus;

  const ExpandedSide({Key? key, required this.menus}) : super(key: key);

  @override
  _ExpandedSideState createState() => _ExpandedSideState();
}

class _ExpandedSideState extends State<ExpandedSide> {
  List<NavMenu> get menus => widget.menus;
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: navigationColor,
      child: ListView.builder(
        itemCount: menus.length,
        itemBuilder: (BuildContext context, int index) {
          NavMenu menu = menus[index]..menuIndex = index.toDouble();
          bool selected = selectedIndex == index;
          if (menu.subMenus == null) {
            return ListTile(
              onTap: () {
                currentPageIndex = index.toDouble();
                currentPageWidget = menu.page;
                controllerInnerStream.add(true);
                animationController.add(true);
                activeMenu = false;

                if (menu.function != null) {
                  menu.function!();
                }
              },
              leading: menu.icon,
              title: Text(
                menu.title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
          return ExpansionTile(
            onExpansionChanged: (z) {
              setState(() {
                selectedIndex = z ? index : -1;
              });
            },
            leading: menu.icon,
            initiallyExpanded: currentPageIndex.toInt() == menu.menuIndex.toInt(),
            title: Text(
              menu.title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              selected ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: selected ? Colors.white : Colors.white70,
            ),
            children: menu.subMenus!.asMap().entries.map((e) {
              return _subMenuButton(
                e.value..menuIndex = e.key.toDouble(),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _subMenuButton(SubMenu subMenu) {
    print(subMenu.menuIndex);
    return ListTile(
      visualDensity: VisualDensity.compact,
      dense: true,
      onTap: () {
        currentPageIndex = double.parse("${menus[selectedIndex].menuIndex}.${subMenu.menuIndex}");
        activeMenu = false;
        activeSubMenu = false;
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
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
