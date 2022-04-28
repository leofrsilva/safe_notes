import 'package:flutter/material.dart';

import '../pages/drawer/drawer_menu_controller.dart';

mixin TemplatePageMixin<T extends StatefulWidget> on State<T> {
  String title = '';

  Widget body = Container();

  List<Widget> actionsIcon = [];

  DrawerMenuController? drawerController;

  @override
  Widget build(BuildContext context) {
    if (drawerController == null) return body;

    final background = Theme.of(context).backgroundColor;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        leading: ValueListenableBuilder<bool>(
          valueListenable: drawerController!.isShowDrawer,
          builder: (context, value, child) {
            return IconButton(
              icon: Icon(
                value ? Icons.arrow_back : Icons.menu,
                color: Theme.of(context).primaryColor,
                size: 26,
              ),
              onPressed: () {
                if (value) {
                  drawerController!.closeDrawer();
                } else {
                  FocusScope.of(context).unfocus();
                  drawerController!.openDrawer();
                }
              },
            );
          },
        ),
        actions: actionsIcon,
      ),
      body: body,
    );
  }
}
