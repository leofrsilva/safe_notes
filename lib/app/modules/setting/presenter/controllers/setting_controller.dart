import 'theme_store.dart';

class SettingStore {
  final ThemeStore _themeStore;

  ThemeStore get theme => _themeStore;

  SettingStore(this._themeStore) {
    _themeStore.loadTheme();
  }
}
