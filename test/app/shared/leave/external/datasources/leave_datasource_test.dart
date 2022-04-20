import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_notes/app/shared/leave/domain/errors/leave_failures.dart';
import 'package:safe_notes/app/shared/leave/external/datasources/leave_datasource.dart';

import '../../../../../mocks/mocks_firebase.dart';
import '../../../../../mocks/mocks_leave.dart';

void main() {
  final auth = FirebaseAuthMock();
  final firestore = FakeFirebaseFirestore();
  final datasource = LeaveDatasource(auth, firestore);

  group('leave datasource signIn | ', () {
    test('retornar um dynamic, update de logout feito com sucesso', () async {
      when(() => auth.currentUser).thenReturn(userAuthMock);

      expect(datasource.leaveAuth(), completes);
    });

    test('retornar um LeaveFirestoreError', () {
      final firestoreMock = FirebaseFirestoreMock();
      final datasourceMock = LeaveDatasource(auth, firestoreMock);

      when(() => firestoreMock
          .collection('usuario')
          .doc('uid')
          .update({'logged': false})).thenThrow(LeaveFirestoreErrorMock());

      expect(
        () => datasourceMock.leaveAuth(),
        throwsA(isA<LeaveFirestoreError>()),
      );
    });
    test('retornar um NoUserLoggedInAuthError', () async {
      when(() => auth.currentUser).thenReturn(null);
      expect(
        () => datasource.leaveAuth(),
        throwsA(isA<NoUserLoggedInAuthError>()),
      );
    });
  });
}
