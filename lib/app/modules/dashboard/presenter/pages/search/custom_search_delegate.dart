import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';

import '../../enum/mode_note_enum.dart';
import '../../reactive/i_reactive_list.dart';

class CustomSearchDelegate extends SearchDelegate<String?> {
  final IReactiveList reactiveList;

  CustomSearchDelegate({
    required this.reactiveList,
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
        // color: Colors.grey,
        // // color: ColorPalettes.grey,
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
    final list = reactiveList.searchNote(query);
    return SizedBox(
      width: Sizes.width(context),
      height: Sizes.height(context),
      child: SingleChildScrollView(
        child: Wrap(
          alignment:
              list.length > 2 ? WrapAlignment.spaceAround : WrapAlignment.start,
          children: list.map((note) {
            return CardNote(
              title: note.title,
              body: note.body,
              favorite: note.favorite,
              date: note.dateModification,
              onTap: () {
                Modular.to.pushNamed(
                  '/dashboard/add-or-edit-note/',
                  arguments: [
                    ModeNoteEnum.edit,
                    note,
                    reactiveList.getFolder(note.folderId),
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
    final listNotes = reactiveList.searchNote(query);

    if (listNotes.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum resultado encontrado',
          style: TextStyle(),
        ),
      );
    }
    return Container(
      width: Sizes.width(context),
      height: Sizes.height(context),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: Wrap(
          alignment: listNotes.length > 2
              ? WrapAlignment.spaceAround
              : WrapAlignment.start,
          children: listNotes.map((note) {
            return CardNote(
              title: note.title,
              body: note.body,
              favorite: note.favorite,
              date: note.dateModification,
              onTap: () {
                Modular.to.pushNamed(
                  '/dashboard/add-or-edit-note/',
                  arguments: [
                    ModeNoteEnum.edit,
                    note,
                    reactiveList.getFolder(note.folderId),
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
