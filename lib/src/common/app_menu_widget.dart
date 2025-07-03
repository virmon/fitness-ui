import 'package:flutter/material.dart';

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
  const AppMenuWidget({super.key, required this.menuItems});
  final List<MenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          child: Visibility(
            visible: menuItems.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ...menuItems.map(
                    (item) => SizedBox(
                      height: 64,
                      child: ListTile(
                        leading: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Icon(item.icon),
                        ),
                        title: Text(item.title),
                        onTap: item.callback,
                      ),
                    ),
                  ),
                  SizedBox(height: 24)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
