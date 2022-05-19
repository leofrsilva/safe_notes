import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

abstract class IManagerFoldersDatasource {
  Future<int> addFolder(FolderEntity entity);
  Future<int> editFolder(FolderModel model);
  Future<dynamic> deleteFolder(List<FolderEntity> folders);
}
