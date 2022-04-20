import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../presenter/pages/drawer_menu_page.dart';
import 'pages/drawer_menu_controller.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  final drawerMenuController = Modular.get<DrawerMenuController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerMenuPage(),
          RxBuilder(builder: (_) {
            return AnimatedContainer(
              transform: Matrix4.translationValues(
                drawerMenuController.xOffset.value,
                drawerMenuController.yOffset.value,
                0,
              )
                ..scale(drawerMenuController.scaleFactor.value)
                ..rotateY(drawerMenuController.isShowDrawer.value ? -0.5 : 0.0),
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: () {
                  if (drawerMenuController.isShowDrawer.value) {
                    drawerMenuController.closeDrawer();
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(
                    drawerMenuController.isShowDrawer.value ? 45 : 0,
                  )),
                  child: const RouterOutlet(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
