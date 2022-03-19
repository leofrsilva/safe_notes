import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/button/custom_button_inline.dart';

import '../../../../../design/widgets/widgets.dart';

class GetInPage extends StatefulWidget {
  const GetInPage({Key? key}) : super(key: key);

  @override
  State<GetInPage> createState() => _GetInPageState();
}

class _GetInPageState extends State<GetInPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: Sizes.height(context) * 0.3,
                width: Sizes.width(context),
                child: Stack(
                  children: [
                    WaveLeft(fractionHeight: 0.3 + 0.4),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: TextTitle(
                        text: 'Login',
                        color: ColorPalettes.whiteSemiTransparent,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: Sizes.height(context) * 0.45,
                alignment: AlignmentDirectional.center,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      title: 'E-mail',
                    ),
                    SizedBox(height: Sizes.height(context) * 0.025),
                    CustomTextField(
                      title: 'Senha',
                      isPass: true,
                    ),
                  ],
                ),
              ),
              Container(
                height: Sizes.height(context) * 0.25,
                alignment: AlignmentDirectional.center,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      text: 'Entrar',
                      onTap: () {},
                    ),
                    SizedBox(height: Sizes.height(context) * 0.05),
                    Column(
                      children: [
                        Text(
                          'Não tem uma conta?',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'JosefinSans',
                            color: ColorPalettes.greyDark,
                          ),
                        ),
                        CustomButtonInline(
                          text: 'Adicionar Conta',
                          onTap: () {
                            Modular.to.navigate('/auth/register/');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
