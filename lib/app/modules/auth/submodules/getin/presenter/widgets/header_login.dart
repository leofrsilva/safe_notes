import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/design/common/utils/utils.dart';

class HeaderLogin extends StatelessWidget {
  const HeaderLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.height(context) * 0.30 - Sizes.heightStatusBar(context),
      width: Sizes.width(context),
      child: Stack(
        children: [
          WaveLeft(fractionHeight: 0.30 + 0.40),
          Container(
            margin: EdgeInsets.only(
              top: Sizes.heightStatusBar(context),
            ),
            alignment: AlignmentDirectional.center,
            height:
                Sizes.height(context) * 0.24 - Sizes.heightStatusBar(context),
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Image.asset(
                      ImagesAssets.imgLoginBg,
                      color: Theme.of(context).backgroundColor,
                      fit: BoxFit.cover,
                      width: Sizes.height(context) * 0.12,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextTitle(
                        size: Sizes.height(context) * 0.12 / 4,
                        text: 'Safe Notes',
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).backgroundColor,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Faça Login para Continuar',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'JosefinSans',
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).backgroundColor,
                          fontSize: Sizes.height(context) * 0.12 / 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
