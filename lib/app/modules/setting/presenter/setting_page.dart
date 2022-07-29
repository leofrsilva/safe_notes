import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/shared/errors/failure.dart';

import '../controllers/setting_controller.dart';
import '../controllers/theme_store.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late SettingController _controller;

  Future<String> _getVersion() async {
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
        actions: [
          FutureBuilder<String>(
            future: _getVersion(),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Text(
                    'v' + (snapshot.data ?? ''),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ));
              }
              return Container();
            }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                _controller.user?.name ?? '',
                style: TextStyle(
                  color: ColorPalettes.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                _controller.user?.email ?? '',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: Divider(
                thickness: 1.0,
                color: ColorPalettes.blueGrey50,
              ),
            ),
            ScopedBuilder<ThemeStore, Failure, bool>.transition(
              store: _controller.theme,
              onLoading: (context) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              },
              onState: (context, isDark) {
                return SwitchListTile(
                  title: Text(
                    'Modo Dark',
                    style: TextStyle(
                      color: ColorPalettes.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  value: isDark,
                  onChanged: (value) {
                    _controller.theme.changeTheme(value);
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: Divider(
                thickness: 1.0,
                color: ColorPalettes.blueGrey50,
              ),
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: Text(
                'Backup',
                style: TextStyle(
                  color: ColorPalettes.blueGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5.0),
                  ListTile(
                    enabled: _controller.dataEncrypt.isCorrectKey,
                    dense: true,
                    title: Text(
                      'Upload',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _controller.dataEncrypt.isCorrectKey
                            ? ColorPalettes.blueGrey
                            : ColorPalettes.blueGrey50,
                      ),
                    ),
                    subtitle: Text(
                      'Recuperar Backup e adicionar Pastas e Notas',
                      style: _controller.dataEncrypt.isCorrectKey
                          ? null
                          : TextStyle(color: ColorPalettes.grey50),
                    ),
                    onTap: () =>
                        Modular.to.pushNamed('/dashboard/backup/upload'),
                  ),
                  ListTile(
                    enabled: _controller.dataEncrypt.isCorrectKey,
                    dense: true,
                    title: Text(
                      'Download',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _controller.dataEncrypt.isCorrectKey
                            ? ColorPalettes.blueGrey
                            : ColorPalettes.blueGrey50,
                      ),
                    ),
                    subtitle: Text(
                      'Gerar Backup das Pastas e suas Notas',
                      style: _controller.dataEncrypt.isCorrectKey
                          ? null
                          : TextStyle(color: ColorPalettes.grey50),
                    ),
                    onTap: () =>
                        Modular.to.pushNamed('/dashboard/backup/download'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
