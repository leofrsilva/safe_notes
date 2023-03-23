import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'dashboard_controller.dart';
import 'pages/drawer/drawer_menu_page.dart';
import 'pages/drawer/drawer_menu_controller.dart';
import 'widgets/clip_view_port_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  late DashboardController dashboardController;
  late DrawerMenuController drawerMenuController;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      dashboardController.deleteExpiration();
    }
  }

  @override
  void initState() {
    super.initState();
    drawerMenuController = Modular.get<DrawerMenuController>();
    dashboardController = Modular.get<DashboardController>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timings) {
      Future.delayed(timings, () {
        dashboardController.deleteExpiration();
      });
      dashboardController.accessKey();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                child: ClipViewPortWidget(
                  duration: drawerMenuController.duration,
                  isShowDrawer: drawerMenuController.isShowDrawer.value,
                  child: Stack(
                    children: [
                      const RouterOutlet(),
                      AnimatedCrossFade(
                        crossFadeState: drawerMenuController.isShowDrawer.value
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: drawerMenuController.duration,
                        firstCurve: drawerMenuController.curve,
                        secondCurve: drawerMenuController.curve,
                        firstChild: Container(),
                        secondChild: SizedBox(
                          width: Sizes.width(context),
                          height: Sizes.height(context),
                          child: ModalBarrier(
                            color: Colors.black26,
                            onDismiss: () {
                              if (drawerMenuController.isShowDrawer.value) {
                                drawerMenuController.closeDrawer();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
