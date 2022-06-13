import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/default.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

class SequenceFolderWidget extends StatelessWidget {
  final FolderQtdChildView folder;
  final Function()? onTapSourceFolder;
  final List<FolderQtdChildView> sequencesFolder;

  const SequenceFolderWidget({
    Key? key,
    required this.folder,
    this.onTapSourceFolder,
    required this.sequencesFolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        bottom: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onTapSourceFolder,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 8.0,
              ),
              child: Icon(
                Icons.folder_outlined,
                color: ColorPalettes.blueGrey,
              ),
            ),
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: NoGlowBehavior(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: sequencesFolder.map((folderSeq) {
                      if (folderSeq.name == folder.name) {
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: ColorPalettes.grey,
                                size: 16,
                              ),
                            ),
                            Text(
                              folderSeq.name,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: ColorPalettes.grey,
                              size: 16,
                            ),
                          ),
                          Text(
                            folderSeq.name,
                            style: TextStyle(
                              color: ColorPalettes.grey,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
