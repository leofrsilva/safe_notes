import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt_failure.dart';

import '../../../domain/usecases/folder/i_folder_usecase.dart';
import '../../../domain/usecases/note/i_note_usecases.dart';
import '../../../presenter/pages/drawer/drawer_menu_controller.dart';
import '../../../presenter/stores/selection_store.dart';

class FolderController {
  final SelectionStore selection;
  final DrawerMenuController _drawerMenu;
  final IEditNoteUsecase _editNoteUsecase; //
  final IDeleteNoteUsecase _deleteNoteUsecase; //
  final IDeleteFolderUsecase _deleteFolderUsecase;

  // final IEditNoteUsecase _editNoteUsecase;
  // final IDeleteNoteUsecase _deleteNoteUsecase;

  FolderController(
    this._drawerMenu,
    this.selection,
    this._editNoteUsecase,
    this._deleteNoteUsecase,
    this._deleteFolderUsecase,
  ) {
    _folderParent = ValueNotifier<FolderModel>(
      FolderModel(
        folderId: 0,
        userId: '',
        name: '',
        level: 0,
        color: 0,
        isDeleted: false,
        folderParent: null,
        dateCreate: DateTime.now(),
        dateModification: DateTime.now(),
      ),
    );
  }

  late ValueNotifier<FolderModel> _folderParent;

  ValueNotifier<FolderModel> get folderParent => _folderParent;

  set folder(FolderModel folder) {
    _folderParent.value = folder;
    _drawerMenu.selectedMenuItem.value = folder.folderId;
    _drawerMenu.moduleFolderSaveFolderParent(folder);
  }

  FolderModel get folder => _folderParent.value;

  List<String> moreButton = [
    'favoritos',
  ];

  //? EDIT FAVORITE
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
        SnackbarError.show(
          context,
          message: 'Error ao editar a Nota!',
        );
      }
    }
  }

  //?
  String questionTitleDelete(
    List<FolderModel> folderSelecteds,
    List<NoteModel> noteSelecteds,
  ) {
    String title = '';
    if (folderSelecteds.isNotEmpty && noteSelecteds.isNotEmpty) {
      title = 'Mover ${folderSelecteds.length} ';
      title += folderSelecteds.length > 1 ? 'pastas e ' : 'pasta e ';
      title += '${noteSelecteds.length} ';
      title += noteSelecteds.length > 1 ? 'notas ' : 'nota ';
    } else {
      if (folderSelecteds.isNotEmpty && noteSelecteds.isEmpty) {
        title = 'Mover ${folderSelecteds.length} ';
        title += folderSelecteds.length > 1 ? 'pastas ' : 'pasta ';
      } else if (folderSelecteds.isEmpty && noteSelecteds.isNotEmpty) {
        title = 'Mover ${noteSelecteds.length} ';
        title += noteSelecteds.length > 1 ? 'notas ' : 'nota ';
      }
    }
    title += 'para a Lixeira?';
    return title;
  }

  //? DELETE NOTE
  Future deleteNote(BuildContext context, List<NoteModel> notes) async {
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

  //? DELETE FOLDER
  Future deleteFolder(BuildContext context, List<FolderModel> folders) async {
    final either = await _deleteFolderUsecase.call(folders);
    if (either.isLeft()) {
      if (either.fold(id, id) is! IncorrectEncryptionError) {
        SnackbarError.show(
          context,
          message: 'Error ao deletar a Pasta!',
        );
      }
    }
  }
}
