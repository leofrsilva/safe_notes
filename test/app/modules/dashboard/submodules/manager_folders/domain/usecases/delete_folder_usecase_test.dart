import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/domain/errors/manager_folders_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/manager_folders/domain/usecases/delete_folder_usecase.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/folder_model_stub.dart';

void main() {
  final folder = folder1;
  final repository = ManagerFoldersRepositoryMock();

  test('delete folder usecase DeleteFolderUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.deleteFolder(folder.folderId)).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = DeleteFolderUsecase(repository);
    final result = await usecase.call(folder.folderId);

    expect(result.isRight(), equals(true));
  });

  test(
      'delete folder usecase DeleteFolderUsecase.Call | retorna DeleteFolderSqliteError',
      () async {
    when(() => repository.deleteFolder(folder.folderId)).thenAnswer(
      (_) async => Left(DeleteFolderSqliteErrorMock()),
    );

    final usecase = DeleteFolderUsecase(repository);
    final result = await usecase.call(folder.folderId);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<DeleteFolderSqliteError>());
  });
}
