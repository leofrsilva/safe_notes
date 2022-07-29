import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/encrypt/data_encrypt.dart';

import 'theme_store.dart';

class SettingController {
  final AppCore _appCore;
  final ThemeStore _themeStore;
  final DataEncrypt dataEncrypt;

  ThemeStore get theme => _themeStore;

  UsuarioModel? get user => _appCore.getUsuario();

  SettingController(this._themeStore, this._appCore, this.dataEncrypt) {
    _themeStore.loadTheme();
  }
}
