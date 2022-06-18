import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';
import 'package:sqlite3/sqlite3.dart';
// ignore: implementation_imports
import 'package:sqflite_common/src/exception.dart' as exception;
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';

import '../../domain/errors/get_list_failures.dart';
import '../../infra/datasources/i_get_list_datasource.dart';

class GetListDatasource extends IGetListDatasource {
  final FolderDAO _folderDAO;
  final NoteDAO _noteDAO;
  GetListDatasource(
    this._folderDAO,
    this._noteDAO,
  );

  @override
  Stream<List<FolderEntity>> getFolders() {
    try {
      final list = _folderDAO.getFolders();
      return list;
    } on SqliteException catch (error, stackTrace) {
      throw GetListFoldersSqliteError(
        stackTrace,
        'GetListDatasource.getFolders',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw GetListFoldersSqliteError(
        stackTrace,
        'GetListDatasource.getFolders',
        error,
        error.message ?? '',
      );
    }
  }

  @override
  Stream<List<NoteEntity>> getNotes() {
    try {
      final list = _noteDAO.getNotes();
      return list;
    } on SqliteException catch (error, stackTrace) {
      throw GetListNotesSqliteError(
        stackTrace,
        'GetListDatasource.getNotes',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw GetListNotesSqliteError(
        stackTrace,
        'GetListDatasource.getNotes',
        error,
        error.message ?? '',
      );
    }
  }
}
