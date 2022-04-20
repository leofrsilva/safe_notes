import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/errors/leave_failures.dart';
import '../../infra/datasources/i_leave_datasource.dart';

class LeaveDatasource extends ILeaveDatasource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  LeaveDatasource(this._auth, this._firestore);

  @override
  Future<dynamic> leaveAuth() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('usuario')
          .doc(user.uid)
          .update({'logged': false}).catchError(
        (error) {
          throw LeaveFirestoreError(
            'LeaveDatasource.leaveAuth',
            error,
            error.message,
          );
        },
      ).timeout(const Duration(milliseconds: 1500), onTimeout: () async {
        throw LeaveFirestoreError(
          'LeaveDatasource.leaveAuth',
          'network-request-failed',
          'Sem Conexão com a Internet!',
        );
      });
      await _auth.signOut();
    } else {
      throw NoUserLoggedInAuthError();
    }
    return dynamic;
  }
}
