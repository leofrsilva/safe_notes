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

  final double height = 150.0;
  final double width = 100.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        end: 15.0,
        bottom: 15.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  color: backgroundColor ?? ColorPalettes.white,
                  borderRadius: BorderRadius.circular(10.0),
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
              title,
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
              DateConvert.dateToString(date),
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
