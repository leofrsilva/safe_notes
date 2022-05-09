import 'package:sqlite3/sqlite3.dart';
// ignore: implementation_imports
import 'package:sqflite_common/src/exception.dart' as exception;
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../domain/errors/folder_failures.dart';
import '../../infra/datasources/i_folder_datasource.dart';

class FolderDatasource extends IFolderDatasource {
  final FolderDAO _folderDAO;
  FolderDatasource(this._folderDAO);

  @override
  Stream<List<FolderQtdChildView>> getFoldersQtdChild() {
    try {
      final list = _folderDAO.getFoldersQtdChild();
      return list;
    } on SqliteException catch (error, stackTrace) {
      throw GetListFoldersSqliteError(
        stackTrace,
        'FolderDatasource.getFoldersQtdChild',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw GetListFoldersSqliteError(
        stackTrace,
        'FolderDatasource.getFoldersQtdChild',
        error,
        error.message ?? '',
      );
    }
  }
}
