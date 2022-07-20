import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/note_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/note/delete_note_usecase.dart';

import '../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../stub/note_model_stub.dart';

void main() {
  final note = note1;
  final repository = NoteRepositoryMock();

  test('delete note usecase DeleteNoteUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.deleteNote([note])).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = DeleteNoteUsecase(repository);
    final result = await usecase.call([note]);

    expect(result.isRight(), equals(true));
  });

  test(
      'delete note usecase DeleteNoteUsecase.Call | retorna NoNoteEditedToDeletedSqliteError',
      () async {
    when(() => repository.deleteNote([note])).thenAnswer(
      (_) async => Left(NoNoteEditedToDeletedSqliteError()),
    );

    final usecase = DeleteNoteUsecase(repository);
    final result = await usecase.call([note]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<NoNoteEditedToDeletedSqliteError>());
  });

  test(
      'delete note usecase DeleteNoteUsecase.Call | retorna DeleteNoteSqliteError',
      () async {
    when(() => repository.deleteNote([note])).thenAnswer(
      (_) async => Left(DeleteNoteSqliteErrorMock()),
    );

    final usecase = DeleteNoteUsecase(repository);
    final result = await usecase.call([note]);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<DeleteNoteSqliteError>());
  });
}