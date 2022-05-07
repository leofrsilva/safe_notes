import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../../widgets/header_relogar.dart';
import 'relogar_controller.dart';

class RelogarPage extends StatefulWidget {
  const RelogarPage({Key? key}) : super(key: key);

  @override
  State<RelogarPage> createState() => _RelogarPageState();
}

class _RelogarPageState extends State<RelogarPage> {
  late RelogarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<RelogarController>();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorPalettes.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (FocusScope.of(context).focusedChild != null) {
            FocusScope.of(context).focusedChild?.unfocus();
          }
        },
        child: Stack(
          children: [
            Container(
              width: Sizes.width(context),
              height: Sizes.heightStatusBar(context),
              color: Theme.of(context).backgroundColor,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: Sizes.heightStatusBar(context),
              ),
              child: Form(
                key: _controller.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      header(context),
                      fields(context),
                      buttons(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  header(BuildContext context) {
    return SizedBox(
      height: Sizes.height(context) * 0.45 - Sizes.heightStatusBar(context),
      child: Column(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: _controller.name,
            builder: (context, value, child) {
              return HeaderRelogar(
                name: value,
                onPressedIcon: () {
                  _controller.closeRelogar(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  fields(BuildContext context) {
    return Container(
      height: Sizes.height(context) * 0.35,
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder<String>(
            valueListenable: _controller.email,
            builder: (context, value, child) {
              return CustomTextFieldReadOnly(
                title: 'E-mail',
                initialField: value,
              );
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            title: 'Senha',
            isPass: true,
            spacingWhenInFocus: true,
            inputFormatters: [
              LengthLimitingTextInputFormatter(
                UsuarioModel.qtdCharactersSenha,
              ),
            ],
            validator: (String? senha) {
              if (senha == null || senha.isEmpty) {
                return 'Preencha o campo da Senha!';
              }
              if (senha.trim().length < 6) {
                return 'A Senha Incorreta!';
              }
              return null;
            },
            onSaved: (String? val) {
              _controller.pass = val?.trim() ?? '';
            },
          ),
        ],
      ),
    );
  }

  buttons(BuildContext context) {
    return Container(
      height: Sizes.height(context) * 0.20,
      alignment: AlignmentDirectional.center,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            text: 'Entrar',
            onTap: () => _controller.login(context),
          ),
        ],
      ),
    );
  }
}
