import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/get_list_failures.dart';
import 'package:safe_notes/app/modules/dashboard/external/datasources/get_list_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_get_list_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/folder_model_stub.dart';
import '../../../../../stub/note_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;
  late NoteDAO noteDAO;
  late IGetListDatasource datasource;

  setUpAll(() async {
    initModule(AppModule());

    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
    noteDAO = database.noteDao;
    datasource = GetListDatasource(folderDAO, noteDAO);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('get list datasource getFolders | ', () {
    test('retorna uma Stream de Lista Vazia de FolderEntity ', () async {
      final result = datasource.getFolders();
      final listFolders = await result.first;

      expect(result, isA<Stream<List<FolderEntity>>>());
      expect(listFolders, isA<List<FolderEntity>>());
      expect(listFolders.length, equals(0));
    });

    test('retorna uma Stream de Lista de FolderEntity ', () async {
      int qtdFolders = listFolders.length;
      for (var folderer in listFolders) {
        folderDAO.insertFolder(folderer.entity);
      }

      final result = datasource.getFolders();
      final folders = await result.first;

      expect(result, isA<Stream<List<FolderEntity>>>());
      expect(folders, isA<List<FolderEntity>>());
      expect(folders.length, equals(qtdFolders));
    });

    test('retornar um GetListFoldersSqliteError', () async {
      final folderDAOMock = FolderDAOMock();
      final datasouceMock = GetListDatasource(folderDAOMock, noteDAO);

      when(() => folderDAOMock.getFolders()).thenThrow(SqliteExceptionMock());

      expect(
        () => datasouceMock.getFolders(),
        throwsA(isA<GetListFoldersSqliteError>()),
      );
    });
  });

  group('get list datasource getNotes | ', () {
    test('retorna uma Stream de Lista Vazia de NoteEntity ', () async {
      final result = datasource.getNotes();
      final listNotes = await result.first;

      expect(result, isA<Stream<List<NoteEntity>>>());
      expect(listNotes, isA<List<NoteEntity>>());
      expect(listNotes.length, equals(0));
    });

    test('retorna uma Stream de Lista de NoteEntity ', () async {
      for (var folderer in listFolders) {
        var findFolder = await folderDAO.findFolder(folderer.folderId);
        if (findFolder == null) {
          await folderDAO.insertFolder(folderer.entity);
        }
      }
      int qtdNotes = listNotes.length;
      for (var note in listNotes) {
        await noteDAO.insertNote(note.entity);
      }

      final result = datasource.getNotes();
      final notes = await result.first;

      expect(result, isA<Stream<List<NoteEntity>>>());
      expect(notes, isA<List<NoteEntity>>());
      expect(notes.length, equals(qtdNotes));
    });

    test('retornar um GetListNotesSqliteError', () async {
      final noteDAOMock = NoteDAOMock();
      final datasouceMock = GetListDatasource(folderDAO, noteDAOMock);

      when(() => noteDAOMock.getNotes()).thenThrow(SqliteExceptionMock());

      expect(
        () => datasouceMock.getNotes(),
        throwsA(isA<GetListNotesSqliteError>()),
      );
    });
  });
}
