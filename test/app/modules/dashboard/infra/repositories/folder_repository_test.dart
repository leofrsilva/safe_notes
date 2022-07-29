import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/infra/repositories/folder_repository.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/folder_model_stub.dart';

void main() {
  late FolderModel folder;
  final datasource = FolderDatasourceMock();

  setUpAll(() {
    initModule(AppModule());
    folder = folder1;
  });

  group('folder repository addFolder | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.addFolders([folder.entity]))
          .thenAnswer((_) async => [1]);

      final repository = FolderRepository(datasource);
      final result = await repository.addFolders([folder]);

      expect(result.isRight(), equals(true));
    });

    test('retornar um AddFolderSqliteError', () async {
      when(() => datasource.addFolders([folder.entity]))
          .thenThrow(AddFolderSqliteErrorMock());

      final repository = FolderRepository(datasource);
      final result = await repository.addFolders([folder]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<AddFolderSqliteError>());
    });

    test('retornar um NotReturnFolderIdSqliteError', () async {
      when(() => datasource.addFolders([folder.entity]))
          .thenThrow(NotReturnFolderIdSqliteErrorMock());

      final repository = FolderRepository(datasource);
      final result = await repository.addFolders([folder]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NotReturnFolderIdSqliteError>());
    });
  });

  group('folder repository editFolder | ', () {
    test('isRight igual a True', () async {
      when(() => datasource.addFolders([folder.entity]))
          .thenAnswer((_) async => [1]);

      final repository = FolderRepository(datasource);
      final result = await repository.addFolders([folder]);

      expect(result.isRight(), equals(true));
    });

    test('retornar um EditFolderSqliteError', () async {
      when(() => datasource.editFolder(folder))
          .thenThrow(EditFolderSqliteErrorMock());

      final repository = FolderRepository(datasource);
      final result = await repository.editFolder(folder);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<EditFolderSqliteError>());
    });

    test('retornar um NoFolderRecordsChangedSqliteError', () async {
      when(() => datasource.editFolder(folder))
          .thenThrow(NoFolderRecordsChangedSqliteErrorMock());

      final repository = FolderRepository(datasource);
      final result = await repository.editFolder(folder);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NoFolderRecordsChangedSqliteError>());
    });
  });

  group('folder repository deleteFolder | ', () {
    test('isRight igual a True', () async {
      final repository = FolderRepository(datasource);
      final result = await repository.deleteFolder([folder]);

      expect(result.isRight(), equals(true));
    });

    test('retornar um NoFolderEditedToDeletedSqliteError', () async {
      final datasourceMock = FolderDatasourceOutherExceptionMock();

      final repository = FolderRepository(datasourceMock);
      final result = await repository.deleteFolder([folder]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NoFolderEditedToDeletedSqliteError>());
    });

    test('retornar um DeleteFolderSqliteError', () async {
      final datasourceMock = FolderDatasourceExceptionMock();

      final repository = FolderRepository(datasourceMock);
      final result = await repository.deleteFolder([folder]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<DeleteFolderSqliteError>());
    });
  });

  group('folder repository restoreFolder | ', () {
    test('isRight igual a True', () async {
      final repository = FolderRepository(datasource);
      final result = await repository.restoreFolder([folder]);

      expect(result.isRight(), equals(true));
    });

    test('retornar um NoFolderEditedToRestoredSqliteError', () async {
      final datasourceMock = FolderDatasourceOutherExceptionMock();

      final repository = FolderRepository(datasourceMock);
      final result = await repository.restoreFolder([folder]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<NoFolderEditedToRestoredSqliteError>());
    });

    test('retornar um RestoreFolderSqliteError', () async {
      final datasourceMock = FolderDatasourceExceptionMock();

      final repository = FolderRepository(datasourceMock);
      final result = await repository.restoreFolder([folder]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<RestoreFolderSqliteError>());
    });
  });

  group('folder repository deletePersistentFolder | ', () {
    test('isRight igual a True', () async {
      final repository = FolderRepository(datasource);
      final result = await repository.deletePersistentFolder([folder]);

      expect(result.isRight(), equals(true));
    });

    test('retornar um DeleteFolderPersistentSqliteError', () async {
      final datasourceMock = FolderDatasourceExceptionMock();

      final repository = FolderRepository(datasourceMock);
      final result = await repository.deletePersistentFolder([folder]);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<DeleteFolderPersistentSqliteError>());
    });
  });
}
