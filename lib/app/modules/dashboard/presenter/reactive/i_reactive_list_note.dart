import 'package:flutter/cupertino.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

abstract class IReactiveListNote {
  addAllNotes(List<NoteModel> notes);

  // COUNTS
  int get qtdNotes;

  int get qtdFavorites;

  // LISTS
  List<NoteModel> listAllNote({bool orderByDesc = true});

  List<NoteModel> get favorites;

  List<NoteModel> listNoteByFolder(int folderId, {bool orderByDesc = true});

  List<NoteModel> searchNote(String text);

  // DELETED
  List<NoteModel> get listNoteDeleted;

  List<NoteModel> listNoteByFolderDeleted(int folderId);
}
