import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import '../../presenter/enum/mode_note_enum.dart';
import '../../presenter/mixin/template_page_mixin.dart';
import '../../presenter/widgets/checkbox_all_widget.dart';
import '../../presenter/widgets/confirm_deletion_widget.dart';
import '../../presenter/widgets/grid_note_widget.dart';
import '../../presenter/widgets/popup_more_button_widget.dart';
import '../../presenter/pages/search/custom_search_delegate.dart';
import 'notes_controller.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with TemplatePageMixin {
  late NotesController _controller;

  bool ordeByDesc = true;

  _exitModeSelection() {
    _controller.selection.toggleSelectable(false);
    _controller.selection.clearNotes();
    super.enableFloatingButtonAdd();
  }

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
              reactiveList: super.drawerMenu.listFieldsStore.reactive,
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
                  super.drawerMenu.listFieldsStore.reactive.qtdNotes,
                ),
                onChanged: (value) {
                  value = value ?? false;
                  if (value) {
                    _controller.selection.addAllItemNoteToSelection(
                      super.drawerMenu.listFieldsStore.reactive.listAllNote(),
                    );
                  } else {
                    _controller.selection.clearNotes();
                  }
                },
                onTap: () {
                  var value = _controller.selection.checkQuantityNoteSelected(
                    super.drawerMenu.listFieldsStore.reactive.qtdNotes,
                  );
                  if (value) {
                    _controller.selection.addAllItemNoteToSelection(
                      super.drawerMenu.listFieldsStore.reactive.listAllNote(),
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
                _exitModeSelection();
                return false;
              }
              return true;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: AnimatedBuilder(
                animation: super.drawerMenu.listFieldsStore.reactive,
                builder: (context, child) {
                  var listNotes = super
                      .drawerMenu
                      .listFieldsStore
                      .reactive
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
                              onPressedOrder: () {
                                setState(() => ordeByDesc = !ordeByDesc);
                              },
                              onLongPressCardFolder: () {
                                super.disableFloatingButtonAdd();
                              },
                              onTap: (note) {
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
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
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
      List<NoteModel> noteSelecteds =
          _controller.selection.selectedNoteItems.value;

      if (selecteds.isNotEmpty) {
        _controller.changeTitleFavorite(noteSelecteds);

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
                  onPressed: () {
                    String title = 'Mover ${noteSelecteds.length} ';
                    if (noteSelecteds.length > 1) {
                      title += 'notas para a lixeira';
                    } else {
                      title += 'nota para a lixeira';
                    }
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierColor: Colors.black26,
                      builder: (context) {
                        return ConfirmDeletionWidget(
                          title: title,
                          onConfirmation: () {
                            _controller.deleteNote(context, noteSelecteds);
                            _exitModeSelection();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 8.0,
                  end: 16.0,
                ),
                child: PopupMoreButtonWidget(
                  noteSelecteds: noteSelecteds,
                  listMoreButton: _controller.moreButton,
                  onSelected: (String result) {
                    if (result == _controller.moreButton.first) {
                      _controller.editFavorite(context, noteSelecteds);
                      _exitModeSelection();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox(height: 0.0);
    });
  }

  @override
  Widget get floatingButtonAdd => FloatingActionButton(
        tooltip: 'Adic.',
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
              DefaultDatabase.folderDefault
            ],
          );
        },
      );
}
