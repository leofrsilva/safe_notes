import 'package:flutter/cupertino.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

abstract class IReactiveListNote extends ValueNotifier<List<NoteModel>> {
  IReactiveListNote(List<NoteModel> value) : super(value);

  addAllNotes(List<NoteModel> notes);

  // COUNTS
  int get qtdNotes;

  int get qtdFavorites;

  // LISTS
  List<NoteModel> get listAllNote;

  List<NoteModel> get favorites;

  List<NoteModel> listNoteByFolder(int folderId);

  // DELETED
  List<NoteModel> get listNoteDeleted;

  List<NoteModel> listNoteByFolderDeleted(int folderId);
}
