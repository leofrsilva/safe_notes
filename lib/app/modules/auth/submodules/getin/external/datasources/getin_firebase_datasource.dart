import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../../domain/errors/getin_failures.dart';
import '../../infra/datasources/i_getin_firebase_datasource.dart';

class GetinFirebaseDatasource extends IGetinFirebaseDatasource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  GetinFirebaseDatasource(this._auth, this._firestore);

  @override
  Future<UsuarioModel> getUserFirestore(String docRef) async {
    final docSnapshot = await _firestore
        .collection('usuario')
        .doc(docRef)
        .get()
        .catchError((error) {
      throw GetinFirestoreError(
        'GetinFirebaseDatasource.getUserFirestore',
        error,
        error.message,
      );
    });
    if (docSnapshot.data() == null) {
      throw GetinNoDataFoundFirestoreError();
    }
    return UsuarioModel.fromJson(docSnapshot.data()!)
        .copyWith(docRef: docSnapshot.id);
  }

  @override
  Future<String> signIn(String email, String pass) async {
    try {
      UserCredential credenciais = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (credenciais.user == null) {
        throw NoFoundUserInLoginAuthFirebase();
      }
      return credenciais.user!.uid;
    } on FirebaseAuthException catch (error, stackTrace) {
      String errorMessage = '';
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Seu endereço de E-mail parece estar incorreto.";
          break;
        case "wrong-password":
          errorMessage = "Sua Senha está errada.";
          break;
        case "user-not-found":
          errorMessage = "O usuário com este E-mail não existe.";
          break;
        case "user-disabled":
          errorMessage = "O usuário com este E-mail foi desativado.";
          break;
        case "too-many-requests":
          errorMessage = "Muitos pedidos. Tente mais tarde.";
          break;
        case "operation-not-allowed":
          errorMessage = "Entrar com E-mail e Senha não está ativado.";
          break;
        default:
          errorMessage = "Ocorreu um erro indefinido.";
      }
      throw LoginAuthFirebaseError(
        stackTrace,
        'GetinFirebaseDatasource.signIn',
        error,
        errorMessage,
      );
    }
  }
}
