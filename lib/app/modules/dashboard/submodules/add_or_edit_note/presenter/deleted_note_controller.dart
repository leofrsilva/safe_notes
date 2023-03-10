import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../domain/usecases/note/i_note_usecases.dart';
import 'stores/scroll_in_top_store.dart';

class DeletedNoteController {
  final ScrollInTopStore scrollInTopStore;
  final IRestoreNoteUsecase _restoreNoteUsecase;
  final IDeleteNotePersistentUsecase _deleteNotePersistentUsecase;

  DeletedNoteController(
    this.scrollInTopStore,
    this._restoreNoteUsecase,
    this._deleteNotePersistentUsecase,
  );

  Future restoreNotes(BuildContext context, NoteModel note) async {
    final either = await _restoreNoteUsecase.call([note]);
    if (either.isLeft()) {
      if (context.mounted) {
        SnackbarError.show(
          context,
          message: 'Error ao restaurar a Nota!',
        );
      }
    } else {
      Modular.to.pop();
    }
  }

  Future deletePersistentNotes(BuildContext context, NoteModel note) async {
    final either = await _deleteNotePersistentUsecase.call([note]);
    if (either.isLeft()) {
      if (context.mounted) {
        SnackbarError.show(
          context,
          message: 'Error ao excluir a Nota!',
        );
      }
    } else {
      Modular.to.pop();
    }
  }
}
