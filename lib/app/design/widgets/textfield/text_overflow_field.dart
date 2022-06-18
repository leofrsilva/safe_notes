import 'package:flutter/material.dart';

class TextOverflowField extends StatefulWidget {
  final double minWidth;
  final int? maxLines;

  final double height;
  final double spaceTop;
  final double spaceLeft;
  final double spaceRight;

  final Curve? curve;
  final Duration duration;
  final TextEditingController controller;

  final TextStyle? style;
  final String? hintText;
  final TextStyle? hintStyle;
  final InputBorder? border;
  final Function(String)? onChanged;

  final bool? canRequestFocus;
  final Function()? onTapTextField;

  const TextOverflowField({
    Key? key,
    required this.minWidth,
    this.maxLines = 1,
    this.height = 30.0,
    this.spaceTop = 0.0,
    this.spaceLeft = 0.0,
    this.spaceRight = 0.0,
    //
    this.style,
    this.hintText,
    this.hintStyle,
    this.border = InputBorder.none,
    //
    this.onTapTextField,
    this.canRequestFocus = true,
    //
    this.onChanged,
    required this.controller,
    this.duration = const Duration(milliseconds: 500),
    this.curve,
  }) : super(key: key);

  String get data => controller.text;

  @override
  State<TextOverflowField> createState() => TextFieldOverflowState();
}

class TextFieldOverflowState extends State<TextOverflowField> {
  bool _isFocus = false;
  late FocusNode _focusNodeTextField;
  late bool canRequestFocus;

  toggleFocus(bool value) {
    if (value != _isFocus) {
      setState(() => _isFocus = value);
    }
  }

  Widget _buildTextField(TextStyle style) {
    return Container(
      height: widget.height,
      width: widget.minWidth,
      padding: EdgeInsets.only(top: widget.spaceTop),
      alignment: AlignmentDirectional.centerStart,
      child: TextField(
        style: style,
        focusNode: _focusNodeTextField,
        controller: widget.controller,
        maxLines: widget.maxLines,
        textAlign: TextAlign.start,
        onChanged: widget.onChanged,
        onTap: widget.onTapTextField,
        decoration: InputDecoration(
          isDense: true,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: widget.spaceLeft,
            right: widget.spaceRight,
          ),
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          border: widget.border,
        ),
      ),
    );
  }

  Widget _overflowReplacement(TextStyle style) {
    int qtdCaracter = (widget.minWidth / 13).floor();
    String text = widget.data.trim();
    if (widget.data.length > qtdCaracter) {
      text = text.substring(0, qtdCaracter);
      text += '...';
    }

    return GestureDetector(
      onTap: () {
        widget.onTapTextField?.call();
        toggleFocus(true);
        Future.delayed(widget.duration, () {
          if (canRequestFocus) {
            _focusNodeTextField.requestFocus();
          }
          // else {
          // _focusNodeContainer.requestFocus();
          // }
        });
      },
      child: Container(
        height: widget.height,
        width: widget.minWidth,
        alignment: AlignmentDirectional.centerStart,
        padding: EdgeInsets.only(
          top: widget.spaceTop,
          left: widget.spaceLeft,
          // right: widget.spaceRight,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: style,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void verifyFocus() {
    if (!(FocusScope.of(context).focusedChild == _focusNodeTextField)) {
      toggleFocus(false);
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNodeTextField = FocusNode();
    _focusNodeTextField.addListener(verifyFocus);
    canRequestFocus = widget.canRequestFocus ?? true;
  }

  @override
  void didUpdateWidget(covariant TextOverflowField oldWidget) {
    super.didUpdateWidget(oldWidget);
    canRequestFocus = widget.canRequestFocus ?? true;
  }

  @override
  void dispose() {
    _focusNodeTextField.removeListener(verifyFocus);
    _focusNodeTextField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.style ?? DefaultTextStyle.of(context).style;

    return AnimatedCrossFade(
      duration: widget.duration,
      firstCurve: widget.curve ?? Curves.easeInOutExpo,
      secondCurve: widget.curve ?? Curves.easeInOutExpo,
      firstChild: _buildTextField(style),
      secondChild: _overflowReplacement(style),
      crossFadeState: widget.canRequestFocus == null
          ? CrossFadeState.showSecond
          : _isFocus
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
    );
  }
}
