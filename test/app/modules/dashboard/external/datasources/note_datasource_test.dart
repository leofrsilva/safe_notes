import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/note_failures.dart';
import 'package:safe_notes/app/modules/dashboard/external/datasources/note_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_note_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/folder_model_stub.dart';
import '../../../../../stub/note_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;
  late NoteDAO noteDAO;
  late INoteDatasource datasource;

  setUpAll(() async {
    initModule(AppModule());

    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
    for (var folder in listFolders) {
      await folderDAO.insertFolder(folder.entity);
    }

    noteDAO = database.noteDao;
    datasource = NoteDatasource(noteDAO);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('note datasource addNote |', () {
    late NoteEntity noteEntity;
    setUpAll(() => noteEntity = note1.entity);

    test('Adicionado uma Nota com Sucesso', () async {
      final result = await datasource.addNote(noteEntity);

      expect(result, equals(noteEntity.id));
    });

    test('retorna um AddNoteSqliteError', () async {
      final noteDAOMock = NoteDAOMock();
      final datasouceMock = NoteDatasource(noteDAOMock);

      when(() => noteDAOMock.insertNote(noteEntity))
          .thenThrow(SqliteExceptionMock());

      expect(
        () => datasouceMock.addNote(noteEntity),
        throwsA(isA<AddNoteSqliteError>()),
      );
    });

    test('retorna um NotReturnNoteIdSqliteError', () async {
      final noteDAOMock = NoteDAOMock();
      final datasouceMock = NoteDatasource(noteDAOMock);

      when(() => noteDAOMock.insertNote(noteEntity)).thenAnswer((_) async => 0);

      expect(
        () => datasouceMock.addNote(noteEntity),
        throwsA(isA<NotReturnNoteIdSqliteError>()),
      );
    });
  });

  group('note datasource editNote |', () {
    late NoteModel noteModel;
    setUpAll(() => noteModel = note2);

    test('Editou a Note com Sucesso', () async {
      await noteDAO.insertNote(noteModel.entity);

      var noteEdited = noteModel.copyWith(
        body: 'Body Edited',
        title: 'Title Edited',
        dateModification: DateTime.now(),
      );
      final result = await datasource.editNote([noteEdited.entity]);

      expect(result, equals(1));

      var noteResult = await noteDAO.findNote(noteModel.noteId);
      expect(noteResult, isNotNull);
      expect(noteResult!.title, equals(noteEdited.title));
      expect(noteResult.body, equals(noteEdited.body));
    });

    test('retorna um EditNoteSqliteError', () async {
      final noteDAOMock = NoteDAOExceptionMock();
      final datasouceMock = NoteDatasource(noteDAOMock);

      expect(
        () => datasouceMock.editNote([noteModel.entity]),
        throwsA(isA<EditNoteSqliteError>()),
      );
    });

    test('retorna um NoNoteRecordsChangedSqliteError', () async {
      final noteDAOMock = NoteDAONoUpdateFolderMock();
      final datasouceMock = NoteDatasource(noteDAOMock);

      expect(
        () => datasouceMock.editNote([noteModel.entity]),
        throwsA(isA<NoNoteRecordsChangedSqliteError>()),
      );
    });
  });

  group('note datasource restoreNote |', () {
    late NoteModel noteModel;
    setUpAll(() => noteModel = note4);

    test('retorna um NoNoteEditedToRestoredSqliteError', () async {
      final note = note3.copyWith(isDeleted: true);
      await noteDAO.insertNote(note.entity);

      expect(
        () => datasource.restoreNote([note.entity]),
        throwsA(isA<NoNoteEditedToRestoredSqliteError>()),
      );
    });

    test('atualização da exclusção para false com Sucesso', () async {
      await noteDAO.insertNote(noteModel.entity);

      noteModel = noteModel.copyWith(isDeleted: false);
      await datasource.restoreNote([noteModel.entity]);

      final noteResult = await noteDAO.findNote(noteModel.noteId);
      expect(noteResult, isNotNull);
      expect(noteResult!.id, equals(noteModel.noteId));
      expect(noteResult.isDeleted, equals(0));
    });

    test('retorna um RestoreNoteSqliteError', () async {
      final noteDAOMock = NoteDAOExceptionMock();
      final datasouceMock = NoteDatasource(noteDAOMock);

      expect(
        () => datasouceMock.restoreNote([noteModel.entity]),
        throwsA(isA<RestoreNoteSqliteError>()),
      );
    });
  });

  group('note datasource deleteNote |', () {
    late NoteModel noteModel;
    setUpAll(() => noteModel = note6);

    test('retorna um NoNoteEditedToDeletedSqliteError', () async {
      var note = note5.copyWith(isDeleted: false);
      await noteDAO.insertNote(note.entity);

      expect(
        () => datasource.deleteNote([note.entity]),
        throwsA(isA<NoNoteEditedToDeletedSqliteError>()),
      );
    });

    test('atualização da exclusção para true com Sucesso', () async {
      await noteDAO.insertNote(noteModel.entity);

      noteModel = noteModel.copyWith(
        isDeleted: true,
        dateDeletion: DateTime.now(),
      );
      await datasource.deleteNote([noteModel.entity]);

      final noteResult = await noteDAO.findNote(noteModel.noteId);
      expect(noteResult, isNotNull);
      expect(noteResult!.id, equals(noteModel.noteId));
      expect(noteResult.isDeleted, equals(1));
      expect(noteResult.dateDeletion, isNotNull);
    });

    test('retorna um DeleteNoteSqliteError', () async {
      final noteDAOMock = NoteDAOExceptionMock();
      final datasouceMock = NoteDatasource(noteDAOMock);

      noteModel = noteModel.copyWith(
        isDeleted: true,
        dateDeletion: DateTime.now(),
      );

      expect(
        () => datasouceMock.deleteNote([noteModel.entity]),
        throwsA(isA<DeleteNoteSqliteError>()),
      );
    });
  });

  group('note datasource deletePersistentNote |', () {
    late NoteModel noteModel;
    setUpAll(() => noteModel = note7.copyWith(title: '', body: ''));

    test('Deletando a Nota permanentemente com Sucesso', () async {
      await noteDAO.insertNote(noteModel.entity);

      await datasource.deletePersistentNote([noteModel.entity]);

      final noteResult = await noteDAO.findNote(noteModel.noteId);
      expect(noteResult, isNull);
    });

    test('retorna um DeleteNoteEmptySqliteError', () async {
      final noteDAOMock = NoteDAOExceptionMock();
      final datasouceMock = NoteDatasource(noteDAOMock);

      expect(
        () => datasouceMock.deletePersistentNote([noteModel.entity]),
        throwsA(isA<DeleteNotePersistentSqliteError>()),
      );
    });
  });
}
