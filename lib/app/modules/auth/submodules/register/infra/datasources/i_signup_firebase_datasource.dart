import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

abstract class ISignupFirebaseDatasource {
  Future<dynamic> insertUserFirestore(UsuarioModel model);
  Future<String> signUp(String email, String pass);
}
