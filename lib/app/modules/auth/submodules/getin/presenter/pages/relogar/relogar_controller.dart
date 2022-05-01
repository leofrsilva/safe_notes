import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';

import '../../../domain/errors/getin_failures.dart';
import '../../../domain/usecases/sqlite/i_delete_all_folder_except_usecase.dart';
import '../../controllers/login_controller.dart';

class RelogarController {
  final IExpireToken _expireToken;
  final LoginController _loginController;
  final IDeleteAllFolderExceptUsecase _deleteAllFolderExceptUsecase;
  Failure? failure;

  late GlobalKey<FormState> formKey;

  set pass(String value) => _loginController.passField = value;

  ValueNotifier<String> name = ValueNotifier<String>('');
  ValueNotifier<String> email = ValueNotifier<String>('');

  RelogarController(
    this._expireToken,
    this._loginController,
    this._deleteAllFolderExceptUsecase,
  ) {
    getInfoUser();
    formKey = GlobalKey<FormState>();
  }

  Future getInfoUser() async {
    final mapInfoUser = await _expireToken.checkToken();
    if (mapInfoUser != null) {
      name.value = mapInfoUser['name'];
      email.value = mapInfoUser['email'];
      _loginController.emailField = mapInfoUser['email'];
    }
  }

  Future<void> login(BuildContext context) async {
    _loginController.formState = formKey;
    await _loginController.login(context);
  }

  Future<void> closeRelogar(BuildContext context) async {
    failure = null;
    await LoadingOverlay.show(
      context,
      processesDeleteFolders(),
    );

    if (failure != null) {
      if (failure is DeleteAllFolderExceptSqliteError) {
        SnackbarError.show(
          context,
          title: 'Erro ao Deslogar',
          message: 'Falha ao deletar pastas dos Usuários!',
        );
      }
    }
  }

  Future<void> processesDeleteFolders() async {
    int id = DefaultDatabase.folderIdDefault;
    final loginAuth = await _deleteAllFolderExceptUsecase.call(id);
    loginAuth.fold(
      (error) => failure = error,
      (_) async {
        await _expireToken.removeToken();
        Modular.to.navigate('/auth/getin/');
      },
    );
  }
}
