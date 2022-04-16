import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/domain/errors/signup_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/domain/usecases/create_authentication_usecase.dart';

import '../../../../../../../mocks/mocks_firebase.dart';

void main() {
  const email = 'email';
  const pass = 'pass';
  final repository = SignupFirebaseRepositoryMock();

  test(
      'user firebase usecase CreateUserAuthenticationUsecase.Call | retornar um String UID do Auth Usuario',
      () async {
    const uid = 'testuid';

    when(() => repository.signUp(email, pass)).thenAnswer(
      (_) async => const Right(uid),
    );

    final usecase = CreateUserAuthenticationUsecase(repository);
    final result = await usecase.call(email, pass);

    expect(result.isRight(), equals(true));
    expect(result.fold(id, id), isA<String>());
    expect(result.fold(id, id), equals(uid));
  });

  test(
      'user firebase usecase CreateUserAuthenticationUsecase.Call | retornar um CreateUserAuthFirebaseError',
      () async {
    when(() => repository.signUp(email, pass))
        .thenAnswer((_) async => Left(CreateUserAuthFirebaseErrorMock()));

    final usecase = CreateUserAuthenticationUsecase(repository);
    final result = await usecase.call(email, pass);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<CreateUserAuthFirebaseError>());
  });

  test(
      'user firebase usecase CreateUserAuthenticationUsecase.Call | retornar um NoFoundUserInCreateUserAuthFirebase',
      () async {
    when(() => repository.signUp(email, pass))
        .thenAnswer((_) async => Left(NoFoundUserInCreateUserAuthFirebase()));

    final usecase = CreateUserAuthenticationUsecase(repository);
    final result = await usecase.call(email, pass);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<NoFoundUserInCreateUserAuthFirebase>());
  });
}
