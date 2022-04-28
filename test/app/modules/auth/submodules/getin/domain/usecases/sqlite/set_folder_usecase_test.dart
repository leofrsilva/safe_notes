import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/usecases/sqlite/set_folder_usecase.dart';

import '../../../../../../../../mocks/mocks_sqlite.dart';

void main() {
  const uid = 'docRef';
  final repository = SetFolderRepositoryMock();

  test('set folder usecase SetFolderUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.setDefaultFolder(uid))
        .thenAnswer((_) async => const Right(dynamic));

    final usecase = SetFolderUsecase(repository);
    final result = await usecase.call(uid);

    expect(result.isRight(), equals(true));
  });

  test(
      'set folder usecase SetFolderUsecase.Call | retornou um SetFolderSqliteError',
      () async {
    when(() => repository.setDefaultFolder(uid))
        .thenAnswer((_) async => Left(SetFolderSqliteErrorMock()));

    final usecase = SetFolderUsecase(repository);
    final result = await usecase.call(uid);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<SetFolderSqliteError>());
  });
}
