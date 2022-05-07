import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';

abstract class IManagerFoldersDatasource {
  Future<int> addFolder(FolderEntity entity);
  Future<int> editFolder(FolderEntity entity);
  Future<dynamic> deleteFolder(int id);
}
