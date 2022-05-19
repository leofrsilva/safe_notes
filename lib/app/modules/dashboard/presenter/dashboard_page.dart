import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'pages/drawer/drawer_menu_page.dart';
import 'pages/drawer/drawer_menu_controller.dart';
import 'widgets/clip_view_port.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  final drawerMenuController = Modular.get<DrawerMenuController>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: ColorPalettes.transparent),
    );

    return Scaffold(
      body: Stack(
        children: [
          const DrawerMenuPage(),
          RxBuilder(builder: (context) {
            return AnimatedContainer(
              transform: Matrix4.translationValues(
                drawerMenuController.xOffset.value,
                Sizes.height(context) * drawerMenuController.scalePadding,
                0,
              )
                ..scale(drawerMenuController.scaleFactor.value)
                ..rotateY(drawerMenuController.isShowDrawer.value ? -0.5 : 0.0),
              duration: drawerMenuController.duration,
              curve: drawerMenuController.curve,
              child: GestureDetector(
                onTap: () {
                  if (drawerMenuController.isShowDrawer.value) {
                    drawerMenuController.closeDrawer();
                  }
                },
                child: ClipViewPort(
                  child: const RouterOutlet(),
                  curve: drawerMenuController.curve,
                  duration: drawerMenuController.duration,
                  isShowDrawer: drawerMenuController.isShowDrawer.value,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
