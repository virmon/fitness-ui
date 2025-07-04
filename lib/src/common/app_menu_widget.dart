import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Usage:
// declare a list of menu items List<MenuItem>:
// example:
// List<MenuItem> menuList = [MenuItem(title: <String>, icon: <IconData>, callback: <GestureTapCallback>), ...];
//
// Then pass the menuList to AppMenuWidget(menuItems: menuList)
// example usage in showModalBottomSheet:
// showModalBottomSheet(
//   context: context,
//   builder: (BuildContext context) {
//     return AppMenuWidget(menuItems: menuList);
// });

class MenuItem {
  MenuItem(this.title, this.icon, this.callback);
  final String title;
  final IconData icon;
  final GestureTapCallback callback;
}

class AppMenuWidget extends StatelessWidget {
  const AppMenuWidget({
    super.key,
    required this.menuItems,
    this.shouldCloseOnTap = true,
  });
  final List<MenuItem> menuItems;
  final bool shouldCloseOnTap;

  @override
  Widget build(BuildContext context) {
    final double bottomSpaceHeight = 28.0;
    final double iconSpacing = 10.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: Visibility(
            visible: menuItems.isNotEmpty,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...menuItems.map(
                  (menuItem) => SizedBox(
                    child: ListTile(
                      leading: Padding(
                        padding: EdgeInsets.only(
                          left: iconSpacing,
                          right: iconSpacing,
                        ),
                        child: Icon(menuItem.icon),
                      ),
                      title: Text(menuItem.title),
                      onTap: () {
                        if (shouldCloseOnTap) {
                          context.pop();
                        }
                        menuItem.callback();
                      },
                    ),
                  ),
                ),
                SizedBox(height: bottomSpaceHeight),
              ],
            ),
          ),
        )
      ],
    );
  }
}
