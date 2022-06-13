import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import '../../../presenter/enum/mode_note_enum.dart';
import '../../../presenter/mixin/template_page_mixin.dart';
import '../../../presenter/widgets/checkbox_all_widget.dart';
import '../../../presenter/widgets/grid_note_widget.dart';
import 'notes_controller.dart';
import '../../../presenter/pages/search/custom_search_delegate.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with TemplatePageMixin {
  late NotesController _controller;

  bool ordeByDesc = true;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<NotesController>();
  }

  @override
  String get title => 'Todas as notas';

  @override
  List<Widget> get actionsIcon {
    return [
      IconButton(
        icon: const Icon(Icons.search_outlined),
        onPressed: () {
          showSearch(
            context: context,
            delegate: CustomSearchDelegate(
              reactiveListNote: super.drawerMenu.shared.reactiveNotes,
              reactiveListFolder: super.drawerMenu.shared.reactiveFolders,
            ),
          );
        },
      ),
      Padding(
        padding: const EdgeInsetsDirectional.only(end: 9.0),
        child: IconButton(
          icon: const Icon(Icons.more_vert_outlined),
          onPressed: () {},
        ),
      ),
    ];
  }

  @override
  PreferredSizeWidget appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(
        super.appBar().preferredSize.height,
      ),
      child: RxBuilder(builder: (context) {
        bool selectable = _controller.selection.selectable.value;
        List<NoteModel> noteSelecteds =
            _controller.selection.selectedNoteItems.value;

        if (selectable) {
          String title = '';
          if (noteSelecteds.isEmpty) {
            title = 'Selecionar notas';
          } else {
            title = ' ${noteSelecteds.length} selecionado(s)';
          }
          return AppBar(
            title: Text(title),
            leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: CheckboxAllWidget(
                selected: _controller.selection.checkQuantityNoteSelected(
                  super.drawerMenu.shared.reactiveNotes.qtdNotes,
                ),
                onChanged: (value) {
                  value = value ?? false;
                  if (value) {
                    _controller.selection.addAllItemNoteToSelection(
                      super.drawerMenu.shared.reactiveNotes.listAllNote(),
                    );
                  } else {
                    _controller.selection.clearNotes();
                  }
                },
                onTap: () {
                  var value = _controller.selection.checkQuantityNoteSelected(
                    super.drawerMenu.shared.reactiveNotes.qtdNotes,
                  );
                  if (value) {
                    _controller.selection.addAllItemNoteToSelection(
                      super.drawerMenu.shared.reactiveNotes.listAllNote(),
                    );
                  } else {
                    _controller.selection.clearNotes();
                  }
                },
              ),
            ),
          );
        }
        return super.appBar();
      }),
    );
  }

  @override
  Widget get body => RxBuilder(
        builder: (context) {
          bool selectable = _controller.selection.selectable.value;
          List<NoteModel> noteSelecteds =
              _controller.selection.selectedNoteItems.value;

          return WillPopScope(
            onWillPop: () async {
              if (selectable) {
                _controller.selection.toggleSelectable(false);
                _controller.selection.clearNotes();
                super.enableFloatingButtonAdd();
                return false;
              }
              return true;
            },
            child: Padding(
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
                        return Container(
                          constraints: const BoxConstraints.expand(),
                          child: ScrollConfiguration(
                            behavior: NoGlowBehavior(),
                            child: SingleChildScrollView(
                              controller: super.scrollController,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 75.0),
                                child: GridNoteWidget(
                                  selectable: selectable,
                                  selection: _controller.selection,
                                  ordeByDesc: ordeByDesc,
                                  listNotes: listNotes,
                                  noteSelecteds: noteSelecteds,
                                  reactiveFolders:
                                      super.drawerMenu.shared.reactiveFolders,
                                  onPressedOrder: () {
                                    setState(() => ordeByDesc = !ordeByDesc);
                                  },
                                  onLongPressCardFolder: () {
                                    super.disableFloatingButtonAdd();
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  );
                },
              ),
            ),
          );
        },
      );

  @override
  Widget? get bottomNavigationBar {
    return RxBuilder(builder: (context) {
      List<NoteModel> selecteds = _controller.selection.selectedNoteItems.value;

      if (selecteds.isNotEmpty) {
        return Container(
          height: 70.0,
          color: Theme.of(context).backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: CustomButtonIcon(
                  icon: Icons.delete_outline_rounded,
                  text: 'Excluir',
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 8.0,
                  end: 16.0,
                ),
                child: CustomButtonIcon(
                  icon: Icons.more_vert,
                  text: 'Mais',
                  onPressed: () {},
                ),
              ),
            ],
          ),
        );
      }
      return Container(height: 0);
    });
  }

  @override
  Widget get floatingButtonAdd => FloatingActionButton(
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
