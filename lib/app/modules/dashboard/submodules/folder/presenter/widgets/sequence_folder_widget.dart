import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/shared/database/models/folder_model.dart';

class SequenceFolderWidget extends StatefulWidget {
  final FolderModel folder;
  final Function()? onTapSourceFolder;
  final Function(FolderModel) onTapFolder;
  final List<FolderModel> sequencesFolder;

  const SequenceFolderWidget({
    Key? key,
    required this.folder,
    this.onTapSourceFolder,
    required this.onTapFolder,
    required this.sequencesFolder,
  }) : super(key: key);

  @override
  State<SequenceFolderWidget> createState() => _SequenceFolderWidgetState();
}

class _SequenceFolderWidgetState extends State<SequenceFolderWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void didUpdateWidget(covariant SequenceFolderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    Future.delayed(const Duration(milliseconds: 1500), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

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
            onTap: widget.onTapSourceFolder,
            child: Container(
              width: Sizes.width(context) * 0.08,
              padding: const EdgeInsetsDirectional.only(
                end: 4.0,
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
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widget.sequencesFolder.map((folderSeq) {
                      if (folderSeq.folderId == widget.folder.folderId) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                      return GestureDetector(
                        onTap: () => widget.onTapFolder(folderSeq),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                        ),
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
