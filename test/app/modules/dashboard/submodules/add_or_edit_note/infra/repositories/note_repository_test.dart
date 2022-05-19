import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/domain/errors/add_or_edit_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/infra/repositories/note_repository.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/note_model_stub.dart';

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
      when(() => datasource.editNote(note.entity)).thenAnswer((_) async => 1);

      final repository = NoteRepository(datasource);
      final result = await repository.editNote(note);

      expect(result.isRight(), equals(true));
    });

    test('retornar um EditNoteSqliteError', () async {
      when(() => datasource.editNote(note.entity))
          .thenThrow(EditNoteSqliteErrorMock());

      final repository = NoteRepository(datasource);
      final result = await repository.editNote(note);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<EditNoteSqliteError>());
    });

    test('retornar um NoNoteRecordsChangedSqliteError', () async {
      when(() => datasource.editNote(note.entity))
          .thenThrow(NoNoteRecordsChangedSqliteError());

      final repository = NoteRepository(datasource);
      final result = await repository.editNote(note);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NoNoteRecordsChangedSqliteError>());
    });
  });

  group('note repository deletePersistentNote | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.deletePersistentNote(note.entity)).thenAnswer(
        (_) async => 1,
      );

      final repository = NoteRepository(datasource);
      final result = await repository.deletePersistentNote(note);

      expect(result.isRight(), equals(true));
    });

    test('retornar um DeleteNoteEmptySqliteError', () async {
      when(() => datasource.deletePersistentNote(note.entity))
          .thenThrow(DeleteNoteEmptySqliteErrorMock());

      final repository = NoteRepository(datasource);
      final result = await repository.deletePersistentNote(note);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<DeleteNoteEmptySqliteError>());
    });
  });
}
