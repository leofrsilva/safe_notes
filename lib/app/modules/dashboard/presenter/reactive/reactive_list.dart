import 'package:flutter/foundation.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import 'i_reactive_list.dart';
import 'i_reactive_list_folder.dart';
import 'i_reactive_list_note.dart';

class ReactiveList extends ChangeNotifier implements IReactiveList {
  final IReactiveListFolder _reactiveFolders;
  final IReactiveListNote _reactiveNotes;

  ReactiveList(this._reactiveFolders, this._reactiveNotes);

  @override
  int numberChildrenInFolder(FolderModel folder) {
    int countNotes = listNoteByFolder(folder.folderId).length;
    int countFolders = qtdChildrenFolder(folder.folderId);
    return countNotes + countFolders;
  }

  @override
  int get numberItemsDeleted {
    return qtdFolderdeleted + qtdNoteDeleted;
  }

  //* ----------------------------------------------
  //* FOLDER
  //* ----------------------------------------------

  //? -- BUFFER
  @override
  setBufferExpanded(Map<int, bool> map) {
    _reactiveFolders.setBufferExpanded(map);
  }

  @override
  Map<int, bool> get getBufferExpanded {
    return _reactiveFolders.getBufferExpanded;
  }

  //? -- LIST DELETED
  @override
  int get qtdFolderdeleted => _reactiveFolders.qtdFolderdeleted;

  @override
  List<FolderModel> get listFolderDeleted {
    return _reactiveFolders.listFolderDeleted;
  }

  //? -- EXPANDED
  @override
  addAllFolder(List<FolderModel> folders) {
    _reactiveFolders.addAllFolder(folders);
    notifyListeners();
  }

  @override
  notExpanded({required int folderId}) {
    _reactiveFolders.notExpanded(folderId: folderId);
    notifyListeners();
  }

  @override
  expanded({required int folderId}) {
    _reactiveFolders.expanded(folderId: folderId);
    notifyListeners();
  }

  @override
  bool checkFolderIsExpanded(int id) {
    return _reactiveFolders.checkFolderIsExpanded(id);
  }

  //? -- LIST FOLDER
  @override
  FolderModel getFolder(int id) {
    return _reactiveFolders.getFolder(id);
  }

  @override
  List<FolderModel> get listFolder {
    return _reactiveFolders.listFolder;
  }

  @override
  int qtdChildrenFolder(int folderId) {
    return _reactiveFolders.qtdChildrenFolder(folderId);
  }

  @override
  List<FolderModel> childrensFolder(int folderId) {
    return _reactiveFolders.childrensFolder(folderId);
  }

  @override
  List<FolderModel> listDescendants(FolderModel folder) {
    return _reactiveFolders.listDescendants(folder);
  }

  //? -- FUNCTION FOR NAME FOLDER
  @override
  int qtdNameFolder(int parentId, int level) {
    return _reactiveFolders.qtdNameFolder(parentId, level);
  }

  @override
  bool checkNameAlreadyExists(FolderModel folderer) {
    return _reactiveFolders.checkNameAlreadyExists(folderer);
  }

  //* ----------------------------------------------
  //* NOTE
  //* ----------------------------------------------

  @override
  void addAllNotes(List<NoteModel> notes) {
    _reactiveNotes.addAllNotes(notes);
    notifyListeners();
  }

  //? -- COUNTS
  @override
  int get qtdNotes {
    return _reactiveNotes.qtdNotes;
  }

  @override
  int get qtdFavorites {
    return _reactiveNotes.qtdFavorites;
  }

  //? -- LISTS
  @override
  List<NoteModel> listAllNote({bool orderByDesc = true}) {
    return _reactiveNotes.listAllNote(orderByDesc: orderByDesc);
  }

  @override
  List<NoteModel> get favorites {
    return _reactiveNotes.favorites;
  }

  @override
  List<NoteModel> listNoteByFolder(int folderId, {bool orderByDesc = true}) {
    return _reactiveNotes.listNoteByFolder(folderId, orderByDesc: orderByDesc);
  }

  @override
  List<NoteModel> searchNote(String text) {
    return _reactiveNotes.searchNote(text);
  }

  //* DELETED
  @override
  int get qtdNoteDeleted {
    return _reactiveNotes.qtdNoteDeleted;
  }

  @override
  List<NoteModel> get listNoteDeleted {
    return _reactiveNotes.listNoteDeleted;
  }

  @override
  List<NoteModel> listNoteByFolderDeleted(int folderId) {
    return _reactiveNotes.listNoteByFolderDeleted(folderId);
  }
}
