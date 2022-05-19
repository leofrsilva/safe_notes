import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:sqlite3/sqlite3.dart';
// ignore: implementation_imports
import 'package:sqflite_common/src/exception.dart' as exception;
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/design/common/extension/extension.dart';

import '../../domain/errors/manager_folders_failures.dart';
import '../../infra/datasources/i_manager_folders_datasource.dart';

class ManagerFoldersDatasource extends IManagerFoldersDatasource {
  final FolderDAO _folderDAO;
  ManagerFoldersDatasource(this._folderDAO);

  @override
  Future<int> addFolder(FolderEntity entity) async {
    try {
      final folderId = await _folderDAO.insertFolder(entity);
      if (folderId <= 0) {
        throw NotReturnFolderIdSqliteError();
      }
      return folderId;
    } on SqliteException catch (error, stackTrace) {
      throw AddFolderSqliteError(
        stackTrace,
        'ManagerFoldersDatasource.addFolder',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw AddFolderSqliteError(
        stackTrace,
        'ManagerFoldersDatasource.addFolder',
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
        'ManagerFoldersDatasource.editFolder',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw EditFolderSqliteError(
        stackTrace,
        'ManagerFoldersDatasource.editFolder',
        error,
        error.message ?? '',
      );
    }
  }

  @override
  Future<dynamic> deleteFolder(List<FolderEntity> folders) async {
    try {
      for (var folder in folders) {
        if (folder.isDeleted == 0) {
          folder = FolderEntity(
            userId: folder.userId,
            folderId: folder.id,
            isDeleted: 1,
            name: folder.name,
            level: folder.level,
            color: folder.color,
            dateModification: folder.dateModification,
            dateCreate: folder.dateCreate,
          );
        }
        await _folderDAO.updateFolders([folder]);
        await _folderDAO.delete(folder.id);
      }
    } on SqliteException catch (error, stackTrace) {
      throw DeleteFolderSqliteError(
        stackTrace,
        'ManagerFoldersDatasource.deleteFolder',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw DeleteFolderSqliteError(
        stackTrace,
        'ManagerFoldersDatasource.deleteFolder',
        error,
        error.message ?? '',
      );
    }
  }
}
