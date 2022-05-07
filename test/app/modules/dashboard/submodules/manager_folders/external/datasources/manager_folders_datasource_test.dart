import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/domain/errors/manager_folders_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/external/datasources/manager_folders_datasource.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/infra/datasources/i_manager_folders_datasource.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/folder_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;
  late IManagerFoldersDatasource datasource;

  setUpAll(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
    await folderDAO.insertFolder(folder.entity);

    datasource = ManagerFoldersDatasource(folderDAO);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('manager folders datasource addFolder |', () {
    final folderEntity = folder4.entity;

    test('Adicionado uma Pasta com Sucesso', () async {
      final result = await datasource.addFolder(folderEntity);

      expect(result, equals(folderEntity.id));
    });

    test('retorna um AddFolderSqliteError', () async {
      final folderDAOMock = FolderDAOMock();
      final datasouceMock = ManagerFoldersDatasource(folderDAOMock);

      when(() => folderDAOMock.insertFolder(folderEntity))
          .thenThrow(SqliteExceptionMock());

      expect(
        () => datasouceMock.addFolder(folderEntity),
        throwsA(isA<AddFolderSqliteError>()),
      );
    });

    test('retorna um NotReturnFolderIdSqliteError', () async {
      final folderDAOMock = FolderDAOMock();
      final datasouceMock = ManagerFoldersDatasource(folderDAOMock);

      when(() => folderDAOMock.insertFolder(folderEntity))
          .thenAnswer((_) async => 0);

      expect(
        () => datasouceMock.addFolder(folderEntity),
        throwsA(isA<NotReturnFolderIdSqliteError>()),
      );
    });
  });

  group('manager folders datasource editFolder |', () {
    final folderEntity = folder2.entity;

    test('Editou a Pasta com Sucesso', () async {
      await folderDAO.insertFolder(folderEntity);

      var folderEdited = folder2.copyWith(
        color: 222222,
        name: 'Folder Edited',
      );
      final result = await datasource.editFolder(folderEdited.entity);

      expect(result, equals(1));

      var folderResult = await folderDAO.findFolder(folderEntity.id);
      expect(folderResult, isNotNull);
      expect(folderResult!.name, equals(folderEdited.name));
      expect(folderResult.color, equals(folderEdited.color));
    });

    test('retorna um EditFolderSqliteError', () async {
      final folderDAOMock = FolderDAOExceptionMock();
      final datasouceMock = ManagerFoldersDatasource(folderDAOMock);

      when(() => folderDAOMock.findFolder(folderEntity.id))
          .thenAnswer((_) async => folderEntity);
      expect(
        () => datasouceMock.editFolder(folderEntity),
        throwsA(isA<EditFolderSqliteError>()),
      );

      when(() => folderDAOMock.findFolder(folderEntity.id))
          .thenThrow(SqliteExceptionMock());
      expect(
        () => datasouceMock.editFolder(folderEntity),
        throwsA(isA<EditFolderSqliteError>()),
      );
    });

    test('retorna um NoFolderRecordsChangedSqliteError', () async {
      final folderDAOMock = FolderDAONoUpdateFolderMock();
      final datasouceMock = ManagerFoldersDatasource(folderDAOMock);

      when(() => folderDAOMock.findFolder(folderEntity.id))
          .thenAnswer((_) async => folderEntity);
      expect(
        () => datasouceMock.editFolder(folderEntity),
        throwsA(isA<NoFolderRecordsChangedSqliteError>()),
      );

      when(() => folderDAOMock.findFolder(folderEntity.id))
          .thenAnswer((_) async => null);
      expect(
        () => datasouceMock.editFolder(folderEntity),
        throwsA(isA<NoFolderRecordsChangedSqliteError>()),
      );
    });
  });

  group('manager folders datasource deleteFolder |', () {
    test('Deletado a Pasta e seus filhos com Sucesso', () async {
      await folderDAO.insertFolder(folder1.entity);
      await folderDAO.insertFolder(folder11.entity);
      await folderDAO.insertFolder(folder111.entity);
      await folderDAO.insertFolder(folder1111.entity);

      await datasource.deleteFolder(folder1.folderId);

      var folder = await folderDAO.findFolder(folder1111.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(1));
      folder = await folderDAO.findFolder(folder111.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(1));
      folder = await folderDAO.findFolder(folder11.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(1));
      folder = await folderDAO.findFolder(folder1.folderId);
      expect(folder, isNotNull);
      expect(folder!.isDeleted, equals(1));
    });

    test('retorna um DeleteFolderSqliteError', () {
      final folderDAOMock = FolderDAOExceptionMock();
      final datasouceMock = ManagerFoldersDatasource(folderDAOMock);

      expect(
        () => datasouceMock.deleteFolder(folder1.folderId),
        throwsA(isA<DeleteFolderSqliteError>()),
      );
    });
  });
}
