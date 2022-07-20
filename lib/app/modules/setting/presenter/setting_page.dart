import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../controllers/setting_controller.dart';
import '../controllers/theme_store.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late SettingController _controller;

  Future _getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<SettingController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 26),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      body: Column(
        children: [
          ScopedBuilder<ThemeStore, Failure, bool>.transition(
            store: _controller.theme,
            onLoading: (context) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
            onState: (context, isDark) {
              return SwitchListTile(
                title: const Text('Modo Dark'),
                value: isDark,
                onChanged: (value) {
                  _controller.theme.changeTheme(value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
