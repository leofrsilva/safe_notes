import 'package:flutter/material.dart';

const double _kMenuHorizontalPadding = 16.0;

class PopupMenu<T> extends PopupMenuEntry<T> {
  const PopupMenu({
    Key? key,
    this.value,
    this.onTap,
    this.borderRadius,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.mouseCursor,
    required this.child,
  }) : super(key: key);

  final T? value;

  final BorderRadius? borderRadius;

  final VoidCallback? onTap;

  final bool enabled;

  @override
  final double height;

  final EdgeInsets? padding;

  final TextStyle? textStyle;

  final MouseCursor? mouseCursor;

  final Widget? child;

  @override
  bool represents(T? value) => value == this.value;

  @override
  PopupMenuState<T, PopupMenu<T>> createState() =>
      PopupMenuState<T, PopupMenu<T>>();
}

class PopupMenuState<T, W extends PopupMenu<T>> extends State<W> {
  @protected
  Widget? buildChild() => widget.child;

  @protected
  void handleTap() {
    widget.onTap?.call();

    Navigator.pop<T>(context, widget.value);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    TextStyle style =
        widget.textStyle ?? popupMenuTheme.textStyle ?? const TextStyle();

    if (!widget.enabled) style = style.copyWith(color: theme.disabledColor);

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ??
            const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final bool isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }
    final MouseCursor effectiveMouseCursor =
        MaterialStateProperty.resolveAs<MouseCursor>(
      widget.mouseCursor ?? MaterialStateMouseCursor.clickable,
      <MaterialState>{
        if (!widget.enabled) MaterialState.disabled,
      },
    );

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: widget.enabled ? handleTap : null,
          canRequestFocus: widget.enabled,
          mouseCursor: effectiveMouseCursor,
          child: item,
        ),
      ),
    );
  }
}
