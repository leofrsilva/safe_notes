import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';

class ConfirmDeletionWidget extends StatelessWidget {
  final String title;
  final Function() onConfirmation;

  const ConfirmDeletionWidget({
    Key? key,
    required this.title,
    required this.onConfirmation,
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
                      bottom: 8.0,
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
                          child: Text(
                            title,
                            textAlign: TextAlign.start,
                            style: TextStyles.fieldStyle.copyWith(
                              color: ColorPalettes.blueGrey,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyles.textButton(context),
                                  ),
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
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                  ),
                                  child: Text(
                                    'Mover para a Lixeira',
                                    style:
                                        TextStyles.textButton(context).copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  onConfirmation.call();
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
