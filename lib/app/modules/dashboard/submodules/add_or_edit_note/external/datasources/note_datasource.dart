import 'package:sqlite3/sqlite3.dart';
// ignore: implementation_imports
import 'package:sqflite_common/src/exception.dart' as exception;
import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';

import '../../domain/errors/add_or_edit_failures.dart';
import '../../infra/datasources/i_note_datasource.dart';

class NoteDatasource extends INoteDatasource {
  final NoteDAO _noteDAO;
  NoteDatasource(this._noteDAO);

  @override
  Future<dynamic> addNote(NoteEntity entity) async {
    try {
      final id = await _noteDAO.insertNote(entity);
      if (id <= 0) {
        throw NotReturnNoteIdSqliteError();
      }
      return id;
    } on SqliteException catch (error, stackTrace) {
      throw AddNoteSqliteError(
        stackTrace,
        'NoteDatasource.addNote',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw AddNoteSqliteError(
        stackTrace,
        'NoteDatasource.addNote',
        error,
        error.message ?? '',
      );
    }
  }

  @override
  Future<dynamic> editNote(NoteEntity entity) async {
    try {
      int qtdUpdates = await _noteDAO.updateNotes([entity]);
      if (qtdUpdates == 0) {
        throw NoNoteRecordsChangedSqliteError();
      }
      return qtdUpdates;
    } on SqliteException catch (error, stackTrace) {
      throw EditNoteSqliteError(
        stackTrace,
        'NoteDatasource.editNote',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw EditNoteSqliteError(
        stackTrace,
        'NoteDatasource.editNote',
        error,
        error.message ?? '',
      );
    }
  }

  @override
  Future<dynamic> deletePersistentNote(NoteEntity entity) async {
    try {
      return await _noteDAO.deletePersistentNote(entity);
    } on SqliteException catch (error, stackTrace) {
      throw DeleteNoteEmptySqliteError(
        stackTrace,
        'NoteDatasource.deletePersistentNote',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw DeleteNoteEmptySqliteError(
        stackTrace,
        'NoteDatasource.deletePersistentNote',
        error,
        error.message ?? '',
      );
    }
  }
}
