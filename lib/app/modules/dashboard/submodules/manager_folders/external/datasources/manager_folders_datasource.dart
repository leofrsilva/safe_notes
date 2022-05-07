import 'package:sqlite3/sqlite3.dart';
// ignore: implementation_imports
import 'package:sqflite_common/src/exception.dart' as exception;
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';

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
  Future<int> editFolder(FolderEntity entity) async {
    try {
      var recordFolder = await _folderDAO.findFolder(entity.id);
      if (recordFolder != null) {
        var folder = FolderEntity(
          folderParent: entity.folderParent,
          userId: entity.userId,
          folderId: entity.id,
          level: entity.level,
          name: entity.name,
          color: entity.color,
          isDeleted: entity.isDeleted,
          dateCreate: recordFolder.dateCreate,
          dateModification: entity.dateModification,
        );
        final qtdRowsUpdate = await _folderDAO.updateFolders([folder]);
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
  Future<dynamic> deleteFolder(int id) async {
    try {
      await _folderDAO.deleteFolder(id);
      await _folderDAO.delete(id);
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
