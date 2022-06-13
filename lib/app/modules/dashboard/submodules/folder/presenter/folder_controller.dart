import 'package:flutter/foundation.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../../presenter/pages/drawer/drawer_menu_controller.dart';
import '../../../presenter/stores/selection_store.dart';

class FolderController {
  final SelectionStore selection;
  final DrawerMenuController _drawerMenu;

  FolderController(
    this._drawerMenu,
    this.selection,
  ) {
    _folderParent = ValueNotifier<FolderQtdChildView>(
      FolderQtdChildView(
        id: 0,
        qtd: 0,
        name: '',
        level: 0,
        color: 0,
        isDeleted: 0,
      ),
    );
  }

  late ValueNotifier<FolderQtdChildView> _folderParent;

  ValueNotifier<FolderQtdChildView> get folderParent => _folderParent;

  set folder(FolderQtdChildView folder) {
    _folderParent.value = folder;
    _drawerMenu.selectedMenuItem.value = folder.id;
    _drawerMenu.moduleFolderSaveFolderParent(folder);
  }

  FolderQtdChildView get folder => _folderParent.value;
}
