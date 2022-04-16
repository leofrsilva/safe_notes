import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/domain/errors/signup_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/domain/usecases/set_user_firestore_usecase.dart';

import '../../../../../../../mocks/mocks.dart';
import '../../../../../../../mocks/mocks_firebase.dart';

void main() {
  final entity = UsuarioEntityMock();
  final repository = SignupFirebaseRepositoryMock();

  test(
      'user firebase usecase SetUserFirestoreUsecase.Call | isRight igual a True, preenchimento feito com sucesso',
      () async {
    when(() => repository.insertUserFirestore(entity)).thenAnswer(
      (_) async => const Right(dynamic),
    );

    final usecase = SetUserFirestoreUsecase(repository);
    final result = await usecase.call(entity);

    expect(result.isRight(), equals(true));
  });

  test(
      'user firebase usecase SetUserFirestoreUsecase.Call | retornar um SignupFirestoreError',
      () async {
    when(() => repository.insertUserFirestore(entity))
        .thenAnswer((_) async => Left(SignupFirestoreErrorMock()));

    final usecase = SetUserFirestoreUsecase(repository);
    final result = await usecase.call(entity);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<SignupFirestoreError>());
  });
}
