import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../pages/drawer/drawer_menu_controller.dart';

mixin TemplatePageMixin<T extends StatefulWidget> on State<T> {
  String title = '';

  Widget body = Container();

  late DrawerMenuController drawerMenu;
  late ScrollController scrollController;

  Widget? floatingButtonAdd;

  enableFloatingButtonAdd() {
    if (_isVisibleButtonAdd != null) {
      _isVisibleButtonAdd!.value = true;
    }
  }

  disableFloatingButtonAdd() {
    toggleVisibleFloatingButtonAdd(null);
  }

  ValueNotifier<bool?>? _isVisibleButtonAdd;
  toggleVisibleFloatingButtonAdd(bool? value) {
    if (_isVisibleButtonAdd != null) {
      if (_isVisibleButtonAdd!.value != null) {
        if (_isVisibleButtonAdd!.value != value) {
          _isVisibleButtonAdd!.value = value;
        }
      }
    }
  }

  final _isVisibleButtonToTop = ValueNotifier<bool>(false);
  toggleVisibleFloatingButtonToTop(bool value) {
    if (_isVisibleButtonToTop.value != value) {
      _isVisibleButtonToTop.value = value;
    }
  }

  Timer? _debounceVisibleButton;
  double position = 0;

  _checkScrollInTop() {
    if (scrollController.offset > 2) {
      toggleVisibleFloatingButtonToTop(true);
      //
      if (position > scrollController.offset) {
        //-- UP
        toggleVisibleFloatingButtonAdd(true);
      } else {
        // -- DOWN
        toggleVisibleFloatingButtonAdd(false);
      }
      //
      if (_debounceVisibleButton?.isActive ?? false) {
        _debounceVisibleButton!.cancel();
      }
      _debounceVisibleButton = Timer(const Duration(milliseconds: 2500), () {
        toggleVisibleFloatingButtonToTop(false);
        toggleVisibleFloatingButtonAdd(true);
      });
    } else {
      toggleVisibleFloatingButtonToTop(false);
      toggleVisibleFloatingButtonAdd(true);
    }
    position = scrollController.offset;
  }

  Widget? bottomNavigationBar;

  List<Widget> actionsIcon = [];

  PreferredSizeWidget appBar() {
    return AppBar(
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
    );
  }

  @override
  void initState() {
    super.initState();
    drawerMenu = Modular.get<DrawerMenuController>();
    scrollController = ScrollController();
    scrollController.addListener(_checkScrollInTop);
    if (floatingButtonAdd != null) {
      _isVisibleButtonAdd = ValueNotifier<bool?>(true);
    }
  }

  @override
  void didUpdateWidget(covariant oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _isVisibleButtonAdd?.dispose();
    _isVisibleButtonToTop.dispose();
    scrollController.removeListener(_checkScrollInTop);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Stack(
        children: [
          body,
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isVisibleButtonToTop,
              builder: (context, value, child) {
                return value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20.0,
                        ),
                        child: Material(
                          elevation: 6.0,
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: GestureDetector(
                            onTap: () {
                              scrollController.animateTo(
                                scrollController.position.minScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInQuint,
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 2.0,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    margin: const EdgeInsets.only(bottom: 5.0),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Icon(
                                      Icons.keyboard_arrow_up_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton:
          floatingButtonAdd != null && _isVisibleButtonAdd != null
              ? ValueListenableBuilder<bool?>(
                  valueListenable: _isVisibleButtonAdd!,
                  builder: (context, value, child) {
                    if (value != null && value) return floatingButtonAdd!;
                    return Container();
                  },
                )
              : null,
    );
  }
}
