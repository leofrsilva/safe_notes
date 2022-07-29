import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:sqlite3/sqlite3.dart';
// ignore: implementation_imports
import 'package:sqflite_common/src/exception.dart' as exception;
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/design/common/extension/extension.dart';

import '../../domain/errors/folder_failures.dart';
import '../../infra/datasources/i_folder_datasource.dart';

class FolderDatasource extends IFolderDatasource {
  final NoteDAO _noteDAO;
  final FolderDAO _folderDAO;
  FolderDatasource(this._folderDAO, this._noteDAO);

  @override
  Future<List<int>> addFolders(List<FolderEntity> entities) async {
    try {
      final foldersId = await _folderDAO.insertFolders(entities);
      if (foldersId.length != entities.length) {
        throw NotReturnFolderIdSqliteError();
      }
      return foldersId;
    } on SqliteException catch (error, stackTrace) {
      throw AddFolderSqliteError(
        stackTrace,
        'FolderDatasource.addFolder',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw AddFolderSqliteError(
        stackTrace,
        'FolderDatasource.addFolder',
        error,
        error.message ?? '',
      );
    }
  }

  @override
  Future<int> editFolder(FolderModel model) async {
    try {
      var recordFolder = await _folderDAO.findFolder(model.folderId);
      if (recordFolder != null) {
        var folder = model.copyWith(
          userId: recordFolder.userId,
          folderParent: recordFolder.folderParent,
          dateCreate: recordFolder.dateCreate.toDateTime,
          dateModification: DateTime.now(),
        );
        final qtdRowsUpdate = await _folderDAO.updateFolders([folder.entity]);
        if (qtdRowsUpdate == 1) return qtdRowsUpdate;
      }
      throw NoFolderRecordsChangedSqliteError();
    } on SqliteException catch (error, stackTrace) {
      throw EditFolderSqliteError(
        stackTrace,
        'FolderDatasource.editFolder',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw EditFolderSqliteError(
        stackTrace,
        'FolderDatasource.editFolder',
        error,
        error.message ?? '',
      );
    }
  }

  Future deleteChildrens(FolderEntity folder) async {
    var listChildrens = await _folderDAO.findAllFolderChildrens(folder.id);
    for (var child in listChildrens) {
      await deleteChildrens(child);
      await _delete(child);
    }
  }

  Future _delete(FolderEntity folder) async {
    var folderDeleted =
        FolderModel.fromEntity(folder).copyWith(isDeleted: true).entity;

    var listNoteChildrens = await _noteDAO.getNotesByFolder(folderDeleted.id);
    final noteChildrensDeleted = listNoteChildrens
        .map((note) =>
            NoteModel.fromEntity(note).copyWith(isDeleted: true).entity)
        .toList();
    if (listNoteChildrens.isNotEmpty) {
      await _noteDAO.updateNotes(noteChildrensDeleted);
    }

    await _folderDAO.updateFolders([folderDeleted]);
  }

  @override
  Future<dynamic> deleteFolder(List<FolderEntity> entities) async {
    try {
      if (entities.where((entity) => entity.isDeleted == 0).isNotEmpty) {
        throw NoFolderEditedToDeletedSqliteError();
      }

      for (var folder in entities) {
        await deleteChildrens(folder);
        await _delete(folder);
      }
    } on SqliteException catch (error, stackTrace) {
      throw DeleteFolderSqliteError(
        stackTrace,
        'FolderDatasource.deleteFolder',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw DeleteFolderSqliteError(
        stackTrace,
        'FolderDatasource.deleteFolder',
        error,
        error.message ?? '',
      );
    }
  }

  @override
  Future restoreFolder(List<FolderEntity> entities) async {
    try {
      if (entities.where((entity) => entity.isDeleted == 1).isNotEmpty) {
        throw NoFolderEditedToRestoredSqliteError();
      }
      for (var folder in entities) {
        await _folderDAO.restoreChild(folder);
      }
      return await _folderDAO.updateFolders(entities);
    } on SqliteException catch (error, stackTrace) {
      throw RestoreFolderSqliteError(
        stackTrace,
        'FolderDatasource.restoreFolder',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw RestoreFolderSqliteError(
        stackTrace,
        'FolderDatasource.restoreFolder',
        error,
        error.message ?? '',
      );
    }
  }

  @override
  Future<dynamic> deletePersistentFolder(List<FolderEntity> entities) async {
    try {
      for (var folder in entities) {
        await _folderDAO.deletePersistentChild(folder);
      }
      return await _folderDAO.deletePersistentFolders(entities);
    } on SqliteException catch (error, stackTrace) {
      throw DeleteFolderPersistentSqliteError(
        stackTrace,
        'FolderDatasource.deletePersistentFolder',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw DeleteFolderPersistentSqliteError(
        stackTrace,
        'FolderDatasource.deletePersistentFolder',
        error,
        error.message ?? '',
      );
    }
  }
}
