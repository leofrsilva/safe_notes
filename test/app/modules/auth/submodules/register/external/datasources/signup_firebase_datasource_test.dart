import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/domain/errors/signup_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/register/external/datasources/signup_firebase_datasource.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../../../../../../../mocks/mocks_firebase.dart';

void main() {
  final auth = FirebaseAuthMock();
  final firestore = FakeFirebaseFirestore();
  final datasource = SignupFirebaseDatasource(auth, firestore);

  group('signup firebase datasource signUp | ', () {
    final email = userAuthMock.email!;
    const pass = '123456';

    test('retornar um String UID do Auth Usuario', () async {
      when(() =>
              auth.createUserWithEmailAndPassword(email: email, password: pass))
          .thenAnswer((_) async => UserCredentialMock());

      final result = await datasource.signUp(email, pass);

      expect(result, isA<String>());
      expect(result, userAuthMock.uid);
    });

    test('retornar um CreateUserAuthFirebaseError (Sua senha é muito fraca)',
        () async {
      when(() =>
              auth.createUserWithEmailAndPassword(email: email, password: pass))
          .thenThrow(FirebaseAuthExceptionMock(code: 'ERROR_WEAK_PASSWORD'));

      expect(
        () => datasource.signUp(email, pass),
        throwsA(isA<CreateUserAuthFirebaseError>()),
      );
    });

    test('retornar um NoFoundUserInCreateUserAuthFirebase', () async {
      when(() =>
              auth.createUserWithEmailAndPassword(email: email, password: pass))
          .thenAnswer((_) async => NoUserCredentialMock());

      expect(
        () => datasource.signUp(email, pass),
        throwsA(isA<NoFoundUserInCreateUserAuthFirebase>()),
      );
    });
  });

  group('signup firebase datasource insertUserFirestore | ', () {
    const docRef = 'DOCREF';
    UsuarioModel model = UsuarioModel(
      docRef: docRef,
      email: 'Test_Firestore@gmail.com',
      name: 'Teste Firestore',
      senha: '',
      genre: 'M',
      logged: true,
      dateBirth: DateTime.now(),
    );

    test('retornar um dynamic, preenchimento feito com sucesso', () async {
      final result = await datasource.insertUserFirestore(model);

      expect(result, isA<dynamic>());
    });

    test('retornar um SignupFirestoreError', () async {
      final firestoreMock = FirebaseFirestoreMock();
      final datasourceMock = SignupFirebaseDatasource(auth, firestoreMock);

      when(
        () => firestoreMock
            .collection('usuario')
            .doc(model.docRef)
            .set(model.toJson()),
      ).thenThrow(SignupFirestoreErrorMock());

      expect(
        () => datasourceMock.insertUserFirestore(model),
        throwsA(isA<SignupFirestoreError>()),
      );
    });
  });
}
