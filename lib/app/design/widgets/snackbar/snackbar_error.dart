import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

class SnackbarError {
  static show(
    BuildContext context, {
    String? title,
    Duration? duration,
    required String message,
  }) {
    late Widget titleWidget;
    if (title != null) {
      titleWidget = Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontFamily: 'JosefinSans',
          color: ColorPalettes.white,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      titleWidget = Container();
    }
    final snackBar = SnackBar(
      padding: const EdgeInsets.all(18.0),
      backgroundColor: ColorPalettes.redLight,
      content: SizedBox(
        height: Sizes.height(context) * 0.065,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Icon(
                  Icons.error_outline,
                  color: ColorPalettes.whiteSemiTransparent,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleWidget,
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          message,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'JosefinSans',
                            color: ColorPalettes.whiteSemiTransparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      duration: duration ?? const Duration(milliseconds: 1500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
