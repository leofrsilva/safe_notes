import 'package:safe_notes/app/shared/database/entities/note_entity.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

abstract class IGetListDatasource {
  Stream<List<FolderQtdChildView>> getFoldersQtdChild();
  Stream<List<NoteEntity>> getNotes();
}
