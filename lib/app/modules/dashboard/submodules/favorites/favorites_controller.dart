import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt.dart';

import '../../domain/usecases/note/i_note_usecases.dart';
import '../../presenter/stores/selection_store.dart';

class FavoritesController {
  final SelectionStore selection;
  final IEditNoteUsecase _editNoteUsecase;
  final IDeleteNoteUsecase _deleteNoteUsecase;

  FavoritesController(
    this.selection,
    this._editNoteUsecase,
    this._deleteNoteUsecase,
  );

  List<String> moreButton = [
    'favoritos',
  ];

  void changeTitleFavorite(List<NoteModel> noteSelecteds) {
    moreButton[0] = 'Remover dos favoritos';
  }

  void editFavorite(BuildContext context, List<NoteModel> notes) async {
    List<NoteModel> noteEditable = [];
    noteEditable
        .addAll(notes.map((note) => note.copyWith(favorite: false)).toList());

    final either = await _editNoteUsecase.call(noteEditable);
    if (either.isLeft()) {
      if (either.fold(id, id) is! IncorrectEncryptionError) {
        SnackbarError.show(
          context,
          message: 'Error ao editar a Nota!',
        );
      }
    }
  }

  void deleteNote(BuildContext context, List<NoteModel> notes) async {
    final either = await _deleteNoteUsecase.call(notes);
    if (either.isLeft()) {
      if (either.fold(id, id) is! IncorrectEncryptionError) {
        SnackbarError.show(
          context,
          message: 'Error ao deletar a Nota!',
        );
      }
    }
  }
}
