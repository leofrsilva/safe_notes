import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';

import '../../enum/mode_note_enum.dart';
import '../../reactive/reactive_list_folder.dart';
import '../../reactive/reactive_list_note.dart';

class CustomSearchDelegate extends SearchDelegate<String?> {
  final ReactiveListNote reactiveListNote;
  final ReactiveListFolder reactiveListFolder;
  CustomSearchDelegate({
    required this.reactiveListNote,
    required this.reactiveListFolder,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          appBarTheme: Theme.of(context).appBarTheme,
        );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        color: ColorPalettes.grey,
        onPressed: () => query = "",
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox(
      width: Sizes.width(context),
      height: Sizes.height(context),
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.start,
          children: reactiveListNote.searchNote(query).map((note) {
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
                    reactiveListFolder.getFolder(note.folderId),
                  ],
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final listNotes = reactiveListNote.searchNote(query);

    if (listNotes.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum resultado encontrado',
          style: TextStyle(),
        ),
      );
    }
    return SizedBox(
      width: Sizes.width(context),
      height: Sizes.height(context),
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.start,
          children: reactiveListNote.searchNote(query).map((note) {
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
                    reactiveListFolder.getFolder(note.folderId),
                  ],
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
