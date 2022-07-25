import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

abstract class ISaveKeyDatasource {
  Future<dynamic> saveKey(UsuarioModel user, String keyText);
}
