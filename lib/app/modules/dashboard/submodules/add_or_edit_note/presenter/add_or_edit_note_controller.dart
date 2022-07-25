import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt.dart';
import '../../../domain/usecases/note/i_note_usecases.dart';
import '../../../presenter/enum/mode_note_enum.dart';
import 'stores/expanded_store.dart';
import 'stores/input_field_note_store.dart';
import 'stores/scroll_in_top_store.dart';

class AddOrEditNoteController {
  final IAddNoteUsecase _addNoteUsecase;
  final IEditNoteUsecase _editNoteUsecase;
  final IDeleteNotePersistentUsecase _deleteNotePersistentUsecase;

  final ExpandedStore expandedStore;
  final InputFieldNoteStore noteFields;
  final ScrollInTopStore scrollInTopStore;

  AddOrEditNoteController(
    this._addNoteUsecase,
    this._editNoteUsecase,
    this._deleteNotePersistentUsecase,
    this.noteFields,
    this.expandedStore,
    this.scrollInTopStore,
  );

  ModeNoteEnum mode = ModeNoteEnum.add;

  changeFavorite(BuildContext context) {
    noteFields.onChangeFavorite(() {
      if (mode == ModeNoteEnum.edit) {
        editNote(
          context,
          editFavorite: false,
        );
      } else {
        addNote(context);
      }
    });
  }

  changedTitle(BuildContext context, String text) {
    noteFields.onChangedTitle(
      text,
      callback: () {
        if (mode == ModeNoteEnum.edit) {
          editNote(context);
        } else {
          addNote(context);
        }
      },
    );
  }

  changedBody(BuildContext context, String text) {
    noteFields.onChangedBody(
      text,
      callback: () {
        if (mode == ModeNoteEnum.edit) {
          editNote(context);
        } else {
          addNote(context);
        }
      },
    );
  }

  Future<void> addNote(BuildContext context) async {
    final either = await _addNoteUsecase.call(noteFields.model);
    either.fold(
      (failure) {
        if (failure is! IncorrectEncryptionError) {
          SnackbarError.show(
            context,
            message: 'Error ao salvar a Nota!',
          );
        }
      },
      (_) => mode = ModeNoteEnum.edit,
    );
  }

  Future<void> editNote(
    BuildContext context, {
    bool editFavorite = true,
  }) async {
    if (editFavorite) noteFields.nowDateModification();
    final either = await _editNoteUsecase.call([noteFields.model]);
    if (either.isLeft()) {
      if (either.fold(id, id) is! IncorrectEncryptionError) {
        SnackbarError.show(
          context,
          message: 'Error ao editar a Nota!',
        );
      }
    }
  }

  Future<void> delete(BuildContext context) async {
    if (noteFields.model.title.isEmpty && noteFields.model.body.isEmpty) {
      final either =
          await _deleteNotePersistentUsecase.call([noteFields.model]);
      if (either.isLeft()) {
        if (either.fold(id, id) is! IncorrectEncryptionError) {
          SnackbarError.show(
            context,
            message: 'Error ao deletar Nota!',
          );
        }
      }
    }
  }
}
