import 'package:floor/floor.dart';

import 'package:sqlite3/sqlite3.dart';
import '../entities/usuario_entity.dart';
import 'i_usuario_dao.dart';

@dao
abstract class UsuarioDAO extends IUsuarioDAO<UsuarioEntity> {
  @delete
  Future<int> deleteElement(List<UsuarioEntity> usuarios);

  @Query('SELECT * FROM Usuario')
  Future<List<UsuarioEntity>> fetchUsers();

  @Query('SELECT * FROM Usuario WHERE id = :userId')
  Future<UsuarioEntity?> findUser(int userId);

  @Query('SELECT * FROM Usuario WHERE logged = 1')
  Future<List<UsuarioEntity>> getUserLogged();

  @Query('SELECT * FROM Usuario WHERE email = :email')
  Future<UsuarioEntity?> checkEmailExist(String email);

  @Query('UPDATE Usuario SET logged = 1 WHERE id = :userLogged')
  Future<void> login(int userLogged);

  @Query('UPDATE Usuario SET logged = 0 WHERE id <> :userLogged')
  Future<void> logoutOutherAccounts(int userLogged);

  Future<UsuarioEntity?> register(UsuarioEntity entity) async {
    try {
      int userId = await insertElement(entity);
      if (userId > 0) {
        await login(userId);
        await logoutOutherAccounts(userId);
        final usuario = await findUser(userId);
        return usuario;
      }
    } on SqliteException catch (error) {
      if (error.extendedResultCode == 1555) {
        throw SqliteException(
          1555,
          'E-mail já está cadastrado. Por favor, tente outro.',
        );
      } else {
        throw SqliteException(error.extendedResultCode, error.message);
      }
    }
    return null;
  }

  Future<UsuarioEntity?> getin(int userId) async {
    try {
      await login(userId);
      await logoutOutherAccounts(userId);
      final usuario = await findUser(userId);
      return usuario;
    } on SqliteException catch (error) {
      throw SqliteException(error.extendedResultCode, error.message);
    }
  }
}
