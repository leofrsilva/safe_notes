import 'package:floor/floor.dart';

import '../entities/usuario_entity.dart';
import 'i_usuario_dao.dart';

@dao
abstract class UsuarioDAO extends IUsuarioDAO<UsuarioEntity> {
  @Query('SELECT * FROM Usuario')
  Future<List<UsuarioEntity>> fetchUsers();

  @Query('SELECT * FROM Usuario WHERE logged = 1')
  Future<List<UsuarioEntity>> findUserLogged();
}
