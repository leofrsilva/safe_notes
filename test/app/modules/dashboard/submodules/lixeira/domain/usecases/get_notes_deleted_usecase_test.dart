import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/lixeira/domain/errors/lixeira_failures.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/lixeira/domain/usecases/get_notes_deleted_usecase.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../../../../../mocks/mocks_sqlite.dart';
import '../../../../../../../stub/note_model_stub.dart';

void main() {
  final repository = LixeiraRepositoryMock();

  test(
      'get notes deleted usecase GetNotesDeletedUsecase.Call | retorna uma Lista de NoteModel',
      () async {
    when(() => repository.getNotesDeleted()).thenAnswer(
      (_) async => Right(listNote),
    );

    final usecase = GetNotesDeletedUsecase(repository);
    final result = await usecase.call();

    expect(result.isRight(), equals(true));
    expect(result.fold(id, id), isA<List<NoteModel>>());
    expect(
      (result.fold(id, id) as List<NoteModel>).length,
      equals(4),
    );
  });

  test(
      'get notes deleted usecase GetNotesDeletedUsecase.Call | retorna um GetNotesDeletedSqliteError',
      () async {
    when(() => repository.getNotesDeleted()).thenAnswer(
      (_) async => Left(GetNotesDeletedSqliteErrorMock()),
    );

    final usecase = GetNotesDeletedUsecase(repository);
    final result = await usecase.call();

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<GetNotesDeletedSqliteError>());
  });
}
