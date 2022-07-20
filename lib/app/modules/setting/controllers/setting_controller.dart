import 'theme_store.dart';

class SettingController {
  final ThemeStore _themeStore;

  ThemeStore get theme => _themeStore;

  SettingController(this._themeStore) {
    _themeStore.loadTheme();
  }
}
