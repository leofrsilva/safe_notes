import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

import 'folder_controller.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({Key? key}) : super(key: key);

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
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
                          );
                        }).toList(),
                      );
                    },
                  ),
                  //
                  Container(
                    height: 30,
                    color: Colors.amber,
                  ),
                  //NOTES
                  AnimatedBuilder(
                    animation: reactiveNotes,
                    builder: (context, child) {
                      final listNotes =
                          reactiveNotes.listNoteByFolder(folder.id);
                      return Wrap(
                        alignment: WrapAlignment.start,
                        children: listNotes.map((note) {
                          return CardNote(
                            title: note.title,
                            body: note.body,
                            date: note.dateModification,
                          );
                        }).toList(),
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
  }
}
