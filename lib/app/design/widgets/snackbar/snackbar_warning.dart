import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

class SnackbarWarning {
  static show(
    BuildContext context, {
    Duration? duration,
    double? height,
    required String message,
  }) {
    height = height ?? Sizes.height(context) * 0.03;
    final snackBar = SnackBar(
      padding: const EdgeInsets.all(18.0),
      backgroundColor: ColorPalettes.blueGrey,
      content: SizedBox(
        height: height,
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'JosefinSans',
              color: ColorPalettes.whiteSemiTransparent,
            ),
          ),
        ),
      ),
      duration: duration ?? const Duration(milliseconds: 1500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
