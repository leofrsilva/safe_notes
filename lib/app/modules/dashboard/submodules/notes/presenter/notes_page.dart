import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import '../../../presenter/mixin/template_page_mixin.dart';
import '../../../presenter/pages/drawer/drawer_menu_controller.dart';
import '../../add_or_edit_note/presenter/enum/mode_note_enum.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with TemplatePageMixin {
  bool ordeByDesc = true;

  @override
  String get title => 'Todas as notas';

  @override
  DrawerMenuController get drawerMenu => Modular.get<DrawerMenuController>();

  @override
  Widget get body => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: ScopedBuilder.transition(
          store: super.drawerMenu.shared.listFoldersStore,
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
              animation: super.drawerMenu.shared.reactiveNotes,
              builder: (context, child) {
                var listNotes = super
                    .drawerMenu
                    .shared
                    .reactiveNotes
                    .listAllNote(orderByDesc: ordeByDesc);
                if (listNotes.isNotEmpty) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.align_horizontal_left_rounded,
                              color: ColorPalettes.grey,
                              size: 15,
                            ),
                            const SizedBox(width: 1.0),
                            Text(
                              'Data de Modificação |',
                              style: TextStyle(
                                color: ColorPalettes.grey,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: Icon(
                                ordeByDesc
                                    ? Icons.arrow_downward_outlined
                                    : Icons.arrow_upward_outlined,
                                color: ColorPalettes.grey,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(() => ordeByDesc = !ordeByDesc);
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            children: listNotes.map((note) {
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
                                          .shared
                                          .reactiveFolders
                                          .getFolder(note.folderId),
                                    ],
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Container();
              },
            );
          },
        ),
      );

  @override
  Widget? get floatingActionButton => FloatingActionButton(
        child: const Icon(
          Icons.note_add_outlined,
          size: 30,
        ),
        onPressed: () {
          Modular.to.pushNamed(
            '/dashboard/add-or-edit-note/',
            arguments: [
              ModeNoteEnum.add,
              NoteModel.empty(),
              DefaultDatabase.folderQtdChildViewDefault,
            ],
          );
        },
      );
}
