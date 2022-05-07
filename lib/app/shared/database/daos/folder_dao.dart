import 'package:floor/floor.dart';

import '../entities/folder_entity.dart';
import '../views/folder_qtd_child_view.dart';

@dao
abstract class FolderDAO {
  @insert
  Future<int> insertFolder(FolderEntity record);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateFolders(List<FolderEntity> records);

  @Query('DELETE FROM Folder WHERE id != :folderId')
  Future<void> deleteAllExcept(int folderId);

  @Query('SELECT * FROM Folder WHERE id = :folderId')
  Future<FolderEntity?> findFolder(int folderId);

  @Query('SELECT * FROM FolderQtdChild ORDER BY id')
  Stream<List<FolderQtdChildView>> getFoldersQtdChild();

//
  @Query('SELECT * FROM Folder WHERE folder_parent = :folderId')
  Future<List<FolderEntity>> findAllFolderChildrens(int folderId);

  @Query('UPDATE Folder SET is_deleted = 1 WHERE id = :folderId')
  Future<void> deleteFolder(int folderId);

  Future delete(int folderId) async {
    var listChildrens = await findAllFolderChildrens(folderId);
    for (var child in listChildrens) {
      await delete(child.id);
      await deleteFolder(child.id);
    }
  }
}
