import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/design/common/common.dart';

import 'modules/setting/presenter/controllers/theme_store.dart';
import 'shared/error/failure.dart';

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
    return ScopedBuilder<ThemeStore, Failure, bool>.transition(
      store: themeStore,
      onLoading: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
        ),
      ),
      onState: (context, dark) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Safe Notes',
          theme: dark ? Themes.darkTheme : Themes.lightTheme,
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
