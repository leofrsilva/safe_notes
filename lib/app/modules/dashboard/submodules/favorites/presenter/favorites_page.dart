import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import '../../../presenter/enum/mode_note_enum.dart';
import '../../../presenter/mixin/template_page_mixin.dart';
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
  Widget get body => Padding(
        padding: const EdgeInsets.all(14.0),
        child: ScopedBuilder.transition(
          store: super.drawerMenu.listFieldsStore.listFoldersStore,
          onLoading: (context) => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          onError: (context, _) {
            return const Center(
              child: Text(
                'Erro ao carregar as Notas',
                style: TextStyle(
                  fontFamily: 'JosefinSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          },
          onState: (context, _) {
            return AnimatedBuilder(
              animation: super.drawerMenu.listFieldsStore.reactive,
              builder: (context, child) {
                if (super
                    .drawerMenu
                    .listFieldsStore
                    .reactive
                    .favorites
                    .isNotEmpty) {
                  return SingleChildScrollView(
                    controller: super.scrollController,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: super
                          .drawerMenu
                          .listFieldsStore
                          .reactive
                          .favorites
                          .map((note) {
                        return CardNote(
                          title: note.title,
                          body: note.body,
                          date: note.dateModification,
                          onTap: () {
                            Modular.to.pushNamed(
                              '/dashboard/add-or-edit-note/',
                              arguments: [
                                ModeNoteEnum.edit,
                                note,
                                super
                                    .drawerMenu
                                    .listFieldsStore
                                    .reactive
                                    .getFolder(note.folderId),
                              ],
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                }
                return Container();
              },
            );
          },
        ),
      );
}
