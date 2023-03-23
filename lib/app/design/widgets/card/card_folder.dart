import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

class CardFolder extends StatelessWidget {
  final int qtd;
  final String title;
  final Color? color;
  final Color background;
  final Function()? onTap;
  final Function()? onLongPress;

  const CardFolder({
    Key? key,
    this.color,
    this.onTap,
    this.onLongPress,
    required this.qtd,
    required this.title,
    required this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double size = 80.0;
    if (Sizes.orientation(context) == Orientation.portrait) {
      size = (Sizes.width(context) / 4) - 1.0;
    } else {
      size = (Sizes.width(context) / 7) + 3.0;
    }

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        width: size * 0.925,
        height: size * 0.765,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(size * 0.2),
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: size * 0.75,
                height: size * 0.64,
                margin: const EdgeInsetsDirectional.only(
                  start: 2.0,
                ),
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(size * 0.2),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -(size * 0.117),
              left: -(size * 0.035),
              child: Stack(
                children: [
                  Positioned(
                    left: 0.75,
                    top: 0.75,
                    child: Icon(
                      Icons.folder_rounded,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                      size: size + 0.25,
                    ),
                  ),
                  Icon(
                    Icons.folder_rounded,
                    color:
                        color ?? Theme.of(context).colorScheme.onInverseSurface,
                    size: size,
                  ),
                  Positioned(
                    top: (size * 0.2),
                    left: (size * 0.085),
                    child: Container(
                      width: (size * 0.75) / 2,
                      // color: Colors.black12,
                      margin: const EdgeInsets.only(top: 5.0),
                      padding: EdgeInsets.only(
                        left: (size * 0.075),
                      ),
                      child: Text(
                        qtd.toString(),
                        textAlign: TextAlign.start,
                        style: TextStyles.cardTitleFolder(context),
                      ),
                    ),
                  ),
                  Positioned(
                    left: (size * 0.085),
                    bottom: (size * 0.185),
                    child: Container(
                      height: size * 0.35,
                      width: (size * 0.825),
                      alignment: Alignment.bottomLeft,
                      margin: const EdgeInsets.only(top: 5.0),
                      padding: EdgeInsets.only(
                        left: (size * 0.075),
                        right: (size * 0.075),
                        bottom: (size * 0.070),
                      ),
                      child: Text(
                        title,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.cardTitleFolder(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //
          ],
        ),
      ),
    );
  }
}
