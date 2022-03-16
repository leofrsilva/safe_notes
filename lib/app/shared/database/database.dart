// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entities/usuario_entity.dart';
import 'repositories/usuario_dao.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [UsuarioEntity])
abstract class AppDatabase extends FloorDatabase {
  UsuarioDAO get usuarioDao;
}
