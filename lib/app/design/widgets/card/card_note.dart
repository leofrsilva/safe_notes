import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

class CardNote extends StatelessWidget {
  final String body;
  final String title;
  final DateTime date;
  final Color? backgroundColor;

  final Function()? onTap;
  const CardNote({
    Key? key,
    this.onTap,
    required this.title,
    required this.body,
    required this.date,
    this.backgroundColor,
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
          InkWell(
            onTap: onTap,
            child: Card(
              elevation: 3.0,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: backgroundColor ?? ColorPalettes.white,
                  borderRadius: BorderRadius.circular(35.0),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  body,
                  maxLines: 9,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.fade,
                  style: TextStyles.cardBodyNote,
                ),
              ),
            ),
          ),
          Container(
            height: height * 0.30,
            width: width,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 8.0),
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
            // padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              title.isEmpty
                  ? '${date.hour}:${date.minute}'
                  : DateConvert.dateToString(date),
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyles.cardDateNote,
            ),
          ),
        ],
      ),
    );
  }
}
