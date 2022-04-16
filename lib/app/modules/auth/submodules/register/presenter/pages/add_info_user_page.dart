import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/glow_behavior/no_glow_behavior.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/domain/models/usuario_model.dart';

import 'adicionar_user_store.dart';

class AddInfoUserPage extends StatelessWidget {
  final AdicionarUserController _controller;
  const AddInfoUserPage(
    this._controller, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _controller.formKeyToInfoUser,
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
                title: 'Nome Completo',
                nextFocus: true,
                controller: _controller.textControllerName,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(
                    UsuarioModel.qtdCharactersName,
                  )
                ],
                validator: (String? name) {
                  if (name == null || name.isEmpty) {
                    return 'O Nome é obrigatória!';
                  }
                  if (name.trim().length < 4) {
                    return 'O Nome deve conter mais de 3 caracteres!';
                  }
                  return null;
                },
                onSaved: (String? name) {
                  _controller.usuario = _controller.usuario.copyWith(
                    name: name?.trim() ?? '',
                  );
                },
              ),
              SizedBox(height: Sizes.height(context) * 0.025),
              CustomInputDate(
                title: 'Data de Nacimento',
                spacingWhenInFocus: true,
                controller: _controller.textControllerDate,
                onSaved: (String? date) {
                  if (date != null && date.isNotEmpty) {
                    _controller.usuario = _controller.usuario
                        .copyWith(dateBirth: date.toConvertDateTime);
                  }
                },
              ),
              SizedBox(height: Sizes.height(context) * 0.05),
              CustomRadioButton<String>(
                field: 'Gênero',
                textOption1: 'Feminino',
                option1: 'F',
                textOption2: 'Masculino',
                option2: 'M',
                initialValue: _controller.usuario.genre.isNotEmpty
                    ? _controller.usuario.genre
                    : null,
                validator: (selected) {
                  if (selected == null) {
                    return "É necessário selecionar um Gênero!";
                  }
                  return null;
                },
                onSaved: (String? val) {
                  _controller.usuario =
                      _controller.usuario.copyWith(genre: val);
                },
              ),
              SizedBox(height: Sizes.height(context) * 0.075),
              CustomButton(
                text: 'Avançar',
                onTap: _controller.savedInfoUser,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
