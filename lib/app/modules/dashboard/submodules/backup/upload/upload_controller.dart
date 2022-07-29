import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:safe_notes/app/design/widgets/loading/loading_overlay.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../domain/usecases/folder/i_folder_usecase.dart';
import '../../../domain/usecases/note/i_note_usecases.dart';
import '../../../presenter/pages/drawer/drawer_menu_controller.dart';

class UploadController {
  final IDeleteFolderPersistentUsecase _deleteFolderPersistentUsecase;
  final IDeleteNotePersistentUsecase _deleteNotePersistentUsecase;
  final IAddFolderUsecase _addFolderUsecase;
  final IAddNoteUsecase _addNoteUsecase;

  final DrawerMenuController _drawerMenuController;

  UploadController(
    this._addNoteUsecase,
    this._addFolderUsecase,
    this._deleteNotePersistentUsecase,
    this._deleteFolderPersistentUsecase,
    this._drawerMenuController,
  );

  final List<FolderModel> _listFolder = [];
  final List<NoteModel> _listNote = [];
  bool get fieldsIsNotEmpty => _listFolder.isNotEmpty || _listNote.isNotEmpty;

  _generateListNote(List list) {
    if (list.isNotEmpty) {
      for (var mapNote in list) {
        _listNote.add(NoteModel.fromJsonEncrypted(mapNote));
      }
    }
  }

  _generateListFolder(Map<String, dynamic> map) {
    _listFolder.add(FolderModel.fromJsonEncrypted(map));
    _generateListNote(map['note_children']);
    if (map.containsKey('folder_children')) {
      for (var mapFolder in map['folder_children']) {
        _generateListFolder(mapFolder);
      }
    }
  }

  exit() => Modular.to.pop();

  Future<void> upload() async {
    var dir = await DownloadsPath.downloadsDirectory();
    if (dir != null) {
      String pathDownload = '${dir.path}/';
      FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
        initialDirectory: pathDownload,
      );

      if (resultFile != null && resultFile.files.single.path != null) {
        try {
          File file = File(resultFile.files.single.path!);

          String strJson = await file.readAsString();
          Map<String, dynamic> json = jsonDecode(strJson);

          if (json.containsKey('folder_children')) {
            _listNote.clear();
            _listFolder.clear();
            _generateListNote(json['note_children']);
            for (var mapFolder in json['folder_children']) {
              _generateListFolder(mapFolder);
            }
          } else {
            exit();
          }
        } catch (_) {
          exit();
        }
      } else {
        exit();
      }
    }
  }

  Future addFields(BuildContext context) async {
    if (_listFolder.isNotEmpty || _listNote.isNotEmpty) {
      await LoadingOverlay.show(
        context,
        _processAddFields(context),
      );
    }
  }

  Future _processAddFields(BuildContext context) async {
    try {
      await _deleteNotePersistentUsecase
          .call(_drawerMenuController.listFieldsStore.reactive.allNotes);

      final currentFolderList =
          _drawerMenuController.listFieldsStore.reactive.allFolders;
      currentFolderList.removeWhere(
        (folder) => folder.folderId == DefaultDatabase.folderIdDefault,
      );
      await _deleteFolderPersistentUsecase.call(currentFolderList);

      await _addFolderUsecase.call(_listFolder.toList()).then((either) {
        if (either.isLeft()) {
          SnackbarError.show(
            context,
            message: 'Error ao adicionar Pastas!',
          );
        }
      });

      await _addNoteUsecase.call(_listNote).then((either) {
        if (either.isLeft()) {
          SnackbarError.show(
            context,
            message: 'Error ao adicionar Notas!',
          );
        }
      });
    } catch (e) {
      SnackbarError.show(
        context,
        message: 'Error ao fazer a leitura do Backup!',
      );
    }
  }
}
