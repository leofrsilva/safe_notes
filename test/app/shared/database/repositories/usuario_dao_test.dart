import 'package:floor/floor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/models/usuario_model.dart';
import 'package:safe_notes/app/shared/database/repositories/usuario_dao.dart';

void main() {
  group('Database Tests - UsuarioEntity | ', () {
    late AppDatabase database;
    late UsuarioDAO usuarioDAO;

    setUp(() async {
      database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
      usuarioDAO = database.usuarioDao;
    });

    tearDown(() async {
      await database.close();
    });

    test('Inserir Usuario e retorna o ID maior que Zero', () async {
      final usuario = UsuarioModel.fromEntity(
        dateBirth: DateTime.parse('2000-04-12'),
        email: 'teste@gmail.com',
        name: 'teste',
        genre: 'M',
        logged: false,
      );
      int id = await usuarioDAO.insertElement(usuario.entity);
      expect(id, isNonZero);
    });

    test('Listar Usuarios', () async {
      final listUsers = await usuarioDAO.fetchUsers();
      print(listUsers.length);
      expect(listUsers, isNotEmpty);
    });
  });
}
