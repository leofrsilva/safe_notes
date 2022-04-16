import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/shared/token/i_expire_token.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';

class SplashStore {
  final IExpireToken _expireToken;
  final FirebaseAuth _firebaseAuth;
  // final ILogoutUserSqliteUsecase _logoutUserSqliteUsecase;
  // final IGetUsersLoggedSqliteUsecase _getUsersLoggedSqliteUsecase;

  SplashStore(
    this._expireToken,
    this._firebaseAuth,
    // this._logoutUserSqliteUsecase,
    // this._getUsersLoggedSqliteUsecase,
  );

  Future<void> checkLoggedInUser(BuildContext context) async {
    Map<String, dynamic>? infoUsers = await _expireToken.checkToken();
    Modular.to.navigate('/auth/getin/');
    // if (checkToken) {
    // getUser(context);
    // } else {
    print('-- LOGOUT --');
    // logout(context);
    // }
  }

  // Future getUser(BuildContext context) async {
  //   final userShared = Modular.get<UserSharedController>();

  //   final either = await _getUsersLoggedSqliteUsecase();
  //   either.fold(
  //     (failure) async {
  //       SnackbarError.show(
  //         context,
  //         message: 'Erro ao tentar obter dados do Usuário Logado!',
  //         duration: const Duration(milliseconds: 1000),
  //       );
  //       await Future.delayed(
  //         const Duration(milliseconds: 1000),
  //         () => Modular.to.navigate('/dashboard/'),
  //       );
  //     },
  //     (listUser) {
  //       if (listUser.isNotEmpty) {
  //         userShared.setFromEntity = listUser.first;
  //         Modular.to.navigate('/dashboard/');
  //       } else {
  //         Modular.to.navigate('/auth/getin/');
  //       }
  //     },
  //   );
  // }

  // Future logout(BuildContext context) async {
  //   final userShared = Modular.get<UserSharedController>();

  //   final either = await _logoutUserSqliteUsecase();
  //   either.fold(
  //     (failure) async {
  //       SnackbarError.show(
  //         context,
  //         message: 'Erro ao tentar fazer o Logout!',
  //         duration: const Duration(milliseconds: 1000),
  //       );
  //       await Future.delayed(
  //         const Duration(milliseconds: 1000),
  //         () => Modular.to.navigate('/auth/accounts/'),
  //       );
  //     },
  //     (_) async {
  //       userShared.removeUsuario();
  //       await _firebaseAuth.signOut();
  //       await _expireToken.removeToken();
  //       Modular.to.navigate('/auth/accounts/');
  //     },
  //   );
  // }
}
