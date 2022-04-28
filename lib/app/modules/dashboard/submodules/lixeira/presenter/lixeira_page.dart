import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../presenter/mixin/template_page_mixin.dart';
import '../../../presenter/pages/drawer/drawer_menu_controller.dart';

class LixeiraPage extends StatefulWidget {
  const LixeiraPage({Key? key}) : super(key: key);

  @override
  State<LixeiraPage> createState() => _LixeiraPageState();
}

class _LixeiraPageState extends State<LixeiraPage> with TemplatePageMixin {
  @override
  String get title => 'Lixeira';

  @override
  DrawerMenuController get drawerController =>
      Modular.get<DrawerMenuController>();
}
