import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';

import 'package:safe_notes/app/shared/token/i_expire_token.dart';

class DashboardController {
  final IExpireToken _expireToken;
  final FirebaseAuth _firebaseAuth;

  DashboardController(
    this._expireToken,
    this._firebaseAuth,
  );

  void logout(BuildContext context) async {
    // userShared.removeUsuario();
    // await _firebaseAuth.signOut();
    // await _expireToken.removeToken();
    // Modular.to.navigate('/auth/getin/');

    final userShared = Modular.get<AppCore>();

    // final either = await _logoutUserSqliteUsecase();
    // either.fold(
    //   (failure) async {
    //     SnackbarError.show(
    //       context,
    //       message: 'Erro ao tentar fazer o Logout!',
    //       duration: const Duration(milliseconds: 1000),
    //     );
    //     await Future.delayed(
    //       const Duration(milliseconds: 1000),
    //       () => Modular.to.navigate('/auth/accounts/'),
    //     );
    //   },
    //   (_) async {
    //     userShared.removeUsuario();
    //     await _firebaseAuth.signOut();
    //     await _expireToken.removeToken();
    //     Modular.to.navigate('/auth/accounts/');
    //   },
    // );
  }
}
