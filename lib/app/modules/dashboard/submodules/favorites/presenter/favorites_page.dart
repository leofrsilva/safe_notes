import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../presenter/mixin/template_page_mixin.dart';
import '../../../presenter/pages/drawer/drawer_menu_controller.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with TemplatePageMixin {
  @override
  String get title => 'Favoritos';

  @override
  DrawerMenuController get drawerController =>
      Modular.get<DrawerMenuController>();
}
