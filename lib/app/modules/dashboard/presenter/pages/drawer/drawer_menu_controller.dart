import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:safe_notes/app/design/common/util/sizes.dart';
import 'package:safe_notes/app/modules/setting/presenter/controllers/manager_route_navigator_store.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../stores/list_fields_store.dart';

class DrawerMenuController extends Disposable {
  final ListFieldsStore _listFieldsStore;
  ListFieldsStore get listFieldsStore => _listFieldsStore;

  final ManagerRouteNavigatorStore _managerRouteNavigatorStore;
  final durationNavigateFolder = const Duration(milliseconds: 150);

  void moduleFolderSaveFolderParent(FolderModel folder) {
    _managerRouteNavigatorStore.saveFolderParent(folder.toJson());
  }

  void onChangeRoute() async {
    var page = Modular.to.path;
    selectItemMenu(page);

    if (page.contains('/dashboard/mod-')) {
      if (!page.contains('/mod-folder')) {
        _managerRouteNavigatorStore.removeFolderParent();
      }
      _managerRouteNavigatorStore.savePage(page: page);
    }
  }

  void selectItemMenu(String path) {
    if (path.contains('/mod-notes')) {
      selectedMenuItem.value = 0;
    } else if (path.contains('/mod-favorites')) {
      selectedMenuItem.value = 1;
    } else if (path.contains('/mod-lixeira')) {
      selectedMenuItem.value = 2;
    }
  }

  DrawerMenuController(
    this._listFieldsStore,
    this._managerRouteNavigatorStore,
  ) {
    listFieldsStore.listNotesStore.getListNotes(listFieldsStore.setNotes);
    listFieldsStore.listFoldersStore.getListFolders(listFieldsStore.setFolders);

    Modular.to.addListener(onChangeRoute);
  }

  @override
  void dispose() {
    Modular.to.removeListener(onChangeRoute);
  }

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
