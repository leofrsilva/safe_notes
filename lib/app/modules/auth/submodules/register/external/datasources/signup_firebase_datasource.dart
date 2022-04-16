import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../../domain/errors/signup_failures.dart';
import '../../infra/datasources/i_signup_firebase_datasource.dart';

class SignupFirebaseDatasource extends ISignupFirebaseDatasource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  SignupFirebaseDatasource(this._auth, this._firestore);

  @override
  Future<dynamic> insertUserFirestore(UsuarioModel model) async {
    await _firestore
        .collection('usuario')
        .doc(model.docRef)
        .set(model.toJson())
        .catchError((error) {
      throw SignupFirestoreError(
        'SignupFirebaseDatasource.insertUserFirestore',
        error,
        error.message,
      );
    });
    return dynamic;
  }

  @override
  Future<String> signUp(String email, String pass) async {
    try {
      UserCredential credenciais = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (credenciais.user == null) {
        throw NoFoundUserInCreateUserAuthFirebase();
      }
      return credenciais.user!.uid;
    } on FirebaseAuthException catch (error, stackTrace) {
      String errorMessage = '';
      switch (error.code) {
        case "operation-not-allowed":
          errorMessage = "As contas anônimas não estão habilitadas";
          break;
        case "weak-password":
          errorMessage = "Sua Senha é muito fraca";
          break;
        case "invalid-email":
          errorMessage = "Seu E-mail é inválido";
          break;
        case "email-already-in-use":
          errorMessage = "O E-mail já está em uso em outra conta";
          break;
        case "invalid-credential":
          errorMessage = "Seu E-mail é inválido";
          break;
        default:
          errorMessage = "Ocorreu um erro indefinido.";
      }
      throw CreateUserAuthFirebaseError(
        stackTrace,
        'SignupFirebaseDatasource.signUp',
        error,
        errorMessage,
      );
    }
  }
}
