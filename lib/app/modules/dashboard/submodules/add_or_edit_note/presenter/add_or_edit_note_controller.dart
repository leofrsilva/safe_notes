import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import '../domain/usecases/i_note_usecases.dart';
import 'enum/mode_note_enum.dart';

class AddOrEditNoteController {
  final IAddNoteUsecase _addNoteUsecase;
  final IEditNoteUsecase _editNoteUsecase;
  final IDeleteNoteEmptyUsecase _deleteNoteEmptyUsecase;

  final ExpandedStore expandedStore;
  final ScrollInTopStore scrollInTopStore;

  AddOrEditNoteController(
    this._addNoteUsecase,
    this._editNoteUsecase,
    this._deleteNoteEmptyUsecase,
    this.expandedStore,
    this.scrollInTopStore,
  );

  Timer? _debounceTitle;

  onChangedTitle(BuildContext context, String text) {
    if (_debounceTitle?.isActive ?? false) _debounceTitle!.cancel();
    _debounceTitle = Timer(const Duration(milliseconds: 500), () {
      title = text.trim();
      if (mode == ModeNoteEnum.edit) {
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
      if (mode == ModeNoteEnum.edit) {
        editNote(context);
      } else {
        addNote(context);
      }
    });
  }

  ModeNoteEnum mode = ModeNoteEnum.add;
  NoteModel noteModel = NoteModel.empty();

  void changeFavorite(BuildContext context) {
    noteModel = noteModel.copyWith(favorite: !noteModel.favorite);
    if (mode == ModeNoteEnum.edit) {
      editNote(context);
    } else {
      addNote(context);
    }
  }

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
    final either = await _addNoteUsecase.call(noteModel);
    either.fold(
      (failure) {
        SnackbarError.show(
          context,
          message: 'Error ao salvar a Nota!',
        );
      },
      (_) => mode = ModeNoteEnum.edit,
    );
  }

  Future<void> editNote(BuildContext context) async {
    noteModel = noteModel.copyWith(dateModification: DateTime.now());
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
