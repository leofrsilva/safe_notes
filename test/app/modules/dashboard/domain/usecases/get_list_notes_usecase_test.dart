import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/domain/errors/get_list_failures.dart';
import 'package:safe_notes/app/modules/dashboard/domain/usecases/get_list_notes_usecase.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../../../mocks/mocks_sqlite.dart';
import '../../../../../stub/note_model_stub.dart';

void main() {
  final repository = GetListRepositoryMock();

  test(
      'get list notes usecase GetListNotesUsecase.Call | retorna uma Stream de Lista de NoteModel',
      () {
    when(() => repository.getNotes()).thenAnswer(
      (_) => Right(Stream.value(listNotes)),
    );

    final usecase = GetListNotesUsecase(repository);
    final result = usecase.call();

    expect(result.isRight(), equals(true));
    expect(result.fold(id, id), isA<Stream<List<NoteModel>>>());
  });

  test(
      'get list notes usecase GetListNotesUsecase.Call | retorna GetListNotesSqliteError',
      () {
    when(() => repository.getNotes())
        .thenReturn(Left(GetListNotesSqliteErrorMock()));

    final usecase = GetListNotesUsecase(repository);
    final result = usecase.call();

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<GetListNotesSqliteError>());
  });
}
