import 'package:flutter/material.dart';

class RelativeRectPosition {
  static RelativeRect getRelativeRect(GlobalKey key) {
    return RelativeRect.fromSize(
      _getWidgetGlobalRect(key),
      const Size(200, 200),
    );
  }

  static Rect _getWidgetGlobalRect(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    debugPrint('Widget position: ${offset.dx} ${offset.dy}');
    return Rect.fromLTWH(
      offset.dx / 3.1,
      offset.dy * 1.05,
      renderBox.size.width,
      renderBox.size.height,
    );
  }
}
