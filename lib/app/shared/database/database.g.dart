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

  FolderDAO? _folderDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `Tag` (`name` TEXT NOT NULL, `description` TEXT NOT NULL, `color` TEXT NOT NULL, `id` INTEGER NOT NULL, `date_create` TEXT NOT NULL, `date_modification` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Note` (`title` TEXT NOT NULL, `body` TEXT NOT NULL, `is_deleted` INTEGER NOT NULL, `tag_id` INTEGER, `folder_id` INTEGER NOT NULL, `id` INTEGER NOT NULL, `date_create` TEXT NOT NULL, `date_modification` TEXT NOT NULL, FOREIGN KEY (`tag_id`) REFERENCES `Tag` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`folder_id`) REFERENCES `Folder` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Folder` (`folder_parent` INTEGER, `user_id` TEXT NOT NULL, `level` INTEGER NOT NULL, `color` INTEGER NOT NULL, `name` TEXT NOT NULL, `is_deleted` INTEGER NOT NULL, `id` INTEGER NOT NULL, `date_create` TEXT NOT NULL, `date_modification` TEXT NOT NULL, FOREIGN KEY (`folder_parent`) REFERENCES `Folder` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');
        await database
            .execute('CREATE UNIQUE INDEX `index_Tag_name` ON `Tag` (`name`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_Tag_color` ON `Tag` (`color`)');
        await database.execute(
            'CREATE VIEW IF NOT EXISTS `FolderQtdChild` AS     SELECT \n      F.id,\n      F.name,\n      F.level, \n      F.color,\n      F.folder_parent AS parentId,  \n      (SELECT COUNT(id) \n      FROM Folder \n      WHERE (level = F.level + 1) AND\n            (folder_parent = F.id)  \n      ) \n      +\n      (SELECT COUNT(id) \n      FROM Note \n      WHERE (folder_id = F.id) \n      )\n      as qtd\n    FROM Folder F\n    GROUP BY id\n  ');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FolderDAO get folderDao {
    return _folderDaoInstance ??= _$FolderDAO(database, changeListener);
  }
}

class _$FolderDAO extends FolderDAO {
  _$FolderDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _folderEntityInsertionAdapter = InsertionAdapter(
            database,
            'Folder',
            (FolderEntity item) => <String, Object?>{
                  'folder_parent': item.folderParent,
                  'user_id': item.userId,
                  'level': item.level,
                  'color': item.color,
                  'name': item.name,
                  'is_deleted': item.isDeleted,
                  'id': item.id,
                  'date_create': item.dateCreate,
                  'date_modification': item.dateModification
                },
            changeListener),
        _folderEntityUpdateAdapter = UpdateAdapter(
            database,
            'Folder',
            ['id'],
            (FolderEntity item) => <String, Object?>{
                  'folder_parent': item.folderParent,
                  'user_id': item.userId,
                  'level': item.level,
                  'color': item.color,
                  'name': item.name,
                  'is_deleted': item.isDeleted,
                  'id': item.id,
                  'date_create': item.dateCreate,
                  'date_modification': item.dateModification
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FolderEntity> _folderEntityInsertionAdapter;

  final UpdateAdapter<FolderEntity> _folderEntityUpdateAdapter;

  @override
  Future<void> deleteAllExcept(int folderId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Folder WHERE id != ?1',
        arguments: [folderId]);
  }

  @override
  Future<void> deleteFolder(int folderId) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Folder SET is_deleted = 1 WHERE id = ?1',
        arguments: [folderId]);
  }

  @override
  Future<FolderEntity?> findUser(int folderId) async {
    return _queryAdapter.query('SELECT * FROM Folder WHERE id = ?1',
        mapper: (Map<String, Object?> row) => FolderEntity(
            folderId: row['id'] as int,
            folderParent: row['folder_parent'] as int?,
            dateCreate: row['date_create'] as String,
            dateModification: row['date_modification'] as String,
            userId: row['user_id'] as String,
            level: row['level'] as int,
            name: row['name'] as String,
            color: row['color'] as int,
            isDeleted: row['is_deleted'] as int),
        arguments: [folderId]);
  }

  @override
  Stream<List<FolderQtdChildView>> getFoldersQtdChild() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM FolderQtdChild ORDER BY id',
        mapper: (Map<String, Object?> row) => FolderQtdChildView(
            parentId: row['parentId'] as int?,
            id: row['id'] as int,
            name: row['name'] as String,
            level: row['level'] as int,
            color: row['color'] as int,
            qtd: row['qtd'] as int),
        queryableName: 'FolderQtdChild',
        isView: true);
  }

  @override
  Future<int> insertFolder(FolderEntity record) {
    return _folderEntityInsertionAdapter.insertAndReturnId(
        record, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateFolders(List<FolderEntity> records) {
    return _folderEntityUpdateAdapter.updateListAndReturnChangedRows(
        records, OnConflictStrategy.replace);
  }
}
