import 'first_boot_store.dart';
import 'theme_store.dart';

class SettingStore {
  final ThemeStore _themeStore;
  final FirstBootStore _firstBootStore;

  ThemeStore get theme => _themeStore;

  SettingStore(this._themeStore, this._firstBootStore) {
    _themeStore.loadTheme();
    _firstBootStore.loadFirstBoot();
  }
}
