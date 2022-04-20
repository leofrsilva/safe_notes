import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

abstract class IGetinFirebaseDatasource {
  Future<String> signIn(String email, String pass);
  Future<UsuarioModel> getUserFirestore(String docRef);
  Future<dynamic> updateLoggedUserFirestore(String docRef);
}
