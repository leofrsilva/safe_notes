import 'package:safe_notes/app/shared/database/entities/folder_entity.dart';
import 'package:safe_notes/app/shared/database/entities/note_entity.dart';

abstract class IGetListDatasource {
  Stream<List<FolderEntity>> getFolders();
  Stream<List<NoteEntity>> getNotes();
}
