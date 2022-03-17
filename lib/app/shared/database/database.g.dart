// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UsuarioDAO? _usuarioDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Usuario` (`email` TEXT NOT NULL, `name` TEXT NOT NULL, `genre` INTEGER NOT NULL, `date_birth` TEXT NOT NULL, `logged` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT, `date_create` TEXT NOT NULL, `date_modification` TEXT NOT NULL)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_Usuario_email` ON `Usuario` (`email`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UsuarioDAO get usuarioDao {
    return _usuarioDaoInstance ??= _$UsuarioDAO(database, changeListener);
  }
}

class _$UsuarioDAO extends UsuarioDAO {
  _$UsuarioDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _usuarioEntityInsertionAdapter = InsertionAdapter(
            database,
            'Usuario',
            (UsuarioEntity item) => <String, Object?>{
                  'email': item.email,
                  'name': item.name,
                  'genre': item.genre,
                  'date_birth': item.dateBirth,
                  'logged': item.logged,
                  'id': item.id,
                  'date_create': item.dateCreate,
                  'date_modification': item.dateModification
                }),
        _usuarioEntityDeletionAdapter = DeletionAdapter(
            database,
            'Usuario',
            ['id'],
            (UsuarioEntity item) => <String, Object?>{
                  'email': item.email,
                  'name': item.name,
                  'genre': item.genre,
                  'date_birth': item.dateBirth,
                  'logged': item.logged,
                  'id': item.id,
                  'date_create': item.dateCreate,
                  'date_modification': item.dateModification
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UsuarioEntity> _usuarioEntityInsertionAdapter;

  final DeletionAdapter<UsuarioEntity> _usuarioEntityDeletionAdapter;

  @override
  Future<List<UsuarioEntity>> fetchUsers() async {
    return _queryAdapter.queryList('SELECT * FROM Usuario',
        mapper: (Map<String, Object?> row) => UsuarioEntity(
            dateCreate: row['date_create'] as String?,
            dateModification: row['date_modification'] as String?,
            dateBirth: row['date_birth'] as String,
            email: row['email'] as String,
            name: row['name'] as String,
            genre: row['genre'] as int,
            logged: row['logged'] as int));
  }

  @override
  Future<UsuarioEntity?> findUser(int userId) async {
    return _queryAdapter.query('SELECT * FROM Usuario WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UsuarioEntity(
            dateCreate: row['date_create'] as String?,
            dateModification: row['date_modification'] as String?,
            dateBirth: row['date_birth'] as String,
            email: row['email'] as String,
            name: row['name'] as String,
            genre: row['genre'] as int,
            logged: row['logged'] as int),
        arguments: [userId]);
  }

  @override
  Future<List<UsuarioEntity>> getUserLogged() async {
    return _queryAdapter.queryList('SELECT * FROM Usuario WHERE logged = 1',
        mapper: (Map<String, Object?> row) => UsuarioEntity(
            dateCreate: row['date_create'] as String?,
            dateModification: row['date_modification'] as String?,
            dateBirth: row['date_birth'] as String,
            email: row['email'] as String,
            name: row['name'] as String,
            genre: row['genre'] as int,
            logged: row['logged'] as int));
  }

  @override
  Future<UsuarioEntity?> checkEmailExist(String email) async {
    return _queryAdapter.query('SELECT * FROM Usuario WHERE email = ?1',
        mapper: (Map<String, Object?> row) => UsuarioEntity(
            dateCreate: row['date_create'] as String?,
            dateModification: row['date_modification'] as String?,
            dateBirth: row['date_birth'] as String,
            email: row['email'] as String,
            name: row['name'] as String,
            genre: row['genre'] as int,
            logged: row['logged'] as int),
        arguments: [email]);
  }

  @override
  Future<void> login(int userLogged) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Usuario SET logged = 1 WHERE id = ?1',
        arguments: [userLogged]);
  }

  @override
  Future<void> logoutOutherAccounts(int userLogged) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Usuario SET logged = 0 WHERE id <> ?1',
        arguments: [userLogged]);
  }

  @override
  Future<int> insertElement(UsuarioEntity recrord) {
    return _usuarioEntityInsertionAdapter.insertAndReturnId(
        recrord, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteElement(List<UsuarioEntity> usuarios) {
    return _usuarioEntityDeletionAdapter
        .deleteListAndReturnChangedRows(usuarios);
  }
}
