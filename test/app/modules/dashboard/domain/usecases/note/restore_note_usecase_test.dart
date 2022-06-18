import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/note_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/note/restore_note_usecase.dart';

import '../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../stub/note_model_stub.dart';

void main() {
  final note = note1;
  final repository = NoteRepositoryMock();

  test('restore note usecase RestoreNoteUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.restoreNote([note])).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = RestoreNoteUsecase(repository);
    final result = await usecase.call([note]);

    expect(result.isRight(), equals(true));
  });

  test(
      'restore note usecase RestoreNoteUsecase.Call | retorna NoNoteEditedToRestoredSqliteError',
      () async {
    when(() => repository.restoreNote([note])).thenAnswer(
      (_) async => Left(NoNoteEditedToRestoredSqliteError()),
    );

    final usecase = RestoreNoteUsecase(repository);
    final result = await usecase.call([note]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<NoNoteEditedToRestoredSqliteError>());
  });

  test(
      'restore note usecase RestoreNoteUsecase.Call | retorna RestoreNoteSqliteError',
      () async {
    when(() => repository.restoreNote([note])).thenAnswer(
      (_) async => Left(RestoreNoteSqliteErrorMock()),
    );

    final usecase = RestoreNoteUsecase(repository);
    final result = await usecase.call([note]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<RestoreNoteSqliteError>());
  });
}
