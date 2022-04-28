import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/infra/repositories/folder_repository.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/folder_qtd_child_view.dart';

void main() {
  final datasource = FolderDatasourceMock();

  group('folder repository getFoldersQtdChild | ', () {
    test('retorna uma Stream de Lista de FolderQtdChildView', () async {
      when(() => datasource.getFoldersQtdChild())
          .thenAnswer((_) => Stream.value(listfolderQtsChild));

      final repository = FolderRepository(datasource);
      final result = repository.getFoldersQtdChild();

      expect(result.isRight(), equals(true));
      expect(result.fold(id, id), isA<Stream<List<FolderQtdChildView>>>());
    });

    test('retornar um GetListFoldersSqliteError', () {
      when(() => datasource.getFoldersQtdChild())
          .thenThrow(GetListFoldersSqliteErrorMock());

      final repository = FolderRepository(datasource);
      final result = repository.getFoldersQtdChild();

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<GetListFoldersSqliteError>());
    });
  });
}
