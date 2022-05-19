import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../pages/drawer/drawer_menu_controller.dart';

mixin TemplatePageMixin<T extends StatefulWidget> on State<T> {
  String title = '';

  Widget body = Container();
  Widget? floatingActionButton;

  List<Widget> actionsIcon = [];

  late DrawerMenuController drawerMenu;

  @override
  void initState() {
    super.initState();
    drawerMenu = Modular.get<DrawerMenuController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: ValueListenableBuilder<bool>(
          valueListenable: drawerMenu.isShowDrawer,
          builder: (context, value, child) {
            return IconButton(
              icon: Icon(
                value ? Icons.arrow_back : Icons.menu,
                size: 26,
              ),
              onPressed: () {
                if (value) {
                  drawerMenu.closeDrawer();
                } else {
                  FocusScope.of(context).unfocus();
                  drawerMenu.openDrawer();
                }
              },
            );
          },
        ),
        actions: actionsIcon,
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
