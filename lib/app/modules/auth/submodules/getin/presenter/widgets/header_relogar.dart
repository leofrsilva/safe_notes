import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/styles/color_palettes.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/design/common/utils/utils.dart';

class HeaderRelogar extends StatelessWidget {
  const HeaderRelogar({
    Key? key,
    this.onPressedIcon,
    required this.name,
  }) : super(key: key);

  final Function()? onPressedIcon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Sizes.width(context),
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: IconButton(
              color: ColorPalettes.secondy,
              icon: Icon(
                Icons.close_outlined,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: onPressedIcon,
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              height: Sizes.height(context) * 0.35,
              alignment: AlignmentDirectional.bottomCenter,
              padding: EdgeInsets.only(
                bottom: Sizes.height(context) * 0.015,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Image.asset(
                          ImagesAssets.imgLoginBg,
                          color: Theme.of(context).primaryColor,
                          width: Sizes.height(context) * 0.12,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      TextTitle(
                        size: Sizes.height(context) * 0.12 / 4,
                        text: 'Safe Notes',
                        fontWeight: FontWeight.w600,
                        color: ColorPalettes.blueGrey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: Sizes.width(context) / 1.5,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                                text: 'Continuar logado como ',
                                style: TextStyle(
                                  fontFamily: 'JosefinSans',
                                  fontWeight: FontWeight.w600,
                                  color: ColorPalettes.blueGrey,
                                  fontSize: Sizes.height(context) * 0.12 / 6,
                                ),
                                children: [
                                  TextSpan(
                                    text: name,
                                    style: TextStyle(
                                      fontFamily: 'JosefinSans',
                                      fontWeight: FontWeight.w600,
                                      height: 1.2,
                                      color: Theme.of(context).primaryColor,
                                      fontSize:
                                          Sizes.height(context) * 0.15 / 6,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ],
                    ),
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
