import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../../reactive/reactive_list_folder.dart';
import '../../../reactive/reactive_list_note.dart';
import '../../../stores/list_folders_store.dart';
import '../../../stores/list_notes_store.dart';

class SharedReactiveLists {
  final ListFoldersStore _listFoldersStore;
  final ListNotesStore _listNotesStore;

  ListFoldersStore get listFoldersStore => _listFoldersStore;
  ListNotesStore get listNotesStore => _listNotesStore;

  SharedReactiveLists(
    this._listFoldersStore,
    this._listNotesStore,
  );

  ReactiveListFolder get reactiveFolders => _listFoldersStore.reactiveList;
  List<FolderQtdChildView> get listFolders => reactiveFolders.listFolder;

  ReactiveListNote get reactiveNotes => _listNotesStore.reactiveList;
}
