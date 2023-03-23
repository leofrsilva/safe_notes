import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';
import 'package:safe_notes/app/design/common/util/utils.dart';

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
    late double height;
    late double sizeLogo;
    late double heightSubTitle;
    late double fontSizeNameUser;

    late MainAxisAlignment mainAxisAlignment;
    late AlignmentDirectional alignmentClose;
    late AlignmentDirectional alignmentContainer;

    var heightTotal = Sizes.height(context) - Sizes.heightStatusBar(context);
    if (Sizes.orientation(context) == Orientation.portrait) {
      height = heightTotal * 0.30;
      sizeLogo = heightTotal * 0.12;
      heightSubTitle = Sizes.width(context) / 1.5;
      fontSizeNameUser = heightTotal * 0.15 / 6;

      mainAxisAlignment = MainAxisAlignment.end;
      alignmentClose = AlignmentDirectional.topEnd;
      alignmentContainer = AlignmentDirectional.center;
    } else {
      height = (heightTotal - Sizes.heightStatusBar(context)) * (1 - 0.015);
      sizeLogo = heightTotal * 0.2;
      heightSubTitle = (Sizes.width(context) * 0.4) / 1.5;
      fontSizeNameUser = sizeLogo / 5;

      mainAxisAlignment = MainAxisAlignment.center;
      alignmentClose = AlignmentDirectional.topEnd;
      alignmentContainer = AlignmentDirectional.center;
    }

    return Stack(
      children: [
        Align(
          alignment: alignmentClose,
          child: IconButton(
            icon: Icon(
              Icons.close_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: onPressedIcon,
          ),
        ),
        Align(
          alignment: alignmentContainer,
          child: Container(
            height: height,
            alignment: alignmentContainer,
            padding: EdgeInsets.only(
              bottom: Sizes.height(context) * 0.0075,
            ),
            child: Column(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Image.asset(
                        ImagesAssets.imgLoginBg,
                        color: Theme.of(context).colorScheme.primary,
                        width: sizeLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 6.0),
                    TextTitle(
                      size: sizeLogo / 4,
                      text: 'Safe Notes',
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: heightSubTitle,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                              text: 'Continuar logado como ',
                              style: TextStyle(
                                fontFamily: 'JosefinSans',
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                                fontSize: sizeLogo / 6,
                              ),
                              children: [
                                TextSpan(
                                  text: name,
                                  style: TextStyle(
                                    fontFamily: 'JosefinSans',
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontSize: fontSizeNameUser,
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
    );
  }
}
