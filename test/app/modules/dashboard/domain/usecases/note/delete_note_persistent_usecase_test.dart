import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/note_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/note/delete_note_persistent_usecase.dart';

import '../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../stub/note_model_stub.dart';

void main() {
  final note = note1;
  final repository = NoteRepositoryMock();

  test(
      'delete note persistent usecase DeleteNotePersistentUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.deletePersistentNote([note])).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = DeleteNotePersistentUsecase(repository);
    final result = await usecase.call([note]);

    expect(result.isRight(), equals(true));
  });

  test(
      'delete note persistent usecase DeleteNotePersistentUsecase.Call | retorna DeleteNotePersistentSqliteError',
      () async {
    when(() => repository.deletePersistentNote([note])).thenAnswer(
      (_) async => Left(DeleteNotePersistentSqliteErrorMock()),
    );

    final usecase = DeleteNotePersistentUsecase(repository);
    final result = await usecase.call([note]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<DeleteNotePersistentSqliteError>());
  });
}