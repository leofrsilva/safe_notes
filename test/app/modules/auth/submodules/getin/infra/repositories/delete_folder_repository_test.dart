import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/infra/repositories/delete_folder_repository.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';

void main() {
  final datasource = DeleteFolderDatasourceMock();

  group('delete folder repository deleteAllFolderExcept | ', () {
    const folderId = 1000;

    test('isRight igual a True', () async {
      when(() => datasource.deleteAllFolderExcept(folderId))
          .thenAnswer((_) async => dynamic);

      final repository = DeleteFolderRepository(datasource);
      final result = await repository.deleteAllFolderExcept(folderId);

      expect(result.isRight(), equals(true));
    });

    test('retornar um DeleteAllFolderExceptSqliteError', () async {
      when(() => datasource.deleteAllFolderExcept(folderId))
          .thenThrow(DeleteAllFolderExceptSqliteErrorMock());

      final repository = DeleteFolderRepository(datasource);
      final result = await repository.deleteAllFolderExcept(folderId);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<DeleteAllFolderExceptSqliteError>());
    });
  });
}
