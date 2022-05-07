import 'package:flutter/material.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../../presenter/pages/drawer/drawer_menu_controller.dart';
import '../../../presenter/reactive/reactive_list_folder.dart';
import '../domain/usecases/i_manager_folders_usecase.dart';
import 'pages/add_folder_page.dart';
import 'pages/delete_folder_page.dart';
import 'pages/edit_color_page.dart';
import 'pages/edit_name_page.dart';

class ManagerFoldersController {
  final AppCore _appCore;
  final IAddFolderUsecase _addFolderUsecase;
  final IEditFolderUsecase _editFolderUsecase;
  final IDeleteFolderUsecase _deleteFolderUsecase;
  final DrawerMenuController _drawerMenuController;

  ReactiveListFolder get reactiveListFolder =>
      _drawerMenuController.reactiveListFolder;

  ManagerFoldersController(
    this._appCore,
    this._addFolderUsecase,
    this._editFolderUsecase,
    this._deleteFolderUsecase,
    this._drawerMenuController,
  );

  String get userUId => _appCore.getUsuario()?.docRef ?? '';

  callAddSubFolderPage(
    BuildContext context,
    FolderQtdChildView folderQtdChildView,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black26,
      builder: (context) {
        return AddFolderPage(
          folderQtdChildView: folderQtdChildView,
        );
      },
    );
  }

  callEditNameFolderPage(
    BuildContext context,
    FolderQtdChildView folderQtdChildView,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black26,
      builder: (context) {
        return EditNamePage(
          folderQtdChildView: folderQtdChildView,
        );
      },
    );
  }

  callEditColorFolderPage(
    BuildContext context,
    FolderQtdChildView folderQtdChildView,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black26,
      builder: (context) {
        return EditColorPage(
          folderQtdChildView: folderQtdChildView,
        );
      },
    );
  }

  callDeleteFolderPage(BuildContext context, List<int> ids) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black26,
      builder: (context) {
        return DeleteFolderPage(
          listIdToDelete: ids,
        );
      },
    );
  }

  void addFolder(BuildContext context, FolderModel folder) {
    _addFolderUsecase.call(folder).then((either) async {
      if (either.isLeft()) {
        SnackbarError.show(
          context,
          message: 'Erro ao registar Pasta!',
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 250), () {
          _drawerMenuController.reactiveListFolder
              .expanded(folderId: folder.folderParent ?? 0);
        });
      }
    });
  }

  void editFolder(BuildContext context, FolderModel folder) {
    _editFolderUsecase.call(folder).then((either) {
      if (either.isLeft()) {
        SnackbarError.show(
          context,
          message: 'Erro ao atualizar Pasta!',
        );
      }
    });
  }

  void deleteFolder(BuildContext context, folderId) {
    _deleteFolderUsecase.call(folderId).then((either) {
      if (either.isLeft()) {
        SnackbarError.show(
          context,
          message: 'Erro ao deletar Pasta!',
        );
      } else {
        _drawerMenuController.listFoldersStore.getListFolders();
      }
    });
  }
}
