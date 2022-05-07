import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import 'adicionar_user_store.dart';

class AddInfoAccessPage extends StatelessWidget {
  final AdicionarUserController _controller;
  const AddInfoAccessPage(
    this._controller, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKeyToInfoAccess,
      child: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Sizes.height(context) * 0.01),
              CustomTextField(
                title: 'E-mail',
                isEmail: true,
                nextFocus: true,
                controller: _controller.textControllerEmail,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    UsuarioModel.qtdCharactersEmail,
                  )
                ],
                validator: (String? email) {
                  if (email == null || email.isEmpty) {
                    return 'O Email é obrigatória!';
                  }
                  if (Validation.ofEmail(email.trim()) == false) {
                    return 'Email Inválido!';
                  }
                  return _controller.checkEmailErrorMessage;
                },
                onSaved: (String? val) {
                  _controller.usuario = _controller.usuario.copyWith(
                    email: val?.trim() ?? '',
                  );
                },
              ),
              SizedBox(height: Sizes.height(context) * 0.025),
              CustomTextField(
                title: 'Senha',
                isPass: true,
                nextFocus: true,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    UsuarioModel.qtdCharactersSenha,
                  )
                ],
                onChanged: (String? text) {
                  _controller.digitsPass = text?.trim() ?? '';
                },
                validator: (String? senha) {
                  if (senha == null || senha.isEmpty) {
                    return 'O Senha é obrigatória!';
                  }
                  if (senha.length < 6) {
                    return 'A Senha deve conter no minimo 4 caracteres!';
                  }
                  return null;
                },
              ),
              SizedBox(height: Sizes.height(context) * 0.025),
              CustomTextField(
                title: 'Confirmar Senha',
                isPass: true,
                autovalidateMode: AutovalidateMode.always,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    UsuarioModel.qtdCharactersSenha,
                  ),
                ],
                onChanged: (String? text) {
                  _controller.digitsConfPass = text?.trim() ?? '';
                },
                validator: (String? confSenha) {
                  if (_controller.digitsPass.isNotEmpty &&
                      _controller.digitsConfPass.isNotEmpty) {
                    if (!_controller.passwordConfirmed) {
                      return 'Confirmação de Senha não confere. Digite Novamente';
                    }
                  }
                  return null;
                },
                onSaved: (String? val) {
                  _controller.usuario = _controller.usuario.copyWith(
                    senha: val?.trim() ?? '',
                  );
                },
              ),
              SizedBox(height: Sizes.height(context) * 0.075),
              CustomButton(
                text: 'Registrar',
                onTap: () => _controller.savedInfoAccess(context),
              ),
              SizedBox(height: Sizes.height(context) * 0.025),
              CustomButtonOutline(
                text: 'Voltar',
                isInvertAnimation: true,
                onTap: () => _controller.backForInfUser(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
