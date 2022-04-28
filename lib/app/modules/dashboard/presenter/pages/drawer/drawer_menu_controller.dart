import 'package:flutter/cupertino.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:safe_notes/app/design/common/utils/sizes.dart';

class DrawerMenuController {
  final selectedMenuItem = ValueNotifier<int>(0);

  final _scaled = 0.85;
  final widthExpanded = 280.0;
  final heightExpanded = 50.0;

  final xOffset = RxNotifier<double>(0);
  final yOffset = RxNotifier<double>(0);
  final scaleFactor = RxNotifier<double>(1);
  final isShowDrawer = RxNotifier<bool>(false);

  double get scalePadding => (1 - scaleFactor.value) / 2;
  double sizePaddingVertical(BuildContext context) {
    return Sizes.height(context) * (1 - _scaled) / 2;
  }

  final duration = const Duration(milliseconds: 300);
  final curve = Curves.easeInQuint;

  void openDrawer() {
    xOffset.value = 280.0;
    yOffset.value = 50.0;
    scaleFactor.value = _scaled;
    isShowDrawer.value = true;
  }

  void closeDrawer() {
    xOffset.value = 0;
    yOffset.value = 0;
    scaleFactor.value = 1;
    isShowDrawer.value = false;
  }
}
