import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/leave/domain/usecases/i_leave_auth_usecase.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';

import '../../design/widgets/snackbar/snackbar_error.dart';
import '../setting/presenter/controllers/access_boot_store.dart';

class SplashController {
  final AppCore _appCore;
  final IExpireToken _expireToken;
  final AccessBootStore _accessBootStore;
  final ILeaveAuthUsecase _leaveAuthUsecase;

  SplashController(
    this._appCore,
    this._expireToken,
    this._accessBootStore,
    this._leaveAuthUsecase,
  );

  String strPage = '/auth/getin/';

  Future<void> checkLoggedInUser(BuildContext context) async {
    await _accessBootStore.loadFirstBoot();

    final infoUser = await _expireToken.checkToken();

    if (infoUser != null) {
      if (infoUser.length > 2) {
        final usuario = UsuarioModel.fromInfoUser(infoUser);
        _appCore.setUsuario(usuario);
        strPage = '/dashboard/notes/';
      } else {
        await logout(context);
      }
    }
    Modular.to.navigate(strPage);
  }

  Future logout(BuildContext context) async {
    strPage = '/auth/getin/relogar';
    final either = await _leaveAuthUsecase.call();
    if (either.isLeft()) {
      final failure = either.fold(id, id);
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
    }
  }
}
