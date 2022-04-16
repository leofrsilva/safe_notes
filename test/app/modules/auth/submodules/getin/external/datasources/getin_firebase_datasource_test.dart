import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/domain/errors/getin_failures.dart';
import 'package:safe_notes/app/modules/auth/submodules/getin/external/datasources/getin_firebase_datasource.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../../../../../../../mocks/mocks_firebase.dart';

void main() {
  final auth = FirebaseAuthMock();
  final firestore = FakeFirebaseFirestore();
  final datasource = GetinFirebaseDatasource(auth, firestore);

  group('ser firebase datasource signIn | ', () {
    final email = userAuthMock.email!;
    const pass = '123456';

    test('retornar um String UID do Auth Usuario', () async {
      when(() => auth.signInWithEmailAndPassword(email: email, password: pass))
          .thenAnswer((_) async => UserCredentialMock());

      final result = await datasource.signIn(email, pass);

      expect(result, isA<String>());
      expect(result, userAuthMock.uid);
    });

    test(
        'retornar um LoginAuthFirebaseError (O usuário com este e-mail não existe)',
        () async {
      when(() => auth.signInWithEmailAndPassword(email: email, password: pass))
          .thenThrow(FirebaseAuthExceptionMock(code: 'ERROR_USER_NOT_FOUND'));

      expect(
        () => datasource.signIn(email, pass),
        throwsA(isA<LoginAuthFirebaseError>()),
      );
    });

    test('retornar um NoFoundUserInLoginAuthFirebase', () async {
      when(() => auth.signInWithEmailAndPassword(email: email, password: pass))
          .thenAnswer((_) async => NoUserCredentialMock());

      expect(
        () => datasource.signIn(email, pass),
        throwsA(isA<NoFoundUserInLoginAuthFirebase>()),
      );
    });
  });

  group('ser firebase datasource getUserFirestore | ', () {
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

    test('retornar um UsuarioModel', () async {
      await firestore
          .collection('usuario')
          .doc(model.docRef)
          .set(model.toJson());

      final result = await datasource.getUserFirestore(docRef);

      expect(result, isA<UsuarioModel>());
      expect(result.docRef, equals(docRef));
    });

    test('retornar um GetinFirestoreError', () async {
      final firestoreMock = FirebaseFirestoreMock();
      final datasourceMock = GetinFirebaseDatasource(auth, firestoreMock);

      when(() => firestoreMock.collection('usuario').doc(model.docRef).get())
          .thenThrow(GetinFirestoreErrorMock());

      expect(
        () => datasourceMock.getUserFirestore(model.docRef),
        throwsA(isA<GetinFirestoreError>()),
      );
    });

    test('retornar um GetinNoDataFoundFirestoreError', () async {
      final firestoreMock = FirebaseFirestoreMock();
      final datasourceMock = GetinFirebaseDatasource(auth, firestoreMock);

      when(() => firestoreMock.collection('usuario').doc(model.docRef).get())
          .thenThrow(GetinNoDataFoundFirestoreError());

      expect(
        () => datasourceMock.getUserFirestore(model.docRef),
        throwsA(isA<GetinNoDataFoundFirestoreError>()),
      );
    });
  });
}
