import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/modules/setting/presenter/controllers/access_boot_store.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';

import '../../domain/errors/getin_failures.dart';
import '../../domain/usecases/external/i_getin_firebase_usecase.dart';

class LoginController {
  final AppCore _appCore;
  final IExpireToken _expireToken;
  final AccessBootStore _accessBootStore;
  final ILoginAuthenticationUsecase _loginAuthenticationUsecase;
  final IUpdateLoggedUserFirestoreUsecase _updateLoggedUserFirestoreUsecase;
  final IGetUserFirestoreUsecase _getUserFirestoreUsecase;
  Failure? failure;

  late GlobalKey<FormState> formKey;
  set formState(GlobalKey<FormState> value) => formKey = value;

  String _emailField = '';
  String _passField = '';

  set emailField(String value) => _emailField = value;
  set passField(String value) => _passField = value;

  LoginController(
    this._appCore,
    this._expireToken,
    this._accessBootStore,
    this._loginAuthenticationUsecase,
    this._updateLoggedUserFirestoreUsecase,
    this._getUserFirestoreUsecase,
  ) {
    formKey = GlobalKey<FormState>();
  }

  Future<void> login(BuildContext context) async {
    failure = null;
    final formState = formKey.currentState;
    if (formState != null) {
      if (formState.validate()) {
        formState.save();

        await LoadingOverlay.show(
          context,
          processesLogin(),
        );

        if (failure != null) {
          // Login Authentication
          if (failure is NoFoundUserInLoginAuthFirebase) {
            SnackbarError.show(
              context,
              title: 'Erro ao Logar',
              message: 'Usuário cadastrado não retornado!',
            );
          } else if (failure is LoginAuthFirebaseError) {
            if (failure!.exception.code == 'network-request-failed') {
              SnackbarError.show(context, message: failure!.errorMessage);
            } else {
              SnackbarError.show(
                context,
                title: failure?.exception.code == '' ? null : 'Erro ao Logar',
                message: failure!.errorMessage,
              );
            }
          }
          // Get Firestore
          else if (failure is GetinFirestoreError) {
            SnackbarError.show(
              context,
              message: failure!.errorMessage,
            );
          } else if (failure is GetinNoDataFoundFirestoreError) {
            SnackbarError.show(
              context,
              title: 'Erro ao Logar',
              message: 'Dados do Usuário não encontrado!',
            );
          } else {
            SnackbarError.show(
              context,
              title: 'Erro',
              message: failure!.errorMessage,
            );
          }
        }
      }
    }
  }

  Future<void> processesLogin() async {
    final loginAuth = await _loginAuthenticationUsecase(
      _emailField,
      _passField,
    );
    loginAuth.fold(
      (error) => failure = error,
      (uid) async {
        final updateLogged = await _updateLoggedUserFirestoreUsecase(uid);
        updateLogged.fold(
          (error) => failure = error,
          (_) async {
            final getUserFirestore = await _getUserFirestoreUsecase.call(uid);
            getUserFirestore.fold(
              (error) => failure = error,
              (usuarioEntity) async {
                final usuario = UsuarioModel.fromEntity(usuarioEntity);

                await _accessBootStore.updateFolderUserID(usuario.docRef);
                await _expireToken.generaterToken(usuario.toInfoUser());

                _appCore.setUsuario(usuario);
                Modular.to.navigate('/dashboard/mod-notes/');
              },
            );
          },
        );
      },
    );
  }
}
