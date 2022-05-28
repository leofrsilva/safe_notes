import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ScrollInTopStore extends Disposable {
  late ScrollController scrollController;
  
  ScrollInTopStore() {
    scrollController = ScrollController();
    scrollController.addListener(checkScrollInTop);
  }
  
  final isVisibleFloatingButton = ValueNotifier<bool>(false);

  toggleVisibleFloatingButton(bool value) {
    if (isVisibleFloatingButton.value != value) {
       isVisibleFloatingButton.value = value;
    }
  }

  checkScrollInTop() {
    if (scrollController.offset > 2) {
      toggleVisibleFloatingButton(true);
    } else {
      toggleVisibleFloatingButton(false);
    }
  }
  
  @override
  void dispose() {
    scrollController.removeListener(checkScrollInTop);
    scrollController.dispose();
  }
}
