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

  @Query('UPDATE Folder SET is_deleted = 1 WHERE id = :folderId')
  Future<void> deleteFolder(int folderId);

  @Query('SELECT * FROM Folder WHERE id = :folderId')
  Future<FolderEntity?> findUser(int folderId);

  @Query('SELECT * FROM FolderQtdChild ORDER BY id')
  Stream<List<FolderQtdChildView>> getFoldersQtdChild();
}
