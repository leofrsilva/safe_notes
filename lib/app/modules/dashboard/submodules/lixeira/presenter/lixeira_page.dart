import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';

import '../../../presenter/mixin/template_page_mixin.dart';
import 'lixeira_controller.dart';

class LixeiraPage extends StatefulWidget {
  const LixeiraPage({Key? key}) : super(key: key);

  @override
  State<LixeiraPage> createState() => _LixeiraPageState();
}

class _LixeiraPageState extends State<LixeiraPage> with TemplatePageMixin {
  late LixeiraController _controller;

  @override
  String get title => 'Lixeira';

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<LixeiraController>();
  }

  @override
  Widget get body {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: ScrollConfiguration(
        behavior: NoGlowBehavior(),
        child: ListView(
          children: [
            AnimatedBuilder(
              animation: super.drawerMenu.listFieldsStore.reactive,
              builder: (context, child) {
                final reactive = super.drawerMenu.listFieldsStore.reactive;
                final foldersDeleted = reactive.listFolderDeleted;

                return Wrap(
                  alignment: WrapAlignment.start,
                  children: foldersDeleted.map((folder) {
                    return CardFolder(
                      qtd: reactive.numberChildrenInFolder(folder),
                      title: folder.name,
                      background: Color(folder.color),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 15.0),
            // FutureBuilder<List<NoteModel>>(
            //   future: _controller.getNotesDeleted(context),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(
            //         child: Padding(
            //           padding: EdgeInsets.all(8.0),
            //           child: CircularProgressIndicator(),
            //         ),
            //       );
            //     } else if (snapshot.connectionState ==
            //             ConnectionState.active ||
            //         snapshot.connectionState == ConnectionState.done) {
            //       if (snapshot.hasData) {
            //         final listNotesDeled = snapshot.data!;
            //         if (listNotesDeled.isNotEmpty) {
            //           return Wrap(
            //             alignment: WrapAlignment.start,
            //             children: listNotesDeled.map((note) {
            //               return CardNote(
            //                 title: note.title,
            //                 body: note.body,
            //                 date: note.dateModification,
            //               );
            //             }).toList(),
            //           );
            //         }
            //       }
            //     }
            //     return Container();
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
