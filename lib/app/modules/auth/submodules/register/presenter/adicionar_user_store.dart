import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/design/widgets/loading/loading_overlay.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/modules/setting/presenter/controllers/access_boot_store.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';

import '../domain/errors/signup_failures.dart';
import '../domain/usecases/i_signup_firebase_usecase.dart';

class AdicionarUserController {
  final AppCore _appCore;
  final IExpireToken _expireToken;
  final AccessBootStore _accessBootStore;
  final ICreateUserAuthenticationUsecase _createUserAuthenticationUsecase;
  final ISetUserFirestoreUsecase _setUserFirestoreUsecase;
  Failure? failure;

  late final ValueNotifier<int> currentPage;

  late final PageController pageController;
  late final GlobalKey<FormState> formKeyToInfoUser;
  late final GlobalKey<FormState> formKeyToInfoAccess;

  late final TextEditingController textControllerName;
  late final TextEditingController textControllerEmail;
  late final TextEditingController textControllerDate;

  String digitsPass = '';
  String digitsConfPass = '';
  String? checkEmailErrorMessage;
  bool get passwordConfirmed => digitsPass == digitsConfPass;

  UsuarioModel usuario = UsuarioModel.empty();

  AdicionarUserController(
    this._appCore,
    this._expireToken,
    this._accessBootStore,
    this._createUserAuthenticationUsecase,
    this._setUserFirestoreUsecase,
  ) {
    pageController = PageController(initialPage: 0);
    currentPage = ValueNotifier<int>(0);

    formKeyToInfoUser = GlobalKey<FormState>();
    formKeyToInfoAccess = GlobalKey<FormState>();
    textControllerName = TextEditingController();
    textControllerEmail = TextEditingController();
    textControllerDate = TextEditingController();
  }

  void backForInfUser() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 5000),
      curve: Curves.elasticOut,
    );
    digitsPass = '';
    digitsConfPass = '';
    textControllerEmail.clear();
  }

  void savedInfoUser() {
    final formState = formKeyToInfoUser.currentState;
    if (formState != null) {
      if (formState.validate()) {
        formState.save();
        pageController.nextPage(
          duration: const Duration(milliseconds: 5000),
          curve: Curves.elasticOut,
        );
      }
    }
  }

  Future<void> savedInfoAccess(BuildContext context) async {
    failure = null;
    final formState = formKeyToInfoAccess.currentState;

    if (formState != null) {
      if (formState.validate()) {
        formState.save();

        await LoadingOverlay.show(
          context,
          processesCreationUser(context),
        );

        if (failure != null) {
          if (failure is NoFoundUserInCreateUserAuthFirebase) {
            SnackbarError.show(
              context,
              title: 'Erro ao Criar Usuário',
              message: 'Nenhum Usuário retornado!',
            );
          }
          // Create Authentication
          else if (failure is CreateUserAuthFirebaseError) {
            if (failure!.exception.code == 'network-request-failed') {
              SnackbarError.show(context, message: failure!.errorMessage);
            } else if (failure!.exception.code == 'email-already-in-use') {
              checkEmailErrorMessage = failure!.errorMessage;
              formState.validate();
            } else {
              SnackbarError.show(
                context,
                title: 'Erro ao Criar Usuário',
                message: failure!.errorMessage,
              );
            }
          }
          // Set Firestore
          else if (failure is SignupFirestoreError) {
            SnackbarError.show(
              context,
              message: failure!.errorMessage,
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

  Future<void> processesCreationUser(BuildContext context) async {
    final userAuth = await _createUserAuthenticationUsecase(
      usuario.email,
      usuario.senha,
    );
    userAuth.fold(
      (error) => failure = error,
      (uid) async {
        usuario = usuario.copyWith(
          docRef: uid,
          logged: true,
          dateCreate: DateTime.now(),
          dateModification: DateTime.now(),
        );
        final setUserFirestore = await _setUserFirestoreUsecase(usuario);
        setUserFirestore.fold(
          (error) => failure = error,
          (_) async {
            await _accessBootStore.updateFolderUserID(usuario.docRef);
            await _expireToken.generaterToken(usuario.toInfoUser());

            _appCore.setUsuario(usuario);
            Modular.to.navigate('/dashboard/mod-notes/');
          },
        );
      },
    );
  }
}
