import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';

import '../manager_folders_controller.dart';

class DeleteFolderPage extends StatelessWidget {
  final List<int> listIdToDelete;
  final _controller = Modular.get<ManagerFoldersController>();

  DeleteFolderPage({
    Key? key,
    required this.listIdToDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalettes.transparent,
      body: SizedBox(
        height: Sizes.height(context),
        child: Stack(
          children: [
            SizedBox(
              height: Sizes.height(context) * 0.925,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ModalBarrier(
                    dismissible: true,
                    onDismiss: () {
                      Modular.to.pop();
                    },
                  ),
                  Container(
                    width: 330.0,
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
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
                              style: TextStyles.fieldStyle.copyWith(
                                color: ColorPalettes.blueGrey,
                              ),
                              text: 'Mover ${listIdToDelete.length} ',
                              children: [
                                if (listIdToDelete.length > 1)
                                  const TextSpan(text: 'pastas para a Lixeira?')
                                else
                                  const TextSpan(text: 'pasta para a Lixeira?'),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                child: Text(
                                  'Cancelar',
                                  style: TextStyles.textButton(context),
                                ),
                                onPressed: () {
                                  Modular.to.pop();
                                },
                              ),
                              Container(
                                width: 1.5,
                                height: 12.0,
                                color: ColorPalettes.blueGrey,
                              ),
                              TextButton(
                                child: Text(
                                  'Mover para a Lixeira',
                                  style:
                                      TextStyles.textButton(context).copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  if (listIdToDelete.length == 1) {
                                    _controller.deleteFolder(
                                        context, listIdToDelete.first);
                                  }
                                  Modular.to.pop();
                                },
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
