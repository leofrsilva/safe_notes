import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';

import 'modules/setting/controllers/theme_store.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  late ThemeStore themeStore;

  @override
  void initState() {
    super.initState();
    themeStore = Modular.get<ThemeStore>();
    themeStore.loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Modular.get<ThemeStore>().brightnessDark,
      builder: (context, isDark, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Safe Notes',
          theme: isDark ? Themes.darkTheme : Themes.lightTheme,
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR')],
          routeInformationParser: Modular.routeInformationParser,
          routerDelegate: Modular.routerDelegate,
        );
      },
    );
  }
}
