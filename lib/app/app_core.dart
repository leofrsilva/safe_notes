import 'shared/domain/entities/usuario_entity.dart';
import 'shared/domain/models/usuario_model.dart';

class AppCore {
  bool get isNotNull => _usuarioModel != null;

  UsuarioModel? _usuarioModel;
  UsuarioModel? getUsuario() => _usuarioModel;
  vsetUsuario(UsuarioModel? model) => _usuarioModel = model;

  setUsuarioFromEntity(UsuarioEntity entity) {
    _usuarioModel = UsuarioModel.fromEntity(entity);
  }

  removeUsuario() => _usuarioModel = null;
}
