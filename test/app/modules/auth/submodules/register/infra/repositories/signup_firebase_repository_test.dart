import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/domain/errors/signup_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/infra/repositories/signup_firebase_repository.dart';

import '../../../../../../../mocks/mocks_firebase.dart';
import '../../../../../../../stub/usuario_entity_stub.dart';

void main() {
  final datasource = SignupFirebaseDatasourceMock();

  group('signup firebase repository signUp | ', () {
    const email = 'email';
    const pass = 'pass';

    test('retornar um String UID do Auth Usuario', () async {
      const uid = 'uid';

      when(() => datasource.signUp(email, pass)).thenAnswer(
        (_) async => uid,
      );

      final repository = SignupFirebaseRepository(datasource);
      final result = await repository.signUp(email, pass);

      expect(result.isRight(), equals(true));
      expect(result.fold(id, id), isA<String>());
      expect(result.fold(id, id), equals(uid));
    });

    test('retornar um CreateUserAuthFirebaseError', () async {
      when(() => datasource.signUp(email, pass))
          .thenThrow(CreateUserAuthFirebaseErrorMock());

      final repository = SignupFirebaseRepository(datasource);
      final result = await repository.signUp(email, pass);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<CreateUserAuthFirebaseError>());
    });

    test('retornar um NoFoundUserInCreateUserAuthFirebase', () async {
      when(() => datasource.signUp(email, pass))
          .thenThrow(NoFoundUserInCreateUserAuthFirebase());

      final repository = SignupFirebaseRepository(datasource);
      final result = await repository.signUp(email, pass);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<NoFoundUserInCreateUserAuthFirebase>());
    });
  });

  group('signup firebase repository insertUserFirestore | ', () {
    final entity = user0;

    test('isRight igual a True, preenchimento feito com sucesso', () async {
      final datasourceRight = RightSignupFirebaseDatasourceMock();

      final repository = SignupFirebaseRepository(datasourceRight);
      final result = await repository.insertUserFirestore(entity);

      expect(result.isRight(), equals(true));
      expect(result.fold(id, id), isA<dynamic>());
    });

    test('retornar um SignupFirestoreError', () async {
      final datasourceLeft = LeftSignupFirebaseDatasourceMock();

      final repository = SignupFirebaseRepository(datasourceLeft);
      final result = await repository.insertUserFirestore(entity);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<SignupFirestoreError>());
    });
  });
}
