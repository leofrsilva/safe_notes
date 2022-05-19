import 'package:flutter_test/flutter_test.dart';
import 'package:safe_notes/app/shared/database/daos/folder_dao.dart';
import 'package:safe_notes/app/shared/database/database.dart';
import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../../../stub/folder_model_stub.dart';

void main() {
  late AppDatabase database;
  late FolderDAO folderDAO;

  setUpAll(() async {
    database = await $FloorAppDatabase.inMemoryDatabaseBuilder().build();
    folderDAO = database.folderDao;
  });

  tearDownAll(() async {
    await database.close();
  });

  test('folder dao insertFolder', () async {
    int id = await folderDAO.insertFolder(folder.entity);

    expect(id, isNotNull);
    expect(id, isA<int>());
  });

  test('folder dao updateFolders', () async {
    var folder = folder1.copyWith(isDeleted: false);
    int id = await folderDAO.insertFolder(folder.entity);

    folder = folder.copyWith(isDeleted: true);
    await folderDAO.updateFolders([folder.entity]);

    final entity = await folderDAO.findFolder(id);
    expect(entity, isNotNull);

    final resultFolder = FolderModel.fromEntity(entity!);

    expect(resultFolder.isDeleted, equals(true));
  });

  test('folder dao deleteFolder', () async {
    var folder = folder2.copyWith(isDeleted: false);
    int id = await folderDAO.insertFolder(folder.entity);

    folder = folder.copyWith(isDeleted: true);
    await folderDAO.updateFolders([folder.entity]);

    final entity = await folderDAO.findFolder(id);
    expect(entity, isNotNull);

    final resultFolder = FolderModel.fromEntity(entity!);

    expect(resultFolder.isDeleted, equals(true));
  });

  test('folder dao findFolder', () async {
    var folder = folder3;
    int id = await folderDAO.insertFolder(folder.entity);

    final entity = await folderDAO.findFolder(id);
    expect(entity, isNotNull);
    expect(entity, isA<FolderEntity>());
  });

  test('folder dao getFoldersQtdChild', () async {
    var folder = folder4;
    await folderDAO.insertFolder(folder.entity);

    final streamList = folderDAO.getFoldersQtdChild();

    final list = await streamList.first;

    expect(streamList, isA<Stream<List<FolderQtdChildView>>>());
    expect(list, isA<List<FolderQtdChildView>>());
  });
}
