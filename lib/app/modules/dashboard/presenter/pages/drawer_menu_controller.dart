import 'package:rx_notifier/rx_notifier.dart';

class DrawerMenuController {
  final xOffset = RxNotifier<double>(0);
  final yOffset = RxNotifier<double>(0);
  final scaleFactor = RxNotifier<double>(1);
  final isShowDrawer = RxNotifier<bool>(false);

  void openDrawer() {
    xOffset.value = 220;
    yOffset.value = 130;
    scaleFactor.value = 0.75;
    isShowDrawer.value = true;
  }

  void closeDrawer() {
    xOffset.value = 0;
    yOffset.value = 0;
    scaleFactor.value = 1;
    isShowDrawer.value = false;
  }
}
