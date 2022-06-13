import 'package:safe_notes/app/shared/database/models/note_model.dart';

import 'i_reactive_list_note.dart';

class ReactiveListNote extends IReactiveListNote {
  List<NoteModel> _value = [];

  void _removeAllFolder() {
    _value.clear();
  }

  @override
  void addAllNotes(List<NoteModel> notes) {
    _removeAllFolder();
    _value = notes;
  }

  //* COUNTS
  @override
  int get qtdNotes {
    return _value.where((note) => note.isDeleted == false).length;
  }

  @override
  int get qtdFavorites {
    return _value
        .where((note) => note.isDeleted == false && note.favorite == true)
        .length;
  }

  //* LISTS
  @override
  List<NoteModel> listAllNote({bool orderByDesc = true}) {
    if (orderByDesc) {
      _value.sort((previous, posterior) {
        return posterior.dateModification.compareTo(previous.dateModification);
      });
    } else {
      _value.sort((previous, posterior) {
        return previous.dateModification.compareTo(posterior.dateModification);
      });
    }
    return _value.where((note) => note.isDeleted == false).toList();
  }

  @override
  List<NoteModel> get favorites {
    _value.sort((previous, posterior) {
      return previous.dateModification.compareTo(posterior.dateModification);
    });
    return _value
        .where((note) => note.isDeleted == false && note.favorite == true)
        .toList();
  }

  @override
  List<NoteModel> listNoteByFolder(int folderId, {bool orderByDesc = true}) {
    if (orderByDesc) {
      _value.sort((previous, posterior) {
        return posterior.dateModification.compareTo(previous.dateModification);
      });
    } else {
      _value.sort((previous, posterior) {
        return previous.dateModification.compareTo(posterior.dateModification);
      });
    }
    return _value
        .where((note) => note.isDeleted == false && note.folderId == folderId)
        .toList();
  }

  @override
  List<NoteModel> searchNote(String text) {
    if (text.isEmpty) return [];
    return _value
        .where((note) =>
            note.title.toLowerCase().contains(text.toLowerCase()) ||
            note.body.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  //* DELETED
  @override
  List<NoteModel> get listNoteDeleted {
    _value.sort((previous, posterior) {
      return previous.dateModification.compareTo(posterior.dateModification);
    });
    return _value.where((note) => note.isDeleted == true).toList();
  }

  @override
  List<NoteModel> listNoteByFolderDeleted(int folderId) {
    _value.sort((previous, posterior) {
      return previous.dateModification.compareTo(posterior.dateModification);
    });
    return _value
        .where((note) => note.isDeleted == true && note.folderId == folderId)
        .toList();
  }
}
