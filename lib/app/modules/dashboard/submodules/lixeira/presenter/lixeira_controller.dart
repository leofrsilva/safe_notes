import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../domain/usecases/folder/i_folder_usecase.dart';
import '../../../domain/usecases/note/i_note_usecases.dart';
import '../../../presenter/stores/selection_store.dart';

class LixeiraController {
  final SelectionStore selection;
  final IRestoreNoteUsecase _restoreNoteUsecase;
  final IRestoreFolderUsecase _restoreFolderUsecase;
  final IDeleteNotePersistentUsecase _deleteNotePersistentUsecase;
  final IDeleteFolderPersistentUsecase _deleteFolderPersistentUsecase;

  LixeiraController(
    this.selection,
    this._restoreNoteUsecase,
    this._restoreFolderUsecase,
    this._deleteNotePersistentUsecase,
    this._deleteFolderPersistentUsecase,
  );

  String questionTitleDelete(
    List<FolderModel> folderSelecteds,
    List<NoteModel> noteSelecteds,
  ) {
    String title = '';
    if (folderSelecteds.isNotEmpty && noteSelecteds.isNotEmpty) {
      title = 'Excluir permanentemente ';
      title += '${folderSelecteds.length} ';
      title += folderSelecteds.length > 1 ? 'pastas e ' : 'pasta e ';
      title += '${noteSelecteds.length} ';
      title += noteSelecteds.length > 1 ? 'notas?' : 'nota?';
    } else {
      if (folderSelecteds.isNotEmpty && noteSelecteds.isEmpty) {
        title = 'Excluir ${folderSelecteds.length} ';
        title += folderSelecteds.length > 1 ? 'pastas' : 'pasta';
      } else if (folderSelecteds.isEmpty && noteSelecteds.isNotEmpty) {
        title = 'Excluir ${noteSelecteds.length} ';
        title += noteSelecteds.length > 1 ? 'notas' : 'nota';
      }
      title += ' permanentemente?';
    }
    return title;
  }

  //? RESTORE
  Future restore(
    BuildContext context,
    List<NoteModel> notes,
    List<FolderModel> folders,
  ) async {
    if (notes.isNotEmpty || folders.isNotEmpty) {
      await LoadingOverlay.show(
        context,
        _processRestore(context, notes, folders),
      );
    }
  }

  Future _processRestore(
    BuildContext context,
    List<NoteModel> notes,
    List<FolderModel> folders,
  ) async {
    if (notes.isNotEmpty) await _restoreNotes(context, notes);
    if (folders.isNotEmpty) await _restoreFolders(context, folders);
  }

  Future _restoreNotes(BuildContext context, List<NoteModel> notes) async {
    final either = await _restoreNoteUsecase.call(notes);
    if (either.isLeft()) {
      String field = notes.length > 1 ? 'Notas' : 'Nota';
      SnackbarError.show(
        context,
        message: 'Error ao restaurar a $field!',
      );
    }
  }

  Future _restoreFolders(
      BuildContext context, List<FolderModel> folders) async {
    final either = await _restoreFolderUsecase.call(folders);
    if (either.isLeft()) {
      String field = folders.length > 1 ? 'Pastas' : 'Pasta';
      SnackbarError.show(
        context,
        message: 'Error ao restaurar a $field!',
      );
    }
  }

  //? DELETE
  void delete(
    BuildContext context,
    List<NoteModel> notes,
    List<FolderModel> folders,
  ) {
    if (notes.isNotEmpty || folders.isNotEmpty) {
      LoadingOverlay.show(
        context,
        _processDelete(context, notes, folders),
      );
    }
  }

  Future _processDelete(
    BuildContext context,
    List<NoteModel> notes,
    List<FolderModel> folders,
  ) async {
    if (notes.isNotEmpty) await _deletePersistentNotes(context, notes);
    if (folders.isNotEmpty) await _deletePersistentFolders(context, folders);
  }

  Future _deletePersistentNotes(
      BuildContext context, List<NoteModel> notes) async {
    final either = await _deleteNotePersistentUsecase.call(notes);
    if (either.isLeft()) {
      String field = notes.length > 1 ? 'Notas' : 'Nota';
      SnackbarError.show(
        context,
        message: 'Error ao excluir a $field!',
      );
    }
  }

  Future _deletePersistentFolders(
      BuildContext context, List<FolderModel> folders) async {
    final either = await _deleteFolderPersistentUsecase.call(folders);
    if (either.isLeft()) {
      String field = folders.length > 1 ? 'Pastas' : 'Pasta';
      SnackbarError.show(
        context,
        message: 'Error ao excluir a $field!',
      );
    }
  }
}
