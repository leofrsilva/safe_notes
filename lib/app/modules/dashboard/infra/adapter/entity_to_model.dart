import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

class EntityToModel {
  static List<FolderModel> fromListFolderEntity(List<FolderEntity> entities) {
    return entities.map((entity) => FolderModel.fromEntity(entity)).toList();
  }
}
