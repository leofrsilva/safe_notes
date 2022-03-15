import 'package:floor/floor.dart';

import '../entities/usuario_entity.dart';
import 'i_usuario_dao.dart';

@dao
abstract class UsuarioDao extends IUsuarioDAO<UsuarioEntity> {
  @Query('SELECT * FROM Usuario WHERE')
  Future<List<UsuarioEntity>> fetchUsers();
}
