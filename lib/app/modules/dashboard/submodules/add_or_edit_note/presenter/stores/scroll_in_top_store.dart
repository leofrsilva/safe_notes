import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ScrollInTopStore extends Disposable {
  late ScrollController scrollController;

  ScrollInTopStore() {
    scrollController = ScrollController();
    scrollController.addListener(_checkScrollInTop);
  }

  final isVisibleFloatingButton = ValueNotifier<bool>(false);

  toggleVisibleFloatingButton(bool value) {
    if (isVisibleFloatingButton.value != value) {
      isVisibleFloatingButton.value = value;
    }
  }

  Timer? _debounceVisibleButton;

  _checkScrollInTop() {
    if (scrollController.offset > 2) {
      toggleVisibleFloatingButton(true);
      //
      if (_debounceVisibleButton?.isActive ?? false) {
        _debounceVisibleButton!.cancel();
      }
      _debounceVisibleButton = Timer(const Duration(milliseconds: 2500), () {
        toggleVisibleFloatingButton(false);
      });
    } else {
      toggleVisibleFloatingButton(false);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_checkScrollInTop);
    scrollController.dispose();
  }
}
