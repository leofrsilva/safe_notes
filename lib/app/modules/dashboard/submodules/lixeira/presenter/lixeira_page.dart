import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';

import '../../../presenter/enum/mode_note_enum.dart';
import '../../../presenter/mixin/template_page_mixin.dart';
import '../../../presenter/widgets/checkbox_all_widget.dart';
import '../../../presenter/widgets/confirm_deletion_widget.dart';
import 'lixeira_controller.dart';
import 'widgets/grid_folder_deleted_widget.dart';
import 'widgets/grid_note_deleted_widget.dart';

class LixeiraPage extends StatefulWidget {
  const LixeiraPage({Key? key}) : super(key: key);

  @override
  State<LixeiraPage> createState() => _LixeiraPageState();
}

class _LixeiraPageState extends State<LixeiraPage>
    with TemplatePageMixin, WidgetsBindingObserver {
  late LixeiraController _controller;

  _exitModeSelection() {
    _controller.selection.toggleSelectable(false);
    _controller.selection.clearFolder();
    _controller.selection.clearNotes();
    super.enableFloatingButtonAdd();
  }

  @override
  String get title => 'Lixeira';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<LixeiraController>();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  List<Widget> get actionsIcon => [
        if (super
                .drawerMenu
                .listFieldsStore
                .reactive
                .listFolderDeleted
                .isNotEmpty &&
            super
                .drawerMenu
                .listFieldsStore
                .reactive
                .listNoteDeleted
                .isNotEmpty)
          TextButton(
            child: const Text(
              'Editar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              _controller.selection.toggleSelectable(true);
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
        List<FolderModel> folderSelecteds =
            _controller.selection.selectedFolderItems.value;

        // Reactive
        var reactive = super.drawerMenu.listFieldsStore.reactive;
        //
        final foldersDeleted = reactive.listFolderDeleted;
        final notesDeleted = reactive.listNoteDeleted;

        bool selectedAllNotes = _controller.selection
            .checkQuantityNoteSelected(notesDeleted.length);
        bool selectedAllFolders = _controller.selection
            .checkQuantityFolderSelected(foldersDeleted.length);
        bool selectedAll = selectedAllNotes && selectedAllFolders;

        if (selectable) {
          String title = '';
          if (noteSelecteds.isEmpty && folderSelecteds.isEmpty) {
            title = 'Selecionar notas';
          } else {
            var qtd = noteSelecteds.length + folderSelecteds.length;
            title = ' $qtd selecionado(s)';
          }
          return AppBar(
            title: Text(title),
            leading: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: CheckboxAllWidget(
                selected: selectedAll,
                onChanged: (value) {
                  value = value ?? false;
                  if (value) {
                    _controller.selection
                        .addAllItemNoteToSelection(notesDeleted);
                    _controller.selection
                        .addAllItemFolderToSelection(foldersDeleted);
                  } else {
                    _controller.selection.clearNotes();
                    _controller.selection.clearFolder();
                  }
                },
                onTap: () {
                  var checkNotes = _controller.selection
                      .checkQuantityNoteSelected(notesDeleted.length);
                  var checkFolders = _controller.selection
                      .checkQuantityFolderSelected(foldersDeleted.length);
                  if (checkNotes && checkFolders) {
                    _controller.selection
                        .addAllItemNoteToSelection(notesDeleted);
                    _controller.selection
                        .addAllItemFolderToSelection(foldersDeleted);
                  } else {
                    _controller.selection.clearNotes();
                    _controller.selection.clearFolder();
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
  Widget get body {
    return RxBuilder(builder: (context) {
      bool selectable = _controller.selection.selectable.value;
      List<FolderModel> folderSelecteds =
          _controller.selection.selectedFolderItems.value;
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
          padding: const EdgeInsets.all(14.0),
          child: AnimatedBuilder(
              animation: super.drawerMenu.listFieldsStore.reactive,
              builder: (context, child) {
                final reactive = super.drawerMenu.listFieldsStore.reactive;
                final foldersDeleted = reactive.listFolderDeleted;
                final notesDeleted = reactive.listNoteDeleted;

                if (foldersDeleted.isEmpty && notesDeleted.isEmpty) {
                  return Center(
                    child: SizedBox(
                      width: Sizes.width(context) * 0.65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Nenhum item',
                            style: TextStyle(
                              color: ColorPalettes.blueGrey,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Qualquer item na Lixeira será excluído permanentemente após 30 dias.',
                            maxLines: 2,
                            style: TextStyle(
                              color: ColorPalettes.grey,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ScrollConfiguration(
                  behavior: NoGlowBehavior(),
                  child: SingleChildScrollView(
                    controller: super.scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Os itens exibem os dias que restam para eles serem excluídos para sempre.',
                            style: TextStyle(
                              color: ColorPalettes.blueGrey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        //?
                        //? FOLDERS
                        Padding(
                          padding: EdgeInsets.only(
                            top: foldersDeleted.isEmpty ? 0.0 : 15.0,
                          ),
                          child: GridFolderDeletedWidget(
                            selection: _controller.selection,
                            selectable: selectable,
                            reactive: reactive,
                            listFolders: foldersDeleted,
                            folderSelecteds: folderSelecteds,
                            onTap: (_) {
                              SnackbarWarning.show(
                                context,
                                duration: const Duration(seconds: 2),
                                message: 'Restaure esta pasta para abri-la.',
                              );
                            },
                            onLongPressCardFolder: () {
                              super.disableFloatingButtonAdd();
                            },
                          ),
                        ),
                        //?
                        //? NOTES
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 15.0,
                            bottom: 75.0,
                          ),
                          child: GridNoteDeletedWidget(
                            selectable: selectable,
                            selection: _controller.selection,
                            haveOrdenation: false,
                            ordeByDesc: true,
                            listNotes: notesDeleted,
                            noteSelecteds: noteSelecteds,
                            onLongPressCardFolder: () {
                              super.disableFloatingButtonAdd();
                            },
                            onTap: (note) {
                              Modular.to.pushNamed(
                                '/dashboard/add-or-edit-note/deleted',
                                arguments: [
                                  ModeNoteEnum.preview,
                                  note,
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      );
    });
  }

  @override
  Widget? get bottomNavigationBar {
    return RxBuilder(builder: (context) {
      List<NoteModel> noteSelecteds =
          _controller.selection.selectedNoteItems.value;
      List<FolderModel> folderSelecteds =
          _controller.selection.selectedFolderItems.value;

      if (noteSelecteds.isNotEmpty || folderSelecteds.isNotEmpty) {
        return Container(
          height: 70.0,
          color: Theme.of(context).backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomButtonIcon(
                icon: Icons.replay_rounded,
                text: 'Restaurar',
                onPressed: () async {
                  _exitModeSelection();

                  await _controller.restore(
                    context,
                    noteSelecteds,
                    folderSelecteds,
                  );
                  SnackbarWarning.show(
                    context,
                    message: 'Os itens foram restaurados.',
                  );
                },
              ),
              CustomButtonIcon(
                icon: Icons.delete_outline_rounded,
                text: 'Excluir',
                onPressed: () {
                  String title = _controller.questionTitleDelete(
                    folderSelecteds,
                    noteSelecteds,
                  );

                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierColor: Colors.black26,
                    builder: (context) {
                      return ConfirmDeletionWidget(
                        title: title,
                        onConfirmation: () {
                          _exitModeSelection();

                          _controller.delete(
                            context,
                            noteSelecteds,
                            folderSelecteds,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      }
      return const SizedBox(height: 0.0);
    });
  }
}
