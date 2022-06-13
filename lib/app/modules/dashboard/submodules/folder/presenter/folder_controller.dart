import 'package:flutter/foundation.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../presenter/pages/drawer/drawer_menu_controller.dart';
import '../../../presenter/stores/selection_store.dart';

class FolderController {
  final SelectionStore selection;
  final DrawerMenuController _drawerMenu;

  FolderController(
    this._drawerMenu,
    this.selection,
  ) {
    _folderParent = ValueNotifier<FolderModel>(
      FolderModel(
        folderId: 0,
        userId: '',
        name: '',
        level: 0,
        color: 0,
        isDeleted: false,
        folderParent: null,
        dateCreate: DateTime.now(),
        dateModification: DateTime.now(),
      ),
    );
  }

  late ValueNotifier<FolderModel> _folderParent;

  ValueNotifier<FolderModel> get folderParent => _folderParent;

  set folder(FolderModel folder) {
    _folderParent.value = folder;
    _drawerMenu.selectedMenuItem.value = folder.folderId;
    _drawerMenu.moduleFolderSaveFolderParent(folder);
  }

  FolderModel get folder => _folderParent.value;
}
