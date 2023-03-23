import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt.dart';

import '../../../domain/usecases/folder/i_folder_usecase.dart';
import '../../../presenter/pages/drawer/drawer_menu_controller.dart';
import '../../../presenter/reactive/reactive_list.dart';
import '../../folder/presenter/folder_controller.dart';
import 'pages/add_folder_page.dart';
import 'pages/delete_folder_page.dart';
import 'pages/edit_color_page.dart';
import 'pages/edit_name_page.dart';

class ManagerFoldersController extends Disposable {
  final AppCore _appCore;
  final IAddFolderUsecase _addFolderUsecase;
  final IEditFolderUsecase _editFolderUsecase;
  final IDeleteFolderUsecase _deleteFolderUsecase;
  final DrawerMenuController _drawerMenuController;

  ReactiveList get reactiveList =>
      _drawerMenuController.listFieldsStore.reactive;

  ManagerFoldersController(
    this._appCore,
    this._addFolderUsecase,
    this._editFolderUsecase,
    this._deleteFolderUsecase,
    this._drawerMenuController,
  );

  String get userUId => _appCore.getUsuario()?.docRef ?? '';

  callMoveForFolderPage(
    BuildContext context,
    FolderModel folderModel,
  ) {}

  callAddSubFolderPage(
    BuildContext context,
    FolderModel folderModel,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // barrierColor: ColorPalettes.black26,
      builder: (context) {
        return AddFolderPage(
          folderModel: folderModel,
          reactiveList: reactiveList,
        );
      },
    );
  }

  callEditNameFolderPage(
    BuildContext context,
    FolderModel folderModel,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // barrierColor: ColorPalettes.black26,
      builder: (context) {
        return EditNamePage(
          folderModel: folderModel,
          reactiveList: reactiveList,
        );
      },
    );
  }

  callEditColorFolderPage(
    BuildContext context,
    FolderModel folderModel,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // barrierColor: ColorPalettes.black26,
      builder: (context) {
        return EditColorPage(
          folderModel: folderModel,
        );
      },
    );
  }

  callDeleteFolderPage(
    BuildContext context,
    List<FolderModel> folders,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // barrierColor: ColorPalettes.black26,
      builder: (context) {
        return DeleteFolderPage(
          listFolderModel: folders,
        );
      },
    );
  }

  void addFolder(BuildContext context, FolderModel folder) {
    _addFolderUsecase.call([folder]).then((either) async {
      if (either.isLeft()) {
        if (either.fold(id, id) is! IncorrectEncryptionError) {
          SnackbarError.show(
            context,
            message: 'Erro ao registar Pasta!',
          );
        }
      } else {
        _drawerMenuController.listFieldsStore.reactive
            .expanded(folderId: folder.folderParent ?? 0);
      }
    });
  }

  void editFolder(BuildContext context, FolderModel folder) {
    _editFolderUsecase.call(folder).then((either) async {
      if (either.isLeft()) {
        if (either.fold(id, id) is! IncorrectEncryptionError) {
          SnackbarError.show(
            context,
            message: 'Erro ao atualizar Pasta!',
          );
        }
      }
    });
  }

  void deleteFolder(BuildContext context, List<FolderModel> folders) {
    _deleteFolderUsecase.call(folders).then((either) {
      if (either.isLeft()) {
        if (either.fold(id, id) is! IncorrectEncryptionError) {
          SnackbarError.show(
            context,
            message: 'Erro ao deletar Pasta!',
          );
        }
      } else {
        ParallelRoute? modFolder;
        for (var module in Modular.to.navigateHistory) {
          if (module.name.contains('/mod-folder')) {
            modFolder = module;
          }
        }
        if (modFolder != null) {
          final controllerFolder = Modular.get<FolderController>();
          final ids = folders.map<int>((folder) => folder.folderId).toList();

          var listFoldersDeleted = reactiveList
              .listDescendants(controllerFolder.folder)
              .where((folder) {
            return folder.folderId != DefaultDatabase.folderDefault.folderId;
          });
          for (var folder in listFoldersDeleted) {
            if (ids.contains(folder.folderId)) {
              controllerFolder.folderParent.value =
                  DefaultDatabase.folderDefault;
            }
          }
        }
      }
    });
  }

  Future saveBuffer(Map<int, bool> mapBufferExpanded) async {
    _drawerMenuController.listFieldsStore.saveBuffer(mapBufferExpanded);
  }

  @override
  void dispose() async {
    await saveBuffer(reactiveList.getBufferExpanded);
  }
}
