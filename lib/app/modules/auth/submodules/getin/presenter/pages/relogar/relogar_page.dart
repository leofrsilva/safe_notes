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

  portrait(
    BuildContext context, {
    required double padding,
    required double heightButton,
    required double heightFields,
    required double heightHead,
  }) {
    return Padding(
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
              header(context, heightHead),
              fields(context, heightFields),
              buttons(context, heightButton, padding),
            ],
          ),
        ),
      ),
    );
  }

  landscape(
    BuildContext context, {
    required double padding,
    required double heightButton,
    required double heightFields,
    required double heightHead,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizes.heightStatusBar(context),
      ),
      child: Form(
        key: _controller.formKey,
        child: SingleChildScrollView(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Sizes.height(context) - Sizes.heightStatusBar(context),
                width: Sizes.width(context) * 0.4,
                child: header(context, heightHead),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: Sizes.height(context) - Sizes.heightStatusBar(context),
                width: Sizes.width(context) * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    fields(context, heightFields),
                    buttons(context, heightButton, padding),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorPalettes.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    late Widget form;
    late double heightHead;
    late double heightFields;
    late double heightButton;
    late double padding;
    if (Sizes.orientation(context) == Orientation.portrait) {
      padding = 0.0;
      heightButton = Sizes.height(context) * 0.20;
      heightFields = Sizes.height(context) * 0.35;
      heightHead =
          Sizes.height(context) * 0.45 - Sizes.heightStatusBar(context);
      form = portrait(
        context,
        padding: padding,
        heightButton: heightButton,
        heightFields: heightFields,
        heightHead: heightHead,
      );
    } else {
      padding = 18.0;
      heightButton =
          (Sizes.height(context) - Sizes.heightStatusBar(context)) * 0.30;
      heightFields =
          (Sizes.height(context) - Sizes.heightStatusBar(context)) * 0.70;
      heightHead = Sizes.height(context) - Sizes.heightStatusBar(context);
      form = landscape(
        context,
        padding: padding,
        heightButton: heightButton,
        heightFields: heightFields,
        heightHead: heightHead,
      );
    }

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
            form,
          ],
        ),
      ),
    );
  }

  header(BuildContext context, double height) {
    return SizedBox(
      height: height,
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

  fields(BuildContext context, double height) {
    return Container(
      height: height,
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

  buttons(
    BuildContext context,
    double height,
    double padding,
  ) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: padding),
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
