import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/entities/usuario_entity.dart';
import 'package:safe_notes/app/shared/database/models/usuario_model.dart';
import 'package:safe_notes/app/shared/database/repositories/usuario_dao.dart';

void main() {
  late AppDatabase database;
  late UsuarioDAO usuarioDAO;

  setUpAll(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    usuarioDAO = database.usuarioDao;
  });

  tearDownAll(() async {
    await database.close();
  });

  group('Database Tests - UsuarioEntity | ', () {
    test('Inserir Usuario e retorna o ID maior que Zero', () async {
      final usuario = UsuarioModel.fromEntity(
        dateBirth: DateTime.parse('2000-04-12'),
        email: 'teste1@gmail.com',
        name: 'teste1',
        genre: 'M',
        logged: false,
      );
      int id = await usuarioDAO.insertElement(usuario.entity);

      expect(id, isNonZero);
    });

    test('Listar Usuarios', () async {
      final usuario = UsuarioModel.fromEntity(
        dateBirth: DateTime.parse('1999-08-25'),
        email: 'teste2@gmail.com',
        name: 'teste2',
        genre: 'F',
        logged: false,
      );

      await usuarioDAO.insertElement(usuario.entity);
      var entities = await usuarioDAO.fetchUsers();
      final listUsers = UsuarioModel.fromListEntity(entities);

      expect(listUsers, isNotEmpty);
      expect(listUsers.length, greaterThanOrEqualTo(1));
    });
  });
}
