import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import '../../add_or_edit_note/presenter/enum/mode_note_enum.dart';
import 'folder_controller.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  bool ordeByDesc = true;

  late FolderController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<FolderController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<FolderQtdChildView>(
            valueListenable: _controller.folderParent,
            builder: (context, folder, child) {
              return Text(folder.name);
            }),
        leading: ValueListenableBuilder<bool>(
          valueListenable: _controller.drawerMenu.isShowDrawer,
          builder: (context, value, child) {
            return IconButton(
              icon: Icon(
                value ? Icons.arrow_back : Icons.menu,
                size: 26,
              ),
              onPressed: () {
                if (value) {
                  _controller.drawerMenu.closeDrawer();
                } else {
                  FocusScope.of(context).unfocus();
                  _controller.drawerMenu.openDrawer();
                }
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ValueListenableBuilder<FolderQtdChildView>(
          valueListenable: _controller.folderParent,
          builder: (context, folder, child) {
            final reactiveFolders =
                _controller.drawerMenu.shared.reactiveFolders;
            final reactiveNotes = _controller.drawerMenu.shared.reactiveNotes;

            return ScrollConfiguration(
              behavior: NoGlowBehavior(),
              child: ListView(
                children: [
                  // FOLDERS
                  AnimatedBuilder(
                    animation: reactiveFolders,
                    builder: (context, child) {
                      final listFolders =
                          reactiveFolders.childrensFolder(folder.id);

                      return Wrap(
                        alignment: WrapAlignment.start,
                        children: listFolders.map((folder) {
                          return CardFolder(
                            qtd: folder.qtd,
                            title: folder.name,
                            background: Color(folder.color),
                            onTap: () => _controller.folder = folder,
                          );
                        }).toList(),
                      );
                    },
                  ),
                  //
                  const SizedBox(height: 5.0),
                  //NOTES
                  AnimatedBuilder(
                    animation: reactiveNotes,
                    builder: (context, child) {
                      final listNotes =
                          reactiveNotes.listNoteByFolder(folder.id, ordeByDesc);

                      return Column(
                        children: [
                          if (listNotes.isNotEmpty)
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
                          Wrap(
                            alignment: WrapAlignment.start,
                            children: listNotes.map((note) {
                              return CardNote(
                                title: note.title,
                                body: note.body,
                                date: note.dateModification,
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}
