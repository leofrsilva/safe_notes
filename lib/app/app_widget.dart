import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/modules/setting/presenter/setting_store.dart';

import 'shared/error/failure.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedBuilder<SettingStore, Failure, bool>.transition(
      store: SettingStore(), // Instantiating Store
      onLoading: (context) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      onState: (context, dark) {
        return MaterialApp.router(
          routeInformationParser: Modular.routeInformationParser,
          routerDelegate: Modular.routerDelegate,
          debugShowCheckedModeBanner: false,
          title: 'Safe Notes',
          theme: dark ? Themes.darkTheme : Themes.lightTheme,
        );
      },
    );
  }
}
