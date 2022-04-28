import 'package:flutter/cupertino.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/leave/domain/usecases/i_leave_auth_usecase.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';

import '../../design/widgets/snackbar/snackbar_error.dart';
import '../setting/presenter/controllers/first_boot_store.dart';

class SplashController {
  final AppCore _appCore;
  final IExpireToken _expireToken;
  final FirstBootStore _firstBootStore;
  final ILeaveAuthUsecase _leaveAuthUsecase;

  SplashController(
    this._appCore,
    this._expireToken,
    this._firstBootStore,
    this._leaveAuthUsecase,
  );

  Future<void> checkLoggedInUser(BuildContext context) async {
    final infoUser = await _expireToken.checkToken(
      onCallBackExpiredTime: () async {
        await logout(context);
      },
    );

    if (infoUser != null) {
      final usuario = UsuarioModel.fromInfoUser(infoUser);
      // await _accessBootStore.loadAccessBoot(usuario.docRef);
      _appCore.setUsuario(usuario);
      Modular.to.navigate('/dashboard/notes/');
    } else {
      Modular.to.navigate('/auth/getin/');
    }
  }

  Future logout(BuildContext context) async {
    final either = await _leaveAuthUsecase();
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
          () => Modular.to.navigate('/auth/getin/'),
        );
      },
      (_) async {
        Modular.to.navigate('/auth/getin/');
      },
    );
  }
}
