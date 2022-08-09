import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_notes/app/design/widgets/loading/loading_overlay.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/database/models/folder_list_model.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

class DownloadController {
  final List<FolderModel> _listFolder = [];
  final List<NoteModel> _listNote = [];

  int get qtdFolder => _listFolder.length;
  int get qtdNote => _listNote.length;

  bool get canNotDownload => qtdFolder == 1 && qtdNote == 0;

  setFolders(List<FolderModel> values) {
    _listFolder.clear();
    _listFolder.addAll(values);
    _reorganization();
  }

  setNotes(List<NoteModel> values) {
    _listNote.clear();
    _listNote.addAll(values);
  }

  FolderListModel? folderers;
  void _reorganization() {
    _listFolder.sort((previous, posterior) {
      return previous.level.compareTo(posterior.level);
    });

    if (_listFolder.isNotEmpty) {
      folderers = FolderListModel(current: _listFolder.first);
      _insertChildrens(folderers!);
    }
  }

  void _insertChildrens(FolderListModel listFolderModel) {
    FolderModel currentFolder;
    int parentId = listFolderModel.current.folderId;
    int childLevel = listFolderModel.current.level + 1;

    for (int i = 0; i < _listFolder.length; i++) {
      currentFolder = _listFolder[i];

      if (currentFolder.level == childLevel &&
          currentFolder.folderParent == parentId) {
        var child = FolderListModel(current: currentFolder);
        _insertChildrens(child);
        listFolderModel.childrens.add(child);
      }
    }
  }

  Map<String, dynamic> generaterFolderList(FolderListModel folderers) {
    var json = folderers.current.toJsonEncrypted();
    json['note_children'] = _getNoteChildren(folderers.current.folderId);
    for (var folderer in folderers.childrens) {
      if (json.containsKey('folder_children')) {
        var children = (json['folder_children'] as List);
        children.add(generaterFolderList(folderer));
        json['folder_children'] = children;
      } else {
        json['folder_children'] = [generaterFolderList(folderer)];
      }
    }
    return json;
  }

  Future<void> download(BuildContext context) async {
    if (!canNotDownload) {
      PermissionStatus status = await Permission.storage.request();

      if (status.isGranted) {
        var dir = await DownloadsPath.downloadsDirectory();

        if (dir != null) {
          LoadingOverlay.show(
            context,
            _processDownload(context, dir),
          );
        }
      }
    }
  }

  List<Map<String, dynamic>> _getNoteChildren(int folderId) {
    return _listNote //
        .where((note) => note.folderId == folderId)
        .map((note) => note.toJsonEncrypted())
        .toList();
  }

  Future _processDownload(BuildContext context, Directory dir) async {
    final backup = <String, dynamic>{};
    if (folderers != null) {
      backup.addAll(generaterFolderList(folderers!));
    }

    try {
      String nameFile = "safe-notes-backup.json";
      String savePath = "${dir.path}/$nameFile";
      File file = File(savePath);
      bool exists = await file.exists();

      int count = 1;
      while (exists) {
        nameFile = "safe-notes-backup-$count.json";
        savePath = "${dir.path}/$nameFile";
        count++;

        file = File(savePath);
        exists = await file.exists();
      }

      await file.create();
      await file.writeAsString(jsonEncode(backup));
    } catch (e) {
      SnackbarError.show(
        context,
        message: 'Error ao fazer o Download do Backup!',
      );
    }
  }
}
