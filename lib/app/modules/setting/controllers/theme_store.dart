import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/shared/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStore extends StreamStore<Failure, bool> {
  final String _theme = 'theme';

  ThemeStore() : super(false) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    setLoading(true);
    final isDark = await getValueDarkTheme();
    update(isDark, force: true);
    setLoading(false);
  }

  Future<void> changeTheme(bool isDark) async {
    setLoading(true);
    await saveValueDarkTheme(isDark: isDark);
    update(isDark, force: true);
    setLoading(false);
  }

  Future saveValueDarkTheme({bool isDark = false}) async {
    var shared = await SharedPreferences.getInstance();
    shared.setBool(_theme, isDark);
  }

  Future<bool> getValueDarkTheme() async {
    var shared = await SharedPreferences.getInstance();
    return shared.getBool(_theme) ?? false;
  }
}
