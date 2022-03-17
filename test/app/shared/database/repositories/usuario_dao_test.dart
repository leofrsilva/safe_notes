import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/entities/usuario_entity.dart';
import 'package:safe_notes/app/shared/database/models/usuario_model.dart';
import 'package:safe_notes/app/shared/database/repositories/usuario_dao.dart';
import 'usuario_stub.dart';

void main() {
  late AppDatabase database;
  late UsuarioDAO usuarioDAO;

  setUpAll(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    usuarioDAO = database.usuarioDao;
    await usuarioDAO.register(user0.entity);
    await usuarioDAO.register(user1.entity);
  });

  tearDownAll(() async {
    await database.close();
  });

  group('Database Tests - UsuarioDAO | ', () {
    test('Inserir Usuario e retorna o ID maior que Zero', () async {
      final usuario = user2;
      int id = await usuarioDAO.insertElement(usuario.entity);

      expect(id, isNonZero);
    });

    test('Listar Usuarios', () async {
      final usuario = user3;
      await usuarioDAO.insertElement(usuario.entity);

      var entities = await usuarioDAO.fetchUsers();
      final listUsers = UsuarioModel.fromListEntity(entities);

      expect(listUsers, isNotEmpty);
      expect(listUsers.length, greaterThanOrEqualTo(3));
    });
  });

  group('Database Tests - UsuarioDAO Module LOGIN e REGISTER | ', () {
    test(
        'Casdastrar Usuario e resgistrar como Logado, e as demais contas marca como Deslogado',
        () async {
      final usuario5 = user4;
      final usuario6 = user5;

      await usuarioDAO.register(usuario5.entity);
      UsuarioEntity? userRegistred = await usuarioDAO.register(usuario6.entity);
      List<UsuarioModel> listUsers =
          UsuarioModel.fromListEntity(await usuarioDAO.fetchUsers());

      expect(listUsers, isNotEmpty);
      expect(userRegistred, isNotNull);
      expect(userRegistred!.email, equals(usuario6.email));

      expect(
        listUsers.where((model) => model.logged == true).toList().length,
        equals(1),
      );
    });

    test('Verificação para encontrar email já cadastrado', () async {
      final usuario6 = user6;
      await usuarioDAO.register(usuario6.entity);

      UsuarioEntity? userExisting =
          await usuarioDAO.checkEmailExist(usuario6.email);

      expect(userExisting, isNotNull);
      expect(userExisting!.email, equals(usuario6.email));
    });

    test(
        'Logar e resgistrar como Logado, e as demais contas marca como Deslogado',
        () async {
      final usuario7 = user7;
      final usuario8 = user8;

      await usuarioDAO.register(usuario7.entity);
      await usuarioDAO.register(usuario8.entity);
      UsuarioEntity? userLogged = await usuarioDAO.getin(usuario7.userId);
      List<UsuarioModel> listUsers =
          UsuarioModel.fromListEntity(await usuarioDAO.fetchUsers());

      expect(listUsers, isNotEmpty);
      expect(userLogged, isNotNull);
      expect(userLogged!.email, equals(usuario7.email));

      expect(
        listUsers.where((model) => model.logged == true).toList().length,
        equals(1),
      );
    });

    test('Retorna Usuario logado', () async {
      final usuario9 = user9;
      await usuarioDAO.register(usuario9.entity);

      List<UsuarioModel> userLogged =
          UsuarioModel.fromListEntity(await usuarioDAO.getUserLogged());

      expect(userLogged, isNotEmpty);
      expect(userLogged.length, equals(1));
      expect(userLogged.first.email, usuario9.email);
      expect(userLogged.first.logged, equals(true));
    });
  });

  group('Database Tests - UsuarioDAO Module DELETE ACCOUNT | ', () {
    test('Excluir usuario da Lista de Contas', () async {
      final usuario10 = user10;
      final usuario11 = user11;
      await usuarioDAO.register(usuario10.entity);
      await usuarioDAO.register(usuario11.entity);

      int numRecordsDeleted =
          await usuarioDAO.deleteElement([usuario10.entity]);
      List<UsuarioEntity> listEntities = await usuarioDAO.fetchUsers();

      expect(numRecordsDeleted, equals(1));
      expect(
        listEntities.any((entity) => entity.email == usuario10.entity.email),
        equals(false),
      );
    });
  });
}
