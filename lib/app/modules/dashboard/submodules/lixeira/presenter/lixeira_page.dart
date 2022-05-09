import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/glow_behavior/no_glow_behavior.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';

import '../../../presenter/mixin/template_page_mixin.dart';
import '../../../presenter/pages/drawer/drawer_menu_controller.dart';
import 'lixeira_controller.dart';

class LixeiraPage extends StatefulWidget {
  const LixeiraPage({Key? key}) : super(key: key);

  @override
  State<LixeiraPage> createState() => _LixeiraPageState();
}

class _LixeiraPageState extends State<LixeiraPage> with TemplatePageMixin {
  late LixeiraController _controller;

  @override
  String get title => 'Lixeira';

  @override
  DrawerMenuController get drawerController =>
      Modular.get<DrawerMenuController>();

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<LixeiraController>();
  }

  @override
  Widget get body {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ScrollConfiguration(
          behavior: NoGlowBehavior(),
          child: ListView(
            children: [
              Wrap(
                alignment: WrapAlignment.start,
                children: super
                    .drawerController!
                    .reactiveListFolder
                    .listDeleted
                    .map((folder) {
                  return CardFolder(
                    qtd: folder.qtd,
                    title: folder.name,
                    background: ColorPalettes.grey,
                  );
                }).toList(),
              ),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}
