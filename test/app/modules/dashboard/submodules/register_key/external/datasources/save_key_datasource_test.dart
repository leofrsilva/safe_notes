import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/register_key/domain/errors/register_key_failure.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/register_key/external/datasources/save_key_datasource.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../../../../../../../mocks/mocks_firebase.dart';
import '../../../../../../../mocks/mocks_save_key.dart';

void main() {
  final firestore = FakeFirebaseFirestore();
  final datasource = SaveKeyDatasource(firestore);

  group('save key datasource saveKey | ', () {
    const keyText = 'valKey1';
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

    setUpAll(() {
      firestore.collection('usuario').doc(model.docRef).set(model.toJson());
    });

    test('retornar um dynamic, chave salva com sucesso', () async {
      final result = await datasource.saveKey(model, keyText);
      final docSnapshot =
          await firestore.collection('usuario').doc(model.docRef).get();
      var key = docSnapshot.data()?['key'];

      expect(result, isA<dynamic>());
      expect(key, isA<String>());
      expect(key, equals(keyText));
    });

    test('retornar um SaveKeyFirestoreError', () async {
      final firestoreMock = FirebaseFirestoreMock();
      final datasourceMock = SaveKeyDatasource(firestoreMock);

      when(
        () => firestoreMock
            .collection('usuario')
            .doc(model.docRef)
            .set(model.toJson()),
      ).thenThrow(SaveKeyFirestoreErrorMock());

      expect(
        () => datasourceMock.saveKey(model, keyText),
        throwsA(isA<SaveKeyFirestoreError>()),
      );
    });
  });
}
