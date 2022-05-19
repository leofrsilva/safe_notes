import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

class NotesController extends NotifierStore<Failure, List<NoteModel>> {
  NotesController(List<NoteModel>? initialState) : super(initialState ?? []);

  Future<void> getNotes(BuildContext context) async {
    // final either = await _getNotesDeletedUsecase.call();

    // List<NoteModel> list = [];
    // either.fold(
    //   (_) {
    //     SnackbarError.show(
    //       context,
    //       message: 'Error ao carregar Notas Deletadas!',
    //     );
    //   },
    //   (notes) {
    //     list.addAll(notes);
    //   },
    // );
    // return list;
  }
}
