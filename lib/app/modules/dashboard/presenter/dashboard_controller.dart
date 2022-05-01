import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/design/widgets/loading/loading_overlay.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/leave/domain/usecases/i_leave_auth_usecase.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';

class DashboardController {
  final AppCore _appCore;
  final IExpireToken _expireToken;
  final ILeaveAuthUsecase _leaveAuthUsecase;

  DashboardController(
    this._appCore,
    this._expireToken,
    this._leaveAuthUsecase,
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
}
