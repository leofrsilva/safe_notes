import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/register_key/domain/errors/register_key_failure.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/register_key/domain/usecases/save_key_usecase.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../../../../../../../mocks/mocks_save_key.dart';
import '../../../../../../../stub/usuario_entity_stub.dart';

void main() {
  var keyText = 'val1';
  UsuarioModel user = UsuarioModel.fromEntity(user0);

  final repository = SaveKeyRepositoryMock();

  test('save key usecase SaveKeyUsecase.Call | isRight igual a True', () async {
    when(() => repository.saveKey(user, keyText)).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = SaveKeyUsecase(repository);
    final result = await usecase.call(user, keyText);

    expect(result.isRight(), equals(true));
  });

  test('save key usecase SaveKeyUsecase.Call | retorna SaveKeyFirestoreError',
      () async {
    when(() => repository.saveKey(user, keyText)).thenAnswer(
      (_) async => Left(SaveKeyFirestoreErrorMock()),
    );

    final usecase = SaveKeyUsecase(repository);
    final result = await usecase.call(user, keyText);

    expect(result.isLeft(), equals(true));
    expect(result.fold(id, id), isA<SaveKeyFirestoreError>());
  });
}
