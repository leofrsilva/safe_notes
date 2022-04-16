import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fpdart/fpdart.dart';
import 'package:safe_notes/app/design/widgets/loading/loading_overlay.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../domain/errors/signup_failures.dart';
import '../../domain/usecases/i_signup_firebase_usecase.dart';

class AdicionarUserController {
  final ICreateUserAuthenticationUsecase createUserAuthenticationUsecase;
  final ISetUserFirestoreUsecase setUserFirestoreUsecase;
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
    this.createUserAuthenticationUsecase,
    this.setUserFirestoreUsecase,
  ) {
    pageController = PageController(initialPage: 0);
    currentPage = ValueNotifier<int>(0);

    formKeyToInfoUser = GlobalKey<FormState>();
    formKeyToInfoAccess = GlobalKey<FormState>();
    textControllerName = TextEditingController();
    textControllerEmail = TextEditingController();
    textControllerDate = TextEditingController();
  }

  Future<String?> validatorEmail(String email) async {
    // final checkEmailExisting = await checkEmailExistingUserUsecase(email);
    // if (checkEmailExisting.isLeft()) {
    //   final failure = checkEmailExisting.fold(id, id) as Failure;
    //   if (failure is EmailExistingUserError) {
    //     return 'O Email já Existente!';
    //   } else if (failure is CheckEmailExistingUserSqliteError) {
    //     return 'O erro na checagem da existencia do Email!';
    //   }
    // }
    return null;
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
    checkEmailErrorMessage = await validatorEmail(
      textControllerEmail.text,
    );

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
            SnackbarError.show(
              context,
              title: 'Erro ao Criar Usuário',
              message: failure!.errorMessage,
            );
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
    final userAuth = await createUserAuthenticationUsecase(
      usuario.email,
      usuario.senha,
    );
    userAuth.fold(
      (error) => failure = error,
      (uid) async {
        usuario = usuario.copyWith(docRef: uid, logged: true);
        // final createUser = await createUserUsecase.call(usuario);
        // createUser.fold(
        //   (error) => failure = error,
        //   (usuarioEntity) async {
        //     final setUserFirestore =
        //         await setUserFirestoreUsecase(usuarioEntity);
        //     setUserFirestore.fold(
        //       (error) => failure = error,
        //       (_) {
        //         final userShared = Modular.get<UserSharedController>();
        //         userShared.setModel =
        //             UsuarioModel.fromEntity(usuarioEntity).toDBUser();
        //         Modular.to.navigate('/dashboard/');
        //       },
        //     );
        //   },
        // );
      },
    );
  }
}
