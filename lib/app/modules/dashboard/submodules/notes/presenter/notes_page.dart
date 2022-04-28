import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../presenter/mixin/template_page_mixin.dart';
import '../../../presenter/pages/drawer/drawer_menu_controller.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with TemplatePageMixin {
  @override
  String get title => 'Todas as notas';

  @override
  DrawerMenuController get drawerController =>
      Modular.get<DrawerMenuController>();
}
