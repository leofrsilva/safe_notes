import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/glow_behavior/no_glow_behavior.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';

import 'adicionar_user_store.dart';
import 'add_info_access_page.dart';
import 'add_info_user_page.dart';

class AdicionarUserPage extends StatefulWidget {
  const AdicionarUserPage({Key? key}) : super(key: key);

  @override
  State<AdicionarUserPage> createState() => _AdicionarUserPageState();
}

class _AdicionarUserPageState extends State<AdicionarUserPage> {
  final _controller = Modular.get<AdicionarUserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (FocusScope.of(context).focusedChild != null) {
            FocusScope.of(context).focusedChild?.unfocus();
          }
        },
        child: Column(
          children: [
            ValueListenableBuilder<int>(
              valueListenable: _controller.currentPage,
              builder: (context, value, child) {
                String title = '';
                if (value == 0) {
                  title = 'Informações Pessoais';
                } else if (value == 1) {
                  title = 'Dados de Acesso';
                }

                return BarStatus(
                  titleChild: TextTitle(
                    text: title,
                    color: ColorPalettes.whiteSemiTransparent,
                  ),
                  onTapIconButtonPrevius: () {
                    if (value == 0) {
                      Modular.to.navigate('/auth/getin/');
                    } else if (value == 1) {
                      _controller.backForInfUser();
                    }
                  },
                );
              },
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: NoGlowBehavior(),
                child: PageView(
                  scrollDirection: Axis.vertical,
                  controller: _controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (int page) {
                    _controller.currentPage.value = page;
                  },
                  children: [
                    AddInfoUserPage(_controller),
                    AddInfoAccessPage(_controller),
                  ],
                ),
              ),
            ),
            //
          ],
        ),
      ),
    );
  }
}
