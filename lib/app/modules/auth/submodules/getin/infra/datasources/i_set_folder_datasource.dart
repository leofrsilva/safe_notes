import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';

abstract class ISetFolderDatasource {
  Future<dynamic> setDefaultFolder(FolderEntity defaultFolder);
}
