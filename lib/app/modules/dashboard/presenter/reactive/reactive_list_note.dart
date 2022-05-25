import 'package:safe_notes/app/shared/database/models/note_model.dart';

import 'i_reactive_list_note.dart';

class ReactiveListNote extends IReactiveListNote {
  ReactiveListNote({List<NoteModel>? value}) : super(value ?? []);

  void _removeAllFolder() {
    value.clear();
  }

  @override
  void addAllNotes(List<NoteModel> notes) {
    _removeAllFolder();
    value = notes;
  }

  //* COUNTS
  @override
  int get qtdNotes {
    return value.where((note) => note.isDeleted == false).length;
  }

  @override
  int get qtdFavorites {
    return value
        .where((note) => note.isDeleted == false && note.favorite == true)
        .length;
  }

  //* LISTS
  @override
  List<NoteModel> listAllNote({bool orderByDesc = true}) {
    if (orderByDesc) {
      value.sort((previous, posterior) {
        return posterior.dateModification.compareTo(previous.dateModification);
      });
    } else {
      value.sort((previous, posterior) {
        return previous.dateModification.compareTo(posterior.dateModification);
      });
    }
    return value.where((note) => note.isDeleted == false).toList();
  }

  @override
  List<NoteModel> get favorites {
    value.sort((previous, posterior) {
      return previous.dateModification.compareTo(posterior.dateModification);
    });
    return value
        .where((note) => note.isDeleted == false && note.favorite == true)
        .toList();
  }

  @override
  List<NoteModel> listNoteByFolder(int folderId, bool orderByDesc) {
    if (orderByDesc) {
      value.sort((previous, posterior) {
        return posterior.dateModification.compareTo(previous.dateModification);
      });
    } else {
      value.sort((previous, posterior) {
        return previous.dateModification.compareTo(posterior.dateModification);
      });
    }
    return value
        .where((note) => note.isDeleted == false && note.folderId == folderId)
        .toList();
  }

  //* DELETED
  @override
  List<NoteModel> get listNoteDeleted {
    value.sort((previous, posterior) {
      return previous.dateModification.compareTo(posterior.dateModification);
    });
    return value.where((note) => note.isDeleted == true).toList();
  }

  @override
  List<NoteModel> listNoteByFolderDeleted(int folderId) {
    value.sort((previous, posterior) {
      return previous.dateModification.compareTo(posterior.dateModification);
    });
    return value
        .where((note) => note.isDeleted == true && note.folderId == folderId)
        .toList();
  }
}
