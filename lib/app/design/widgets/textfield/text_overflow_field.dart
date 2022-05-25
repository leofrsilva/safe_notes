import 'package:flutter/material.dart';

class TextOverflowField extends StatefulWidget {
  final double? minWidth;
  final int? maxLines;

  final double height;
  final double spaceTop;
  final double spaceLeft;
  final double spaceRight;

  final Curve? curve;
  final Duration duration;
  final bool canRequestFocus;
  final TextEditingController controller;

  final TextStyle? style;
  final String? hintText;
  final TextStyle? hintStyle;
  final InputBorder? border;

  final Function(String)? onChanged;
  final Function()? onTapTextField;

  const TextOverflowField({
    Key? key,
    this.minWidth,
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
    this.onChanged,
    this.onTapTextField,
    //
    required this.controller,
    this.canRequestFocus = true,
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
  // late FocusNode _focusNodeContainer;
  late bool canRequestFocus;

  toggleFocus(bool value) {
    if (value != _isFocus) {
      setState(() => _isFocus = value);
    }
  }

  Widget _buildTextField(TextStyle style) {
    return Focus(
      // focusNode: _focusNodeContainer,
      onFocusChange: (hasFocus) {
        print('== Perdeu Focus do Container ==');
      },
      child: Container(
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
      ),
    );
  }

  Widget _overflowReplacement(TextStyle style) {
    style = widget.data.isEmpty ? widget.hintStyle ?? style : style;
    var data = widget.data.isEmpty ? widget.hintText ?? '' : widget.data;

    final words = data.split(' ');

    return GestureDetector(
      onTap: () {
        widget.onTapTextField?.call();
        toggleFocus(true);
        Future.delayed(widget.duration, () {
          if (canRequestFocus) {
            _focusNodeTextField.requestFocus();
          } else {
            // _focusNodeContainer.requestFocus();
          }
        });
      },
      child: Container(
        height: widget.height,
        width: widget.minWidth ?? double.infinity,
        alignment: AlignmentDirectional.centerStart,
        padding: EdgeInsets.only(
          top: widget.spaceTop,
          left: widget.spaceLeft,
          right: widget.spaceRight,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: words.map((word) {
            if (word == words.last) {
              return Expanded(
                child: Text(
                  word,
                  style: style.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }
            return Text('$word ', style: style);
          }).toList(),
        ),
      ),
    );
  }

  void verifyFocus() {
    if (!(FocusScope.of(context).focusedChild == _focusNodeTextField)) {
      print('-- Perdeu o Foco --');
      toggleFocus(false);
    }
  }

  @override
  void initState() {
    super.initState();
    // _focusNodeContainer = FocusNode();
    _focusNodeTextField = FocusNode();
    _focusNodeTextField.addListener(verifyFocus);
    canRequestFocus = widget.canRequestFocus;
  }

  @override
  void didUpdateWidget(covariant TextOverflowField oldWidget) {
    super.didUpdateWidget(oldWidget);
    canRequestFocus = widget.canRequestFocus;
  }

  @override
  void dispose() {
    _focusNodeTextField.removeListener(verifyFocus);
    _focusNodeTextField.dispose();
    // _focusNodeContainer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).addListener(verifyFocus);
    var style = widget.style ?? DefaultTextStyle.of(context).style;

    return AnimatedCrossFade(
      duration: widget.duration,
      firstCurve: widget.curve ?? Curves.easeInOutExpo,
      secondCurve: widget.curve ?? Curves.easeInOutExpo,
      firstChild: _buildTextField(style),
      secondChild: _overflowReplacement(style),
      crossFadeState:
          _isFocus ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
