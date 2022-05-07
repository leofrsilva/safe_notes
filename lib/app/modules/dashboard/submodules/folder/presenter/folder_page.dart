import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../presenter/mixin/template_page_mixin.dart';
import '../../../presenter/pages/drawer/drawer_menu_controller.dart';
import 'folder_controller.dart';

class FolderPage extends StatefulWidget {
  final int folderId;

  const FolderPage({
    Key? key,
    required this.folderId,
  }) : super(key: key);

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> with TemplatePageMixin {
  late FolderController _controller;

  @override
  String get title => 'Pastas';

  @override
  DrawerMenuController get drawerController =>
      Modular.get<DrawerMenuController>();

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<FolderController>();
  }
}
