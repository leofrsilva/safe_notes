import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/encrypt/encrypt.dart';

import '../../../presenter/enum/mode_note_enum.dart';
import '../../../presenter/mixin/template_page_mixin.dart';
import '../../../presenter/pages/search/custom_search_delegate.dart';
import '../../../presenter/widgets/checkbox_all_widget.dart';
import '../../../presenter/widgets/confirm_deletion_widget.dart';
import '../../../presenter/widgets/popup_more_button_widget.dart';
import 'folder_controller.dart';
import '../../../presenter/widgets/grid_folder_widget.dart';
import '../../../presenter/widgets/grid_note_widget.dart';
import 'widgets/sequence_folder_widget.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> with TemplatePageMixin {
  bool ordeByDesc = true;

  late FolderController _controller;
  late DataEncrypt _dataEncrypt;

  _exitModeSelection() {
    _controller.selection.toggleSelectable(false);
    _controller.selection.clearFolder();
    _controller.selection.clearNotes();
    super.enableFloatingButtonAdd();
  }

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<FolderController>();
    _dataEncrypt = Modular.get<DataEncrypt>();
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
        List<FolderModel> folderSelecteds =
            _controller.selection.selectedFolderItems.value;

        // Reactive
        var reactive = super.drawerMenu.listFieldsStore.reactive;

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
              child: ValueListenableBuilder<FolderModel>(
                  valueListenable: _controller.folderParent,
                  builder: (context, folder, child) {
                    var listNotes = reactive.listNoteByFolder(folder.folderId);
                    var listFolders = reactive.childrensFolder(folder.folderId);
                    bool selectedAllNotes = _controller.selection
                        .checkQuantityNoteSelected(listNotes.length);
                    bool selectedAllFolders = _controller.selection
                        .checkQuantityFolderSelected(listFolders.length);
                    bool selectedAll = selectedAllNotes && selectedAllFolders;

                    return CheckboxAllWidget(
                      selected: selectedAll,
                      onChanged: (value) {
                        value = value ?? false;
                        if (value) {
                          _controller.selection
                              .addAllItemNoteToSelection(listNotes);
                          _controller.selection
                              .addAllItemFolderToSelection(listFolders);
                        } else {
                          _controller.selection.clearNotes();
                          _controller.selection.clearFolder();
                        }
                      },
                      onTap: () {
                        var checkNotes = _controller.selection
                            .checkQuantityNoteSelected(listNotes.length);
                        var checkFolders = _controller.selection
                            .checkQuantityFolderSelected(listFolders.length);
                        if (checkNotes && checkFolders) {
                          _controller.selection
                              .addAllItemNoteToSelection(listNotes);
                          _controller.selection
                              .addAllItemFolderToSelection(listFolders);
                        } else {
                          _controller.selection.clearNotes();
                          _controller.selection.clearFolder();
                        }
                      },
                    );
                  }),
            ),
          );
        }
        return AppBar(
            title: ValueListenableBuilder(
                valueListenable: _dataEncrypt.keyNotifier,
                builder: (context, folder, child) {
                  return ValueListenableBuilder<FolderModel>(
                    valueListenable: _controller.folderParent,
                    builder: (context, folder, child) {
                      return Text(folder.name);
                    },
                  );
                }),
            leading: ValueListenableBuilder<bool>(
              valueListenable: super.drawerMenu.isShowDrawer,
              builder: (context, value, child) {
                return IconButton(
                  icon: Icon(
                    value ? Icons.arrow_back : Icons.menu,
                    size: 26,
                  ),
                  onPressed: () {
                    if (value) {
                      super.drawerMenu.closeDrawer();
                    } else {
                      FocusScope.of(context).unfocus();
                      super.drawerMenu.openDrawer();
                    }
                  },
                );
              },
            ),
            actions: [
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
            ]);
      }),
    );
  }

  @override
  Widget get body => RxBuilder(
        builder: (context) {
          bool selectable = _controller.selection.selectable.value;
          List<NoteModel> noteSelecteds =
              _controller.selection.selectedNoteItems.value;
          List<FolderModel> folderSelecteds =
              _controller.selection.selectedFolderItems.value;
          final reactive = super.drawerMenu.listFieldsStore.reactive;

          return WillPopScope(
            onWillPop: () async {
              if (selectable) {
                _exitModeSelection();
                return false;
              } else {
                final sequencesFolder =
                    reactive.listDescendants(_controller.folder);
                if (sequencesFolder.length > 1) {
                  sequencesFolder.removeLast();
                  _controller.folder = sequencesFolder.last;
                  return false;
                }
              }
              return true;
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: ValueListenableBuilder<FolderModel>(
                valueListenable: _controller.folderParent,
                builder: (context, folder, child) {
                  final sequencesFolder = reactive.listDescendants(folder);
                  sequencesFolder.removeAt(0);

                  return ScrollConfiguration(
                    behavior: NoGlowBehavior(),
                    child: ListView(
                      children: [
                        const SizedBox(height: 22.0),
                        // SEQUENCE OF FOLDER
                        if (folder.folderId != DefaultDatabase.folderIdDefault)
                          IgnorePointer(
                            ignoring: selectable,
                            child: ValueListenableBuilder(
                                valueListenable: _dataEncrypt.keyNotifier,
                                builder: (context, folderer, child) {
                                  return SequenceFolderWidget(
                                    folder: folder,
                                    sequencesFolder: sequencesFolder.toList(),
                                    onTapFolder: (FolderModel seqFolder) {
                                      _controller.folder = seqFolder;
                                    },
                                    onTapSourceFolder: () {
                                      _controller.folder =
                                          DefaultDatabase.folderDefault;
                                    },
                                  );
                                }),
                          ),
                        const SizedBox(height: 2.0),
                        // FOLDERS
                        AnimatedBuilder(
                          animation: reactive,
                          builder: (context, child) {
                            final listFolders =
                                reactive.childrensFolder(folder.folderId);

                            return GridFolderWidget(
                              selection: _controller.selection,
                              selectable: selectable,
                              reactive: reactive,
                              listFolders: listFolders,
                              folderSelecteds: folderSelecteds,
                              onTap: (FolderModel folderChild) {
                                _controller.folder = folderChild;
                              },
                              onLongPressCardFolder: () {
                                super.disableFloatingButtonAdd();
                              },
                            );
                          },
                        ),
                        // SPACER
                        const SizedBox(height: 5.0),
                        // NOTES
                        AnimatedBuilder(
                          animation: reactive,
                          builder: (context, child) {
                            final listNotes = reactive.listNoteByFolder(
                              folder.folderId,
                              orderByDesc: ordeByDesc,
                            );

                            return GridNoteWidget(
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
                            );
                          },
                        ),
                      ],
                    ),
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
      List<NoteModel> noteSelecteds =
          _controller.selection.selectedNoteItems.value;
      List<FolderModel> folderSelecteds =
          _controller.selection.selectedFolderItems.value;

      if (noteSelecteds.isNotEmpty || folderSelecteds.isNotEmpty) {
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

                            if (noteSelecteds.isNotEmpty) {
                              _controller.deleteNote(context, noteSelecteds);
                            }
                            if (folderSelecteds.isNotEmpty) {
                              _controller.deleteFolder(
                                  context, folderSelecteds);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              if (folderSelecteds.isEmpty)
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
      return Container(height: 0);
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
              _controller.folder,
            ],
          );
        },
      );
}
