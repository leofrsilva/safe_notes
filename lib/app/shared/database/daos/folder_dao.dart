import 'package:floor/floor.dart';

import '../entities/folder_entity.dart';

@dao
abstract class FolderDAO {
  @insert
  Future<int> insertFolder(FolderEntity record);

  @update
  Future<int> updateFolders(List<FolderEntity> records);

  @Query('DELETE FROM Folder WHERE id != :folderId')
  Future<void> deleteAllExcept(int folderId);

  @Query('SELECT * FROM Folder WHERE id = :folderId')
  Future<FolderEntity?> findFolder(int folderId);

  @Query('SELECT * FROM FolderQtdChild ORDER BY id')
  Stream<List<FolderEntity>> getFoldersQtdChild();

  //
  @Query('SELECT * FROM Folder WHERE folder_parent = :folderId')
  Future<List<FolderEntity>> findAllFolderChildrens(int folderId);

  Future delete(int folderId) async {
    var listChildrens = await findAllFolderChildrens(folderId);
    for (var child in listChildrens) {
      await delete(child.id);
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
}
