import 'package:sqlite3/sqlite3.dart';
// ignore: implementation_imports
import 'package:sqflite_common/src/exception.dart' as exception;

import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';

import '../../domain/errors/lixeira_failures.dart';
import '../../infra/datasources/i_lixeira_datasource.dart';

class LixeiraDatasource extends ILixeiraDatasource {
  final NoteDAO _noteDAO;
  LixeiraDatasource(this._noteDAO);

  @override
  Future<List<NoteEntity>> getNotesDeleted() async {
    try {
      final list = await _noteDAO.getNotesDeleted();
      return list;
    } on SqliteException catch (error, stackTrace) {
      throw GetNotesDeletedSqliteError(
        stackTrace,
        'LixeiraDatasource.getNotesDeleted',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw GetNotesDeletedSqliteError(
        stackTrace,
        'LixeiraDatasource.getNotesDeleted',
        error,
        error.message ?? '',
      );
    }
  }
}
