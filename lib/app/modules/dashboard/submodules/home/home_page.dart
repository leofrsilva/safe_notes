import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../presenter/pages/drawer_menu_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final drawerController = Modular.get<DrawerMenuController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todas as Notas',
          style: TextStyle(
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: ValueListenableBuilder<bool>(
            valueListenable: drawerController.isShowDrawer,
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(
                  value ? Icons.arrow_back : Icons.menu,
                  size: 26,
                ),
                onPressed: () {
                  if (value) {
                    drawerController.closeDrawer();
                  } else {
                    FocusScope.of(context).unfocus();
                    drawerController.openDrawer();
                  }
                },
              );
            }),
      ),
      body: Container(),
    );
  }
}
