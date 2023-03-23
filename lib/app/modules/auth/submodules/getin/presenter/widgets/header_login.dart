import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/design/common/util/utils.dart';

class HeaderLogin extends StatelessWidget {
  const HeaderLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = Sizes.height(context) - Sizes.heightStatusBar(context);
    return SizedBox(
      height: height * 0.30,
      width: Sizes.width(context),
      child: Stack(
        children: [
          WaveLeft(fractionHeight: 0.30 + 0.40),
          Container(
            margin: EdgeInsets.only(
              top: Sizes.heightStatusBar(context),
            ),
            alignment: AlignmentDirectional.center,
            height: height * 0.24,
            // height: height * 0.24 - Sizes.heightStatusBar(context),
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Image.asset(
                      ImagesAssets.imgLoginBg,
                      color: Theme.of(context).colorScheme.background,
                      fit: BoxFit.cover,
                      width: height * 0.12,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextTitle(
                        size: height * 0.12 / 4,
                        text: 'Safe Notes',
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onInverseSurface,
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Faça Login para Continuar',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'JosefinSans',
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onInverseSurface,
                          fontSize: height * 0.12 / 6,
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
