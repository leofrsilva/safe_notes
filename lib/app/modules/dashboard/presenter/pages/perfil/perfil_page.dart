import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/app_core.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/modules/setting/presenter/controllers/setting_controller.dart';
import 'package:safe_notes/app/modules/setting/presenter/controllers/theme_store.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';
import 'package:safe_notes/app/shared/error/failure.dart';

import '../../widgets/input_mode_dark.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late AppCore _appCore;
  late SettingStore _settingStore;
  late UsuarioModel? _usuarioModel;

  @override
  void initState() {
    super.initState();
    _appCore = Modular.get<AppCore>();
    _usuarioModel = _appCore.getUsuario()!;
    _settingStore = Modular.get<SettingStore>();
  }

  @override
  Widget build(BuildContext context) {
    if (_usuarioModel != null) {
      final background = Theme.of(context).backgroundColor;
      return Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: background,
          title: Text(
            'Perfil',
            style: TextStyle(
              fontFamily: 'JosefinSans',
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => Modular.to.pop(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListTile(title: Text(_usuarioModel!.name)),
              ListTile(title: Text(_usuarioModel!.email)),
              ScopedBuilder<ThemeStore, Failure, bool>.transition(
                store: _settingStore.theme,
                onState: (context, dark) {
                  return InputModeDark(
                    isDark: dark,
                    onTap: (bool value) {
                      _settingStore.theme.changeTheme(value);
                    },
                  );
                },
                onError: (_, failure) {
                  return Center(
                    child: Text(
                      'Error ao acessar as Configurações!',
                      style: TextStyle(
                        fontFamily: 'JosefinSans',
                        color: ColorPalettes.redLight,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}
