import 'package:flutter/cupertino.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../domain/usecases/i_lixeira_usecases.dart';

class LixeiraController {
  final IGetNotesDeletedUsecase _getNotesDeletedUsecase;
  LixeiraController(
    this._getNotesDeletedUsecase,
  );

  Future<List<NoteModel>> getNotesDeleted(BuildContext context) async {
    final either = await _getNotesDeletedUsecase.call();

    List<NoteModel> list = [];
    either.fold(
      (_) {
        SnackbarError.show(
          context,
          message: 'Error ao carregar Notas Deletadas!',
        );
      },
      (notes) {
        list.addAll(notes);
      },
    );
    return list;
  }
}
