import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/common.dart';

// ignore: must_be_immutable
class CustomTextFieldWithHint extends StatefulWidget {
  final bool isPass;
  final bool isEmail;
  final String title;
  final String hint;
  final bool nextFocus;
  final FocusNode? focusNode;
  void Function(String)? onChanged;
  final Function(String?)? onSaved;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;

  AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final String? initialValue;

  CustomTextFieldWithHint({
    Key? key,
    required this.hint,
    required this.title,
    this.controller,
    this.initialValue,
    this.isPass = false,
    this.isEmail = false,
    this.nextFocus = false,
    this.focusNode,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.autovalidateMode,
    this.textCapitalization,
  }) : super(key: key);

  @override
  State<CustomTextFieldWithHint> createState() =>
      _CustomTextFieldWithHintState();
}

class _CustomTextFieldWithHintState extends State<CustomTextFieldWithHint> {
  late final FocusNode focusNode;
  String currentText = '';
  late bool isNotVisible;
  double paddingTop = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.isPass) {
      isNotVisible = true;
    } else {
      isNotVisible = false;
    }
    focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72 + paddingTop,
      padding: EdgeInsets.only(top: paddingTop),
      child: FormField<String>(
          autovalidateMode: widget.autovalidateMode,
          initialValue: widget.controller != null
              ? widget.controller?.text
              : widget.initialValue ?? '',
          validator: widget.validator,
          onSaved: widget.onSaved,
          builder: (FormFieldState<String> state) {
            return Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: state.hasError ? 30 : 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            controller: widget.controller,
                            keyboardType: widget.isEmail
                                ? TextInputType.emailAddress
                                : null,
                            focusNode: focusNode,
                            obscureText: isNotVisible,
                            style: TextStyles.fieldStyle(context).copyWith(
                              height: state.hasError ? 0.9 : null,
                            ),
                            inputFormatters: widget.inputFormatters,
                            cursorColor:
                                Theme.of(context).colorScheme.inverseSurface,
                            textCapitalization: widget.textCapitalization ??
                                TextCapitalization.none,
                            onChanged: (text) {
                              currentText = text;
                              state.didChange(text);
                              if (widget.onChanged != null) {
                                widget.onChanged!(text);
                              }
                            },
                            textInputAction:
                                widget.nextFocus ? TextInputAction.next : null,
                            onEditingComplete: widget.nextFocus
                                ? () => FocusScope.of(context).nextFocus()
                                : null,
                            cursorRadius: const Radius.circular(20.0),
                            decoration: InputDecoration(
                              hintText: widget.hint,
                              hintStyle:
                                  TextStyles.fieldStyle(context).copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              hoverColor:
                                  Theme.of(context).colorScheme.surfaceVariant,
                              border: InputBorder.none,
                              suffixIcon: widget.isPass
                                  ? isNotVisible
                                      ? GestureDetector(
                                          child: const Icon(
                                            Icons.visibility_outlined,
                                            size: 22,
                                          ),
                                          onTap: () {
                                            setState(
                                                () => isNotVisible = false);
                                          },
                                        )
                                      : GestureDetector(
                                          child: const Icon(
                                            Icons.visibility_off_outlined,
                                            size: 22,
                                          ),
                                          onTap: () {
                                            setState(() => isNotVisible = true);
                                          },
                                        )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      if (state.hasError)
                        Container(
                          alignment: AlignmentDirectional.centerStart,
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            " ${state.errorText}",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                PositionedDirectional(
                  start: 2.0,
                  bottom: state.hasError ? 52.0 : 50.0,
                  child: IgnorePointer(
                    child: Text(
                      widget.title,
                      style: TextStyles.titleFieldStyle(context),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
