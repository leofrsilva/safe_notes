import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/note_failures.dart';
import 'package:safe_notes/app/modules/dashboard/infra/repositories/note_repository.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/note_model_stub.dart';

void main() {
  final note = note1;
  final datasource = NoteDatasourceMock();

  group('note repository addNote | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.addNote(note.entity)).thenAnswer((_) async => 1);

      final repository = NoteRepository(datasource);
      final result = await repository.addNote(note);

      expect(result.isRight(), equals(true));
    });

    test('retornar um AddNoteSqliteError', () async {
      when(() => datasource.addNote(note.entity))
          .thenThrow(AddNoteSqliteErrorMock());

      final repository = NoteRepository(datasource);
      final result = await repository.addNote(note);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<AddNoteSqliteError>());
    });

    test('retornar um NotReturnNoteIdSqliteError', () async {
      when(() => datasource.addNote(note.entity))
          .thenThrow(NotReturnNoteIdSqliteError());

      final repository = NoteRepository(datasource);
      final result = await repository.addNote(note);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NotReturnNoteIdSqliteError>());
    });
  });

  group('note repository editNote | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.editNote([note.entity])).thenAnswer((_) async => 1);

      final repository = NoteRepository(datasource);
      final result = await repository.editNote([note]);

      expect(result.isRight(), equals(true));
    });

    test('retornar um EditNoteSqliteError', () async {
      when(() => datasource.editNote([note.entity]))
          .thenThrow(EditNoteSqliteErrorMock());

      final repository = NoteRepository(datasource);
      final result = await repository.editNote([note]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<EditNoteSqliteError>());
    });

    test('retornar um NoNoteRecordsChangedSqliteError', () async {
      when(() => datasource.editNote([note.entity]))
          .thenThrow(NoNoteRecordsChangedSqliteError());

      final repository = NoteRepository(datasource);
      final result = await repository.editNote([note]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NoNoteRecordsChangedSqliteError>());
    });
  });

  group('note repository restoreNote | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.restoreNote(any())).thenAnswer(
        (_) async => 1,
      );

      final repository = NoteRepository(datasource);
      final result = await repository.restoreNote([note]);

      expect(result.isRight(), equals(true));
    });

    test('retornar um NoNoteEditedToRestoredSqliteError', () async {
      when(() => datasource.restoreNote(any()))
          .thenThrow(NoNoteEditedToRestoredSqliteError());

      final repository = NoteRepository(datasource);
      final result = await repository.restoreNote([note]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NoNoteEditedToRestoredSqliteError>());
    });

    test('retornar um RestoreNoteSqliteError', () async {
      when(() => datasource.restoreNote(any()))
          .thenThrow(RestoreNoteSqliteErrorMock());

      final repository = NoteRepository(datasource);
      final result = await repository.restoreNote([note]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<RestoreNoteSqliteError>());
    });
  });

  group('note repository deleteNote | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.deleteNote(any())).thenAnswer(
        (_) async => 1,
      );

      final repository = NoteRepository(datasource);
      final result = await repository.deleteNote([note]);

      expect(result.isRight(), equals(true));
    });

    test('retornar um NoNoteEditedToDeletedSqliteError', () async {
      when(() => datasource.deleteNote(any()))
          .thenThrow(NoNoteEditedToDeletedSqliteError());

      final repository = NoteRepository(datasource);
      final result = await repository.deleteNote([note]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NoNoteEditedToDeletedSqliteError>());
    });

    test('retornar um DeleteNoteSqliteError', () async {
      when(() => datasource.deleteNote(any()))
          .thenThrow(DeleteNoteSqliteErrorMock());

      final repository = NoteRepository(datasource);
      final result = await repository.deleteNote([note]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<DeleteNoteSqliteError>());
    });
  });

  group('note repository deletePersistentNote | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.deletePersistentNote([note.entity])).thenAnswer(
        (_) async => 1,
      );

      final repository = NoteRepository(datasource);
      final result = await repository.deletePersistentNote([note]);

      expect(result.isRight(), equals(true));
    });

    test('retornar um DeleteNotePersistentSqliteError', () async {
      when(() => datasource.deletePersistentNote([note.entity]))
          .thenThrow(DeleteNotePersistentSqliteErrorMock());

      final repository = NoteRepository(datasource);
      final result = await repository.deletePersistentNote([note]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<DeleteNotePersistentSqliteError>());
    });
  });
}
