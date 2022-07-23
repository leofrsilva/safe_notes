import 'package:flutter/material.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/widgets/loading/loading_overlay.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/leave/domain/usecases/i_leave_auth_usecase.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';

import '../domain/usecases/folder/i_folder_usecase.dart';
import '../domain/usecases/note/i_note_usecases.dart';
import 'stores/list_fields_store.dart';

class DashboardController {
  final AppCore _appCore;
  final IExpireToken _expireToken;
  final ILeaveAuthUsecase _leaveAuthUsecase;
  final ListFieldsStore _listFieldsStore;

  final IDeleteNotePersistentUsecase _deleteNotePersistentUsecase;
  final IDeleteFolderPersistentUsecase _deleteFolderPersistentUsecase;

  DashboardController(
    this._appCore,
    this._expireToken,
    this._leaveAuthUsecase,
    this._listFieldsStore,
    this._deleteNotePersistentUsecase,
    this._deleteFolderPersistentUsecase,
  );

  void logout(BuildContext context) async {
    await LoadingOverlay.show(
      context,
      processesLogin(context),
    );
  }

  Future<void> processesLogin(context) async {
    await _expireToken.expireToken();

    _appCore.removeUsuario();

    final either = await _leaveAuthUsecase.call();
    either.fold(
      (failure) async {
        if (failure.exception is String) {
          if (failure.exception == 'network-request-failed') {
            SnackbarError.show(context, message: failure.errorMessage);
          }
        } else {
          SnackbarError.show(
            context,
            message: 'Falha ao registrar como Deslogado!',
          );
        }
        await Future.delayed(
          const Duration(milliseconds: 1500),
          () => Modular.to.navigate('/auth/getin/relogar'),
        );
      },
      (_) async {
        Modular.to.navigate('/auth/getin/relogar');
      },
    );
  }

  void deleteExpiration() async {
    await _deleteExpirationNote();
    await _deleteExpirationFolder();
  }

  Future _deleteExpirationFolder() async {
    final foldersDeleted = _listFieldsStore.reactive.listFolderDeleted;
    if (foldersDeleted.isNotEmpty) {
      final list = foldersDeleted //
          .where((folder) => folder.deletionExpiration == -1)
          .toList();

      if (list.isNotEmpty) {
        var listNoteChildrens = _listFieldsStore.reactive.listNoteAllDeleted;
        await _deleteNotePersistentUsecase(listNoteChildrens);
        await _deleteFolderPersistentUsecase.call(list);
      }
    }
  }

  Future _deleteExpirationNote() async {
    final notesDeleted = _listFieldsStore.reactive.listNoteDeleted;
    if (notesDeleted.isNotEmpty) {
      final list = notesDeleted //
          .where((note) => note.deletionExpiration == -1)
          .toList();

      if (list.isNotEmpty) {
        await _deleteNotePersistentUsecase.call(list);
      }
    }
  }
}
