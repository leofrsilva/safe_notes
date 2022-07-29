import 'package:sqlite3/sqlite3.dart';
// ignore: implementation_imports
import 'package:sqflite_common/src/exception.dart' as exception;
import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';

import '../../domain/errors/note_failures.dart';
import '../../infra/datasources/i_note_datasource.dart';

class NoteDatasource extends INoteDatasource {
  final NoteDAO _noteDAO;
  NoteDatasource(this._noteDAO);

  @override
  Future<dynamic> addNotes(List<NoteEntity> entities) async {
    try {
      final ids = await _noteDAO.insertNotes(entities);
      if (ids.length != entities.length) {
        throw NotReturnNoteIdSqliteError();
      }
      return ids;
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
  Future<dynamic> editNote(List<NoteEntity> entities) async {
    try {
      int qtdUpdates = await _noteDAO.updateNotes(entities);
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
  Future<dynamic> deleteNote(List<NoteEntity> entities) async {
    try {
      if ((entities.where((entity) => entity.isDeleted == 0).isNotEmpty) ||
          (entities
              .where((entity) => entity.dateDeletion == null)
              .isNotEmpty)) {
        throw NoNoteEditedToDeletedSqliteError();
      }
      return await _noteDAO.updateNotes(entities);
    } on SqliteException catch (error, stackTrace) {
      throw DeleteNoteSqliteError(
        stackTrace,
        'NoteDatasource.deleteNote',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw DeleteNoteSqliteError(
        stackTrace,
        'NoteDatasource.deleteNote',
        error,
        error.message ?? '',
      );
    }
  }

  @override
  Future restoreNote(List<NoteEntity> entities) async {
    try {
      if (entities.where((entity) => entity.isDeleted == 1).isNotEmpty) {
        throw NoNoteEditedToRestoredSqliteError();
      }
      return await _noteDAO.updateNotes(entities);
    } on SqliteException catch (error, stackTrace) {
      throw RestoreNoteSqliteError(
        stackTrace,
        'NoteDatasource.restoreNote',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw RestoreNoteSqliteError(
        stackTrace,
        'NoteDatasource.restoreNote',
        error,
        error.message ?? '',
      );
    }
  }

  @override
  Future<dynamic> deletePersistentNote(List<NoteEntity> entities) async {
    try {
      return await _noteDAO.deletePersistentNotes(entities);
    } on SqliteException catch (error, stackTrace) {
      throw DeleteNotePersistentSqliteError(
        stackTrace,
        'NoteDatasource.deletePersistentNote',
        error,
        error.message,
      );
    } on exception.SqfliteDatabaseException catch (error, stackTrace) {
      throw DeleteNotePersistentSqliteError(
        stackTrace,
        'NoteDatasource.deletePersistentNote',
        error,
        error.message ?? '',
      );
    }
  }
}
