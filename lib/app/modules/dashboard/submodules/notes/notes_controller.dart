import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt_failure.dart';

import '../../domain/usecases/note/i_note_usecases.dart';
import '../../presenter/stores/selection_store.dart';

class NotesController {
  final SelectionStore selection;
  final IEditNoteUsecase _editNoteUsecase;
  final IDeleteNoteUsecase _deleteNoteUsecase;

  NotesController(
    this.selection,
    this._editNoteUsecase,
    this._deleteNoteUsecase,
  );

  List<String> moreButton = [
    'favoritos',
  ];

  String _strAddOrRemoveFavorite(List<NoteModel> noteSelecteds) {
    int existFavorite = noteSelecteds.where((note) {
      return note.favorite == true;
    }).length;
    int notExistFavorite = noteSelecteds.where((note) {
      return note.favorite == false;
    }).length;

    if (existFavorite > 0 && notExistFavorite == 0) {
      return 'Remover';
    } else {
      return 'Adicionar';
    }
  }

  void changeTitleFavorite(List<NoteModel> noteSelecteds) {
    String strOpFavorite = _strAddOrRemoveFavorite(noteSelecteds);
    moreButton[0] = '$strOpFavorite dos favoritos';
  }

  //? EDIT
  void editFavorite(BuildContext context, List<NoteModel> notes) async {
    List<NoteModel> noteEditable = [];
    if (_strAddOrRemoveFavorite(notes).contains('Remover')) {
      noteEditable
          .addAll(notes.map((note) => note.copyWith(favorite: false)).toList());
    } else {
      noteEditable
          .addAll(notes.map((note) => note.copyWith(favorite: true)).toList());
    }

    final either = await _editNoteUsecase.call(noteEditable);
    if (either.isLeft()) {
      if (either.fold(id, id) is! IncorrectEncryptionError) {
        if (context.mounted) {
          SnackbarError.show(
            context,
            message: 'Error ao editar a Nota!',
          );
        }
      }
    }
  }

  //? DELETE
  void deleteNote(BuildContext context, List<NoteModel> notes) async {
    final either = await _deleteNoteUsecase.call(notes);
    if (either.isLeft()) {
      if (either.fold(id, id) is! IncorrectEncryptionError) {
        if (context.mounted) {
          SnackbarError.show(
            context,
            message: 'Error ao deletar a Nota!',
          );
        }
      }
    }
  }
}
