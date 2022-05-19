import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import '../domain/usecases/i_note_usecases.dart';

class AddOrEditNoteController {
  final IAddNoteUsecase _addNoteUsecase;
  final IEditNoteUsecase _editNoteUsecase;
  final IDeleteNoteEmptyUsecase _deleteNoteEmptyUsecase;

  AddOrEditNoteController(
    this._addNoteUsecase,
    this._editNoteUsecase,
    this._deleteNoteEmptyUsecase,
  ) {
    _alreadySaved = false;
  }

  Timer? _debounceTitle;

  onChangedTitle(BuildContext context, String text) {
    if (_debounceTitle?.isActive ?? false) _debounceTitle!.cancel();
    _debounceTitle = Timer(const Duration(milliseconds: 500), () {
      title = text.trim();
      if (alreadySaved) {
        editNote(context);
      } else {
        addNote(context);
      }
    });
  }

  Timer? _debounceBody;

  onChangedBody(BuildContext context, String text) {
    if (_debounceBody?.isActive ?? false) _debounceBody!.cancel();
    _debounceBody = Timer(const Duration(milliseconds: 500), () {
      body = text;
      if (alreadySaved) {
        editNote(context);
      } else {
        addNote(context);
      }
    });
  }

  late bool _alreadySaved;
  bool get alreadySaved => _alreadySaved;

  NoteModel noteModel = NoteModel.empty();

  set folderId(int id) {
    noteModel = noteModel.copyWith(folderId: id);
  }

  set title(String title) {
    noteModel = noteModel.copyWith(title: title);
  }

  set body(String body) {
    noteModel = noteModel.copyWith(body: body);
  }

  Future<void> addNote(BuildContext context) async {
    print(noteModel.noteId);
    print(noteModel.folderId);
    // print(noteModel.);
    print('**************************************');
    print('**************************************');
    print('**************************************');
    final either = await _addNoteUsecase.call(noteModel);
    either.fold(
      (failure) {
        print(failure.errorMessage);
        SnackbarError.show(
          context,
          message: 'Error ao salvar a Nota!',
        );
      },
      (_) => _alreadySaved = true,
    );
  }

  Future<void> editNote(BuildContext context) async {
    final either = await _editNoteUsecase.call(noteModel);
    if (either.isLeft()) {
      SnackbarError.show(
        context,
        message: 'Error ao editar a Nota!',
      );
    }
  }

  Future<void> delete() async {
    if (noteModel.title.isEmpty && noteModel.body.isEmpty) {
      final either = await _deleteNoteEmptyUsecase.call(noteModel);
      either.fold(
        (failure) {},
        (_) {},
      );
    }
  }
}
