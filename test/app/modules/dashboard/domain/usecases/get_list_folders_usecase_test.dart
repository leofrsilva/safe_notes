import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/folder_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/get_list_folders_usecase.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/folder_qtd_child_view.dart';

void main() {
  final repository = FolderRepositoryMock();

  test(
      'get list folders usecase GetListFoldersUsecase.Call | retorna uma Stream de Lista de FolderQtdChildView',
      () {
    when(() => repository.getFoldersQtdChild()).thenAnswer(
      (_) => Right(Stream.value(listfolderQtsChild)),
    );

    final usecase = GetListFoldersUsecase(repository);
    final result = usecase.call();

    expect(result.isRight(), equals(true));
    expect(result.fold(id, id), isA<Stream<List<FolderQtdChildView>>>());
  });

  test(
      'get list folders usecase GetListFoldersUsecase.Call | retorna GetListFoldersSqliteError',
      () {
    when(() => repository.getFoldersQtdChild())
        .thenReturn(Left(GetListFoldersSqliteErrorMock()));

    final usecase = GetListFoldersUsecase(repository);
    final result = usecase.call();

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<GetListFoldersSqliteError>());
  });
}
