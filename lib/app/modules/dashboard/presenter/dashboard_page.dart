import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:safe_notes/app/modules/dashboard/presenter/pages/drawer_menu_page.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/home/home_page.dart';
import 'pages/drawer_menu_controller.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  final drawerController = Modular.get<DrawerMenuController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DrawerMenuPage(),
          RxBuilder(builder: (_) {
            return AnimatedContainer(
              transform: Matrix4.translationValues(
                drawerController.xOffset.value,
                drawerController.yOffset.value,
                0,
              )
                ..scale(drawerController.scaleFactor.value)
                ..rotateY(drawerController.isShowDrawer.value ? -0.5 : 0.0),
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: () {
                  if (drawerController.isShowDrawer.value) {
                    drawerController.closeDrawer();
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(
                    drawerController.isShowDrawer.value ? 45 : 0,
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
