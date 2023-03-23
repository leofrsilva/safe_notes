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
          fontWeight: FontWeight.w600,
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : Theme.of(context).colorScheme.inverseSurface,
        ),
      );
    } else {
      titleWidget = Container();
    }
    final snackBar = SnackBar(
      padding: const EdgeInsets.all(18.0),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
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
                  color: Theme.of(context).brightness == Brightness.light
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.inverseSurface,
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
                            color: Theme.of(context).colorScheme.error,
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
