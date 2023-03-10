import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';

import 'upload_controller.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late UploadController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<UploadController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalettes.black54,
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
                              text:
                                  'Ao fazer Upload, as Pastas e Notas atuais serão Deletadas!',
                              style: TextStyles.fieldStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorPalettes.blueGrey,
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        FutureBuilder(
                          future: _controller.upload(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done ||
                                snapshot.connectionState ==
                                    ConnectionState.active) {
                              return SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 5.0,
                                        ),
                                        child: Text(
                                          'Cancelar',
                                          style: TextStyles.textButton(context)
                                              .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      onPressed: () => Modular.to.pop(),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 5.0,
                                        ),
                                        child: Text(
                                          'Confirmar',
                                          style: TextStyles.textButton(context)
                                              .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        _controller
                                            .addFields(context)
                                            .whenComplete(() {
                                          Modular.to.pop();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox(
                              height: 30,
                              child: Text('...'),
                            );
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
    );
  }
}
