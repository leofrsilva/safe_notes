import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/usecases/login_authentication_usecase.dart';

import '../../../../../../../mocks/mocks_firebase.dart';

void main() {
  const email = 'email';
  const pass = 'pass';
  final repository = GetinFirebaseRepositoryMock();

  test(
      'user firebase usecase LoginAuthenticationUsecase.Call | retornar um String UID do Auth Usuario',
      () async {
    const uid = 'testuid';

    when(() => repository.signIn(email, pass)).thenAnswer(
      (_) async => const Right(uid),
    );

    final usecase = LoginAuthenticationUsecase(repository);
    final result = await usecase.call(email, pass);

    expect(result.isRight(), equals(true));
    expect(result.fold(id, id), isA<String>());
  });

  test(
      'user firebase usecase LoginAuthenticationUsecase.Call | retornar um LoginAuthFirebaseError',
      () async {
    when(() => repository.signIn(email, pass))
        .thenAnswer((_) async => Left(LoginAuthFirebaseErrorMock()));

    final usecase = LoginAuthenticationUsecase(repository);
    final result = await usecase.call(email, pass);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<LoginAuthFirebaseError>());
  });

  test(
      'user firebase usecase LoginAuthenticationUsecase.Call | retornar um NoFoundUserInLoginAuthFirebase',
      () async {
    when(() => repository.signIn(email, pass))
        .thenAnswer((_) async => Left(NoFoundUserInLoginAuthFirebase()));

    final usecase = LoginAuthenticationUsecase(repository);
    final result = await usecase.call(email, pass);

    expect(result, isA<Left>());
    expect(result.fold(id, id), isA<NoFoundUserInLoginAuthFirebase>());
  });
}
