import 'package:floor/floor.dart';

import '../entities/folder_entity.dart';

@dao
abstract class FolderDAO {
  @insert
  Future<int> insertFolder(FolderEntity record);

  @update
  Future<int> updateFolders(List<FolderEntity> records);

  @delete
  Future<int> deletePersistentFolders(List<FolderEntity> records);

  @Query('DELETE FROM Folder WHERE id != :folderId')
  Future<void> deleteAllExcept(int folderId);

  @Query('SELECT * FROM Folder WHERE id = :folderId')
  Future<FolderEntity?> findFolder(int folderId);

  @Query('SELECT * FROM Folder ORDER BY id')
  Stream<List<FolderEntity>> getFolders();

  //
  @Query('SELECT * FROM Folder WHERE folder_parent = :folderId')
  Future<List<FolderEntity>> findAllFolderChildrens(int folderId);

  Future deleteChild(FolderEntity folder) async {
    var listChildrens = await findAllFolderChildrens(folder.id);
    for (var child in listChildrens) {
      await deleteChild(child);
      var folder = FolderEntity(
        folderParent: child.folderParent,
        userId: child.userId,
        folderId: child.id,
        isDeleted: 1,
        name: child.name,
        color: child.color,
        level: child.level,
        dateCreate: child.dateCreate,
        dateModification: child.dateModification,
      );
      await updateFolders([folder]);
    }
  }

  Future restoreChild(FolderEntity folder) async {
    var listChildrens = await findAllFolderChildrens(folder.id);
    for (var child in listChildrens) {
      await restoreChild(child);
      var folder = FolderEntity(
        folderParent: child.folderParent,
        userId: child.userId,
        folderId: child.id,
        isDeleted: 0,
        name: child.name,
        color: child.color,
        level: child.level,
        dateCreate: child.dateCreate,
        dateModification: child.dateModification,
      );
      await updateFolders([folder]);
    }
  }

  Future deletePersistentChild(FolderEntity folder) async {
    var listChildrens = await findAllFolderChildrens(folder.id);
    for (var child in listChildrens) {
      await deletePersistentChild(child);
      await deletePersistentFolders([child]);
    }
  }
}
