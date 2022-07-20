import 'package:safe_notes/app/modules/setting/controllers/folder_buffer_expanded_store.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../reactive/i_reactive_list.dart';
import '../reactive/reactive_list.dart';
import '../reactive/reactive_list_folder.dart';
import '../reactive/reactive_list_note.dart';
import 'list_folders_store.dart';
import 'list_notes_store.dart';

class ListFieldsStore {
  final IReactiveList _reactive = ReactiveList(
    ReactiveListFolder(),
    ReactiveListNote(),
  );
  ReactiveList get reactive => _reactive as ReactiveList;

  final ListNotesStore listNotesStore;
  final ListFoldersStore listFoldersStore;
  final FolderBufferExpandedStore _folderBufferExpandedStore;

  Future<void> _setBuffer() async {
    final mapIsExpanded = await _folderBufferExpandedStore.getBufferExpanded();
    _reactive.setBufferExpanded(mapIsExpanded);
  }

  Future<void> saveBuffer(Map<int, bool> mapBufferExpanded) async {
    await _folderBufferExpandedStore.setBufferExpanded(mapBufferExpanded);
  }

  ListFieldsStore(
    this.listNotesStore,
    this.listFoldersStore,
    this._folderBufferExpandedStore,
  ) {
    _setBuffer();
  }

  setFolders(List<FolderModel> folders) {
    _reactive.addAllFolder(folders);
  }

  setNotes(List<NoteModel> notes) {
    _reactive.addAllNotes(notes);
  }
}
