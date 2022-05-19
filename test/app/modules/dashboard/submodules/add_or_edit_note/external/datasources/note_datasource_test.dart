import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/domain/errors/add_or_edit_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/external/datasources/note_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/infra/datasources/i_note_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/folder_model_stub.dart';
import '../../../../../../../stub/note_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;
  late NoteDAO noteDAO;
  late INoteDatasource datasource;

  setUpAll(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
    for (var folder in listfolder) {
      await folderDAO.insertFolder(folder.entity);
    }

    noteDAO = database.noteDao;
    datasource = NoteDatasource(noteDAO);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('note datasource addNote |', () {
    final noteEntity = note1.entity;

    test('Adicionado um a Nota com Sucesso', () async {
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
    final noteModel = note2;

    test('Editou a Note com Sucesso', () async {
      await noteDAO.insertNote(noteModel.entity);

      var noteEdited = noteModel.copyWith(
        body: 'Body Edited',
        title: 'Title Edited',
        dateModification: DateTime.now(),
      );
      final result = await datasource.editNote(noteEdited.entity);

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
        () => datasouceMock.editNote(noteModel.entity),
        throwsA(isA<EditNoteSqliteError>()),
      );
    });

    test('retorna um NoNoteRecordsChangedSqliteError', () async {
      final noteDAOMock = NoteDAONoUpdateFolderMock();
      final datasouceMock = NoteDatasource(noteDAOMock);

      expect(
        () => datasouceMock.editNote(noteModel.entity),
        throwsA(isA<NoNoteRecordsChangedSqliteError>()),
      );
    });
  });

  group('note datasource deletePersistentNote |', () {
    final noteModel = note3.copyWith(title: '', body: '');

    test('Deletando a Nota vazia com Sucesso', () async {
      await noteDAO.insertNote(noteModel.entity);

      await datasource.deletePersistentNote(noteModel.entity);

      final noteResult = await noteDAO.findNote(noteModel.noteId);
      expect(noteResult, isNull);
    });

    test('retorna um DeleteNoteEmptySqliteError', () async {
      final noteDAOMock = NoteDAOExceptionMock();
      final datasouceMock = NoteDatasource(noteDAOMock);

      expect(
        () => datasouceMock.deletePersistentNote(noteModel.entity),
        throwsA(isA<DeleteNoteEmptySqliteError>()),
      );
    });
  });
}
