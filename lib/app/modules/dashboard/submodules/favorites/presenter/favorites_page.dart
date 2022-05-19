import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import '../../../presenter/mixin/template_page_mixin.dart';
import '../../../presenter/pages/drawer/drawer_menu_controller.dart';
import 'favorites_controller.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with TemplatePageMixin {
  late FavoritesController _controller;

  @override
  String get title => 'Favoritos';

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<FavoritesController>();
  }

  @override
  Widget get body {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ValueListenableBuilder<int>(
          valueListenable: super.drawerMenu.shared.reactiveFolders.deleted,
          builder: (context, _, __) {
            final listNotesFavorites =
                super.drawerMenu.shared.reactiveNotes.favorites;

            return ScrollConfiguration(
              behavior: NoGlowBehavior(),
              child: SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  children: listNotesFavorites.map((note) {
                    return CardNote(
                      title: note.title,
                      body: note.body,
                      date: note.dateModification,
                    );
                  }).toList(),
                ),
              ),
            );
          }),
    );
  }
}
