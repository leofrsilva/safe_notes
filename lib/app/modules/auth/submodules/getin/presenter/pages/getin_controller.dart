import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/widgets/loading/loading_overlay.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../domain/errors/getin_failures.dart';
import '../../domain/usecases/i_getin_firebase_usecase.dart';

class GetinController {
  final ILoginAuthenticationUsecase loginAuthenticationUsecase;
  final IGetUserFirestoreUsecase getUserFirestoreUsecase;
  Failure? failure;

  late final GlobalKey<FormState> formKey;

  String _emailField = '';
  String _passsField = '';

  set emailField(String value) => _emailField = value;
  set passsField(String value) => _passsField = value;

  GetinController(
    this.loginAuthenticationUsecase,
    this.getUserFirestoreUsecase,
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
            SnackbarError.show(
              context,
              title: 'Erro ao Logar',
              message: failure!.errorMessage,
            );
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
    final loginAuth = await loginAuthenticationUsecase(
      _emailField,
      _passsField,
    );
    loginAuth.fold(
      (error) => failure = error,
      (uid) async {
        final getUserFirestore = await getUserFirestoreUsecase.call(uid);
        getUserFirestore.fold(
          (error) => failure = error,
          (usuarioEntity) async {
            // final createUser = await getinUserUsecase.call(usuarioEntity);
            // createUser.fold(
            //   (error) => failure = error,
            //   (entity) {
            //     final userShared = Modular.get<UserSharedController>();
            //     userShared.setModel =
            //         UsuarioModel.fromEntity(entity).toDBUser();
            //     Modular.to.navigate('/dashboard/');
            //   },
            // );
          },
        );
      },
    );
  }
}
