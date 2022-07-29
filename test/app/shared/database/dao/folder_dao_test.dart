import 'package:flutter_test/flutter_test.dart';
import 'package:modular_test/modular_test.dart';
import 'package:safe_notes/app/app_module.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

import '../../../../stub/folder_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;

  setUpAll(() async {
    initModule(AppModule());
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
  });

  tearDownAll(() async {
    await database.close();
  });

  test('folder dao insertFolder', () async {
    List<int> ids = await folderDAO.insertFolders([folder.entity]);

    expect(ids, isNotNull);
    expect(ids, isA<List<int>>());
  });

  test('folder dao updateFolders', () async {
    var folder = folder1.copyWith(isDeleted: false);
    List<int> ids = await folderDAO.insertFolders([folder.entity]);

    folder = folder.copyWith(isDeleted: true);
    await folderDAO.updateFolders([folder.entity]);

    final entity = await folderDAO.findFolder(ids.first);
    expect(entity, isNotNull);

    final resultFolder = FolderModel.fromEntity(entity!);

    expect(resultFolder.isDeleted, equals(true));
  });

  test('folder dao deleteFolder', () async {
    var folder = folder2.copyWith(isDeleted: false);
    List<int> ids = await folderDAO.insertFolders([folder.entity]);

    folder = folder.copyWith(isDeleted: true);
    await folderDAO.updateFolders([folder.entity]);

    final entity = await folderDAO.findFolder(ids.first);
    expect(entity, isNotNull);

    final resultFolder = FolderModel.fromEntity(entity!);

    expect(resultFolder.isDeleted, equals(true));
  });

  test('folder dao findFolder', () async {
    var folder = folder3;
    List<int> ids = await folderDAO.insertFolders([folder.entity]);

    final entity = await folderDAO.findFolder(ids.first);
    expect(entity, isNotNull);
    expect(entity, isA<FolderEntity>());
  });

  test('folder dao getFolders', () async {
    var folder = folder4;
    await folderDAO.insertFolders([folder.entity]);

    final streamList = folderDAO.getFolders();

    final list = await streamList.first;

    expect(streamList, isA<Stream<List<FolderEntity>>>());
    expect(list, isA<List<FolderEntity>>());
  });
}
