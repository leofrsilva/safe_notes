import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/infra/repositories/getin_firebase_repository.dart';
import 'package:safe_notes/app/shared/domain/entities/usuario_entity.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../../../../../../../mocks/mocks_firebase.dart';
import '../../../../../../../stub/usuario_entity_stub.dart';

void main() {
  final datasource = GetinFirebaseDatasourceMock();

  group('getin firebase repository getUserFirestore | ', () {
    final entity = user0;

    test('retorna um UsuarioEntity', () async {
      const docRef = 'docRef';

      when(() => datasource.getUserFirestore(docRef))
          .thenAnswer((_) async => UsuarioModel.fromEntity(entity));

      final repository = GetinFirebaseRepository(datasource);
      final result = await repository.getUserFirestore(docRef);

      expect(result.isRight(), equals(true));
      expect(result.fold(id, id), isA<UsuarioEntity>());
    });

    test('retornar um GetinFirestoreError', () async {
      const docRef = 'docRef';

      when(() => datasource.getUserFirestore(docRef))
          .thenThrow(GetinFirestoreErrorMock());

      final repository = GetinFirebaseRepository(datasource);
      final result = await repository.getUserFirestore(docRef);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<GetinFirestoreError>());
    });
  });

  group('getin firebase repository signIn | ', () {
    const email = 'email';
    const pass = 'pass';

    test('retornar um String UID do Auth Usuario', () async {
      const uid = 'uid';

      when(() => datasource.signIn(email, pass)).thenAnswer(
        (_) async => uid,
      );

      final repository = GetinFirebaseRepository(datasource);
      final result = await repository.signIn(email, pass);

      expect(result.isRight(), equals(true));
      expect(result.fold(id, id), isA<String>());
      expect(result.fold(id, id), equals(uid));
    });

    test('retornar um LoginAuthFirebaseError', () async {
      when(() => datasource.signIn(email, pass))
          .thenThrow(LoginAuthFirebaseErrorMock());

      final repository = GetinFirebaseRepository(datasource);
      final result = await repository.signIn(email, pass);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<LoginAuthFirebaseError>());
    });

    test('retornar um NoFoundUserInLoginAuthFirebase', () async {
      when(() => datasource.signIn(email, pass))
          .thenThrow(NoFoundUserInLoginAuthFirebase());

      final repository = GetinFirebaseRepository(datasource);
      final result = await repository.signIn(email, pass);

      expect(result, isA<Left>());
      expect(result.fold(id, id), isA<NoFoundUserInLoginAuthFirebase>());
    });
  });

  group('getin firebase repository updateLoggedUserFirestore | ', () {
    test('isRight igual a True', () async {
      const docRef = 'docRef';

      when(() => datasource.updateLoggedUserFirestore(docRef))
          .thenAnswer((_) async => dynamic);

      final repository = GetinFirebaseRepository(datasource);
      final result = await repository.updateLoggedUserFirestore(docRef);

      expect(result.isRight(), equals(true));
    });

    test('retornar um GetinFirestoreError', () async {
      const docRef = 'docRef';

      when(() => datasource.updateLoggedUserFirestore(docRef))
          .thenThrow(GetinFirestoreErrorMock());

      final repository = GetinFirebaseRepository(datasource);
      final result = await repository.updateLoggedUserFirestore(docRef);

      expect(result.isLeft(), equals(true));
      expect(result.fold(id, id), isA<GetinFirestoreError>());
    });
  });
}
