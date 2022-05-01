import 'package:sqlite3/sqlite3.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';

import '../../domain/errors/getin_failures.dart';
import '../../infra/datasources/i_delete_folder_datasource.dart';

class DeleteFolderDatasource extends IDeleteFolderDatasource {
  final FolderDAO _folderDAO;
  DeleteFolderDatasource(this._folderDAO);

  @override
  Future<dynamic> deleteAllFolderExcept(int folderId) async {
    try {
      await _folderDAO.deleteAllExcept(folderId);
      return dynamic;
    } on SqliteException catch (error, stackTrace) {
      throw DeleteAllFolderExceptSqliteError(
        stackTrace,
        'DeleteFolderDatasource.deleteAllFolderExcept',
        error,
        error.message,
      );
    }
  }
}
