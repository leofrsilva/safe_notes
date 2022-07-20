import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import 'i_reactive_list_folder.dart';
import 'i_reactive_list_note.dart';

abstract class IReactiveList implements IReactiveListFolder, IReactiveListNote {
  int numberChildrenInFolderDeleted(FolderModel folder);
  int numberChildrenInFolder(FolderModel folder);
  int get numberItemsDeleted;
  List<NoteModel> get listNoteAllDeleted;
}
