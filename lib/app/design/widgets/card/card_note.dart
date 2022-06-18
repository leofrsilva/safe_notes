import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

class CardNote extends StatelessWidget {
  final String body;
  final String title;
  final DateTime date;
  final bool favorite;
  final Color? backgroundColor;

  final Function()? onTap;
  final Function()? onLongPress;

  const CardNote({
    Key? key,
    this.onTap,
    this.onLongPress,
    required this.title,
    required this.body,
    required this.date,
    this.backgroundColor,
    this.favorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double spacer = (Sizes.width(context) - 28);
    double height = 150.0;
    double width = 100.0;

    double padding = 2.0;
    if (Sizes.orientation(context) == Orientation.portrait) {
      width = (spacer / 3) - 16.0;
      padding = 16.0 / 4.0;
    } else {
      width = (spacer / 5) - 16.0;
      padding = 16.0 / 4.0;
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(
        end: padding,
        start: padding,
        bottom: 25.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: InkWell(
                onTap: onTap,
                onLongPress: onLongPress,
                borderRadius: BorderRadius.circular(15.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    body,
                    maxLines: 12,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.fade,
                    style: TextStyles.cardBodyNote,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: height * 0.30,
            width: width,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              title.isEmpty
                  ? 'Nota de texto ${date.day}/${date.month.toString().padLeft(2, '0')}'
                  : title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.cardTitleNote,
            ),
          ),
          Container(
            width: width,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Text(
                    date.day == DateTime.now().day
                        ? '${date.hour}:${date.minute.toString().padLeft(2, '0')}'
                        : DateConvert.dateToString(date),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyles.cardDateNote,
                  ),
                ),
                if (favorite)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 6.0,
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      color: ColorPalettes.yellow,
                      size: 14,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
