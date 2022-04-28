import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/infra/repositories/set_folder_repository.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';

void main() {
  group('set folder repository setDefaultFolder | ', () {
    const docRef = 'docRef';

    test('isRight igual a True', () async {
      final datasource = RightSetFolderDatasourceMock();

      final repository = SetFolderRepository(datasource);
      final result = await repository.setDefaultFolder(docRef);

      expect(result.isRight(), equals(true));
    });

    test('retornar um SetFolderSqliteError', () async {
      final datasource = LeftSetFolderDatasourceMock();

      final repository = SetFolderRepository(datasource);
      final result = await repository.setDefaultFolder(docRef);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<SetFolderSqliteError>());
    });
  });
}
