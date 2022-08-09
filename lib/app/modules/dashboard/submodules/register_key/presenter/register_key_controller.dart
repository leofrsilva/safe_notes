import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/design/widgets/loading/loading_overlay.dart';
import 'package:safe_notes/app/design/widgets/snackbar/snackbar_error.dart';
import 'package:safe_notes/app/shared/encrypt/data_encrypt.dart';

import '../domain/usecases/save_key_usecase.dart';

class RegisterKeyController {
  final AppCore _appCore;
  final DataEncrypt _dataEncrypt;
  final ISaveKeyUsecase _saveKeyUsecase;
  RegisterKeyController(this._appCore, this._dataEncrypt, this._saveKeyUsecase);

  sendKey(BuildContext context, String keyText) async {
    await _dataEncrypt.setKey(
      keyText,
      onSaveKey: () async {
        final result = await LoadingOverlay.show<String?>(
          context,
          _processSaveKey(context, keyText),
        );
        return result;
      },
    ).whenComplete(() => Modular.to.pop());
  }

  Future<String?> _processSaveKey(BuildContext context, String keyText) async {
    var user = _appCore.getUsuario();
    if (user != null) {
      final either = await _saveKeyUsecase.call(user, keyText);
      String key = '';
      either.fold(
        (failure) {
          SnackbarError.show(
            context,
            message: 'Error ao acessar o Servidor',
          );
        },
        (value) => key = value,
      );
      if (either.isRight()) return key;
    }
    return null;
  }
}
