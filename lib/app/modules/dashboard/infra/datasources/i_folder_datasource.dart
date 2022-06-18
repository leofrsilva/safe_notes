import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

abstract class IFolderDatasource {
  Future<int> addFolder(FolderEntity entity);
  Future<int> editFolder(FolderModel model);
  Future<dynamic> deleteFolder(List<FolderEntity> entities);
  Future<dynamic> restoreFolder(List<FolderEntity> entities);
  Future<dynamic> deletePersistentFolder(List<FolderEntity> entities);
}
