import 'package:sqlite3/sqlite3.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';

import '../../domain/errors/getin_failures.dart';
import '../../infra/datasources/i_set_folder_datasource.dart';

class SetFolderDatasource extends ISetFolderDatasource {
  final FolderDAO _folderDAO;
  SetFolderDatasource(this._folderDAO);

  @override
  Future<dynamic> setDefaultFolder(FolderEntity defaultFolder) async {
    try {
      await _folderDAO.insertFolder(defaultFolder);
      return dynamic;
    } on SqliteException catch (error, stackTrace) {
      throw SetFolderSqliteError(
        stackTrace,
        'SetFolderDatasource.setDefaultFolder',
        error,
        error.message,
      );
    }
  }
}
