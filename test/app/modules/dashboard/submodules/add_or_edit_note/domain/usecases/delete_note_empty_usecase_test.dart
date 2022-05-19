import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/domain/errors/add_or_edit_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/add_or_edit_note/domain/usecases/delete_note_empty_usecase.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/note_model_stub.dart';

void main() {
  final note = note1;
  final repository = NoteRepositoryMock();

  test(
      'delete note empty usecase DeleteNoteEmptyUsecase.Call | isRight igual a True',
      () async {
    when(() => repository.deletePersistentNote(note)).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = DeleteNoteEmptyUsecase(repository);
    final result = await usecase.call(note);

    expect(result.isRight(), equals(true));
  });

  test(
      'delete note empty usecase DeleteNoteEmptyUsecase.Call | retorna DeleteNoteEmptySqliteError',
      () async {
    when(() => repository.deletePersistentNote(note)).thenAnswer(
      (_) async => Left(DeleteNoteEmptySqliteErrorMock()),
    );

    final usecase = DeleteNoteEmptyUsecase(repository);
    final result = await usecase.call(note);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<DeleteNoteEmptySqliteError>());
  });
}
