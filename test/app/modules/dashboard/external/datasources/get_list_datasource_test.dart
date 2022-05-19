import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/external/datasources/get_list_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_get_list_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/daos/note_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/folder_model_stub.dart';
import '../../../../../stub/note_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;
  late NoteDAO noteDAO;
  late IGetListDatasource datasource;

  setUpAll(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
    noteDAO = database.noteDao;
    datasource = GetListDatasource(folderDAO, noteDAO);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('get list datasource getFoldersQtdChild | ', () {
    test('retorna uma Stream de Lista Vazia de FolderQtdChildView ', () async {
      final result = datasource.getFoldersQtdChild();
      final listFolders = await result.first;

      expect(result, isA<Stream<List<FolderQtdChildView>>>());
      expect(listFolders, isA<List<FolderQtdChildView>>());
      expect(listFolders.length, equals(0));
    });

    test('retorna uma Stream de Lista de FolderQtdChildView ', () async {
      int qtdFolders = listfolder.length;
      for (var folderer in listfolder) {
        folderDAO.insertFolder(folderer.entity);
      }

      final result = datasource.getFoldersQtdChild();
      final listFolders = await result.first;

      expect(result, isA<Stream<List<FolderQtdChildView>>>());
      expect(listFolders, isA<List<FolderQtdChildView>>());
      expect(listFolders.length, equals(qtdFolders));
    });

    test('retornar um GetListFoldersSqliteError', () async {
      final folderDAOMock = FolderDAOMock();
      final datasouceMock = GetListDatasource(folderDAOMock, noteDAO);

      when(() => folderDAOMock.getFoldersQtdChild())
          .thenThrow(SqliteExceptionMock());

      expect(
        () => datasouceMock.getFoldersQtdChild(),
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
      for (var folderer in listfolder) {
        var findFolder = await folderDAO.findFolder(folderer.folderId);
        if (findFolder == null) {
          await folderDAO.insertFolder(folderer.entity);
        }
      }
      int qtdNotes = listNote.length;
      for (var note in listNote) {
        await noteDAO.insertNote(note.entity);
      }

      final result = datasource.getNotes();
      final listNotes = await result.first;

      expect(result, isA<Stream<List<NoteEntity>>>());
      expect(listNotes, isA<List<NoteEntity>>());
      expect(listNotes.length, equals(qtdNotes));
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
