import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import '../widgets/header_login.dart';
import 'getin_controller.dart';

class GetInPage extends StatefulWidget {
  const GetInPage({Key? key}) : super(key: key);

  @override
  State<GetInPage> createState() => _GetInPageState();
}

class _GetInPageState extends State<GetInPage> {
  final _controller = Modular.get<GetinController>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (FocusScope.of(context).focusedChild != null) {
            FocusScope.of(context).focusedChild?.unfocus();
          }
        },
        child: Form(
          key: _controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const HeaderLogin(),
                form(context),
                buttons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget form(BuildContext context) => Container(
        height: Sizes.height(context) * 0.35,
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              title: 'E-mail',
              isEmail: true,
              nextFocus: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                  UsuarioModel.qtdCharactersEmail,
                ),
              ],
              validator: (String? email) {
                if (email == null || email.isEmpty) {
                  return 'Preencha o campo de Email!';
                }
                if (Validation.ofEmail(email.trim()) == false) {
                  return 'Email Inválido!';
                }
                return null;
              },
              onSaved: (String? val) {
                _controller.emailField = val?.trim() ?? '';
              },
            ),
            SizedBox(height: Sizes.height(context) * 0.025),
            CustomTextField(
              title: 'Senha',
              isPass: true,
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
                _controller.passsField = val?.trim() ?? '';
              },
            ),
            Container(
              padding: const EdgeInsets.only(top: 5.0),
              alignment: AlignmentDirectional.centerEnd,
              child: CustomButtonInline(
                underline: false,
                text: 'Esqueceu a senha?',
                onTap: () {},
              ),
            ),
          ],
        ),
      );

  Widget buttons(BuildContext context) => Container(
        height: Sizes.height(context) * 0.35,
        alignment: AlignmentDirectional.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Entrar',
              onTap: () => _controller.login(context),
            ),
            SizedBox(height: Sizes.height(context) * 0.05),
            Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Text(
                    'Não tem uma conta?',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'JosefinSans',
                      color: ColorPalettes.greyDark,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 6.0),
                  alignment: AlignmentDirectional.bottomCenter,
                  child: CustomButtonInline(
                    text: 'Adicionar Conta',
                    onTap: () => Modular.to.navigate('/auth/register/'),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
