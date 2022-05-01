import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/external/datasources/delete_folder_datasource.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/infra/datasources/i_delete_folder_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/folder_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;
  late IDeleteFolderDatasource datasource;

  setUpAll(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
    datasource = DeleteFolderDatasource(folderDAO);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('delete folder datasource deleteAllFolderExcept |', () {
    test('Delete all Except Default Folder', () async {
      for (var folderer in listfolder) {
        folderDAO.insertFolder(folderer.entity);
      }

      await datasource.deleteAllFolderExcept(listfolder.first.folderId);

      final stream = folderDAO.getFoldersQtdChild();
      final listFolder = await stream.first;

      expect(listFolder.length, equals(1));
    });

    test('retorna um DeleteAllFolderExceptSqliteError', () async {
      final folderDAOMock = FolderDAOMock();
      final datasouceMock = DeleteFolderDatasource(folderDAOMock);

      when(() => folderDAOMock.deleteAllExcept(listfolder.first.folderId))
          .thenThrow(SqliteExceptionMock());

      expect(
        () => datasouceMock.deleteAllFolderExcept(listfolder.first.folderId),
        throwsA(isA<DeleteAllFolderExceptSqliteError>()),
      );
    });
  });
}
