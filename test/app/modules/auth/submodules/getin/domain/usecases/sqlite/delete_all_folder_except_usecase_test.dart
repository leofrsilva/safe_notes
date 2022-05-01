import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/usecases/sqlite/delete_all_folder_except_usecase.dart';

import '../../../../../../../../mocks/mocks_sqlite.dart';

void main() {
  const folderId = 1000;
  final repository = DeleteFolderRepositoryMock();

  test(
      'delete all folder except usecase DeleteAllFolderExceptUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.deleteAllFolderExcept(folderId))
        .thenAnswer((_) async => const Right(dynamic));

    final usecase = DeleteAllFolderExceptUsecase(repository);
    final result = await usecase.call(folderId);

    expect(result.isRight(), equals(true));
  });

  test(
      'delete all folder except usecase DeleteAllFolderExceptUsecase.Call | retorna um DeleteAllFolderExceptSqliteError',
      () async {
    when(() => repository.deleteAllFolderExcept(folderId))
        .thenAnswer((_) async => Left(DeleteAllFolderExceptSqliteErrorMock()));

    final usecase = DeleteAllFolderExceptUsecase(repository);
    final result = await usecase.call(folderId);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<DeleteAllFolderExceptSqliteError>());
  });
}
