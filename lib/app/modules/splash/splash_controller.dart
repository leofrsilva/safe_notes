import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/folder/presenter/folder_controller.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/leave/domain/usecases/i_leave_auth_usecase.dart';
import 'package:safe_notes/app/modules/dashboard/submodules/folder/folder_module.dart';

import '../../design/widgets/snackbar/snackbar_error.dart';
import '../setting/controllers/access_boot_store.dart';
import '../setting/controllers/manager_route_navigator_store.dart';

class SplashController {
  final AppCore _appCore;
  final IExpireToken _expireToken;
  final AccessBootStore _accessBootStore;
  final ILeaveAuthUsecase _leaveAuthUsecase;
  final ManagerRouteNavigatorStore _managerRouteNavigatorStore;

  SplashController(
    this._appCore,
    this._expireToken,
    this._accessBootStore,
    this._leaveAuthUsecase,
    this._managerRouteNavigatorStore,
  );

  FolderModel? _folder;
  String strPage = '/auth/getin/';

  Future<String> redirectRoute() async {
    var page = await _managerRouteNavigatorStore.getPage();
    if (page.isNotEmpty) {
      var infoFolder = await _managerRouteNavigatorStore.getFolderParent();
      if (infoFolder.isNotEmpty) {
        _folder = FolderModel.fromJson(infoFolder);
      }
      return page;
    }
    return '/dashboard/mod-notes/';
  }

  Future<void> navigateToModule() async {
    Modular.to.navigate(strPage);
    if (_folder != null) {
      await Modular.isModuleReady<FolderModule>().then((_) async {
        await Future.delayed(
          const Duration(milliseconds: 200),
          () async {
            final _controllerFolder = Modular.get<FolderController>();
            _controllerFolder.folder = _folder!;
          },
        );
      });
    }
  }

  Future<void> checkLoggedInUser(BuildContext context) async {
    await _accessBootStore.loadFirstBoot();

    final infoUser = await _expireToken.checkToken();

    if (infoUser != null) {
      if (infoUser.length > 2) {
        final usuario = UsuarioModel.fromInfoUser(infoUser);
        _appCore.setUsuario(usuario);
        strPage = await redirectRoute();
      } else {
        await logout(context);
      }
    }
    navigateToModule();
  }

  Future<void> logout(BuildContext context) async {
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
