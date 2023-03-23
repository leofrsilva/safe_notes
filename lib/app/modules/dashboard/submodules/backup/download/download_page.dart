import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';
import 'package:safe_notes/app/modules/dashboard/presenter/pages/drawer/drawer_menu_controller.dart';

import 'download_controller.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  late DownloadController _controller;
  late DrawerMenuController _drawerMenuController;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<DownloadController>();
    _drawerMenuController = Modular.get<DrawerMenuController>();
    _controller.setFolders(
      _drawerMenuController //
          .listFieldsStore
          .reactive
          .allFolders,
    );
    _controller.setNotes(
      _drawerMenuController //
          .listFieldsStore
          .reactive
          .allNotes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SizedBox(
        height: Sizes.height(context),
        child: Stack(
          children: [
            SizedBox(
              width: Sizes.width(context),
              height: Sizes.height(context) * 0.925,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 330.0,
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 20.0,
                      right: 20.0,
                      bottom: 8.0,
                    ),
                    margin: const EdgeInsets.only(bottom: 12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: Sizes.width(context),
                          padding:
                              const EdgeInsets.only(top: 5.0, bottom: 15.0),
                          child: Text.rich(
                            TextSpan(
                              text: 'Baixar Backup?',
                              style: TextStyles.fieldStyle(context),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        if (_controller.canNotDownload)
                          Container(
                            width: Sizes.width(context),
                            padding:
                                const EdgeInsets.only(top: 5.0, bottom: 15.0),
                            child: Text(
                              'Nenhuma Pasta e Nota para efetura o Backup!',
                              style: TextStyles.fieldStyle(context),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        const SizedBox(height: 15.0),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 5.0,
                                  ),
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyles.textButton(context),
                                  ),
                                ),
                                onPressed: () => Modular.to.pop(),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                onPressed: _controller.canNotDownload
                                    ? null
                                    : () {
                                        _controller
                                            .download(context)
                                            .whenComplete(() {
                                          Modular.to.pop();
                                        });
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 5.0,
                                  ),
                                  child: Text(
                                    'Download',
                                    style: TextStyles.textButton(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
