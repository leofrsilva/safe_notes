import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/external/datasources/set_folder_datasource.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/infra/datasources/i_set_folder_datasource.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/folder_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;
  late ISetFolderDatasource datasource;

  setUpAll(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
    datasource = SetFolderDatasource(folderDAO);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('set folder datasource setDefaultFolder | ', () {
    test('Sucesso no cadastro de Folder Default', () async {
      expect(datasource.setDefaultFolder(folder.entity), completes);
    });

    test('retornar um SetFolderSqliteError', () async {
      final folderDAOMock = FolderDAOMock();
      final datasourceMock = SetFolderDatasource(folderDAOMock);

      when(() => folderDAOMock.insertFolder(folder2.entity))
          .thenThrow(SqliteExceptionMock());

      expect(
        () => datasourceMock.setDefaultFolder(folder2.entity),
        throwsA(isA<SetFolderSqliteError>()),
      );
    });
  });
}
