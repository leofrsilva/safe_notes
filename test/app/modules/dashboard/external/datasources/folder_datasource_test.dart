import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/external/datasources/folder_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/infra/datasources/i_folder_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/folder_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;
  late IFolderDatasource datasource;

  setUpAll(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
    datasource = FolderDatasource(folderDAO);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('folder datasource getFoldersQtdChild | ', () {
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
      final datasouceMock = FolderDatasource(folderDAOMock);

      when(() => folderDAOMock.getFoldersQtdChild())
          .thenThrow(SqliteExceptionMock());

      expect(
        () => datasouceMock.getFoldersQtdChild(),
        throwsA(isA<GetListFoldersSqliteError>()),
      );
    });
  });
}
