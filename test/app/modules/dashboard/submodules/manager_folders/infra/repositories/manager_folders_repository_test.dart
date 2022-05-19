import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/domain/errors/manager_folders_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/infra/repositories/manager_folders_repository.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/folder_model_stub.dart';

void main() {
  final folder = folder1;
  final datasource = ManagerFoldersDatasourceMock();

  group('manager folders repository addFolder | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.addFolder(folder.entity))
          .thenAnswer((_) async => 1);

      final repository = ManagerFoldersRepository(datasource);
      final result = await repository.addFolder(folder);

      expect(result.isRight(), equals(true));
    });

    test('retornar um AddFolderSqliteError', () async {
      when(() => datasource.addFolder(folder.entity))
          .thenThrow(AddFolderSqliteErrorMock());

      final repository = ManagerFoldersRepository(datasource);
      final result = await repository.addFolder(folder);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<AddFolderSqliteError>());
    });

    test('retornar um NotReturnFolderIdSqliteError', () async {
      when(() => datasource.addFolder(folder.entity))
          .thenThrow(NotReturnFolderIdSqliteErrorMock());

      final repository = ManagerFoldersRepository(datasource);
      final result = await repository.addFolder(folder);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NotReturnFolderIdSqliteError>());
    });
  });

  group('manager folders repository editFolder | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.addFolder(folder.entity))
          .thenAnswer((_) async => 1);

      final repository = ManagerFoldersRepository(datasource);
      final result = await repository.addFolder(folder);

      expect(result.isRight(), equals(true));
    });

    test('retornar um EditFolderSqliteError', () async {
      when(() => datasource.editFolder(folder))
          .thenThrow(EditFolderSqliteErrorMock());

      final repository = ManagerFoldersRepository(datasource);
      final result = await repository.editFolder(folder);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<EditFolderSqliteError>());
    });

    test('retornar um NoFolderRecordsChangedSqliteError', () async {
      when(() => datasource.editFolder(folder))
          .thenThrow(NoFolderRecordsChangedSqliteErrorMock());

      final repository = ManagerFoldersRepository(datasource);
      final result = await repository.editFolder(folder);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NoFolderRecordsChangedSqliteError>());
    });
  });

  group('manager folders repository deleteFolder | ', () {
    test('isRight igual a True', () async {
      final repository = ManagerFoldersRepository(datasource);
      final result = await repository.deleteFolder([folder]);

      expect(result.isRight(), equals(true));
    });

    test('retornar um DeleteFolderSqliteError', () async {
      final datasourceMock = ManagerFoldersDatasourceExceptionMock();

      final repository = ManagerFoldersRepository(datasourceMock);
      final result = await repository.deleteFolder([folder]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<DeleteFolderSqliteError>());
    });
  });
}
