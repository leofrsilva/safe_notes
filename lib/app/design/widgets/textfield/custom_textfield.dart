import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/common.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final bool isPass;
  final bool isEmail;
  final String title;
  final String? hint;
  final bool nextFocus;
  final bool spacingWhenInFocus;
  final FocusNode? focusNode;
  void Function(String)? onChanged;
  final Function(String?)? onSaved;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;

  AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final String? initialValue;

  CustomTextField({
    Key? key,
    required this.title,
    this.hint,
    this.controller,
    this.initialValue,
    this.isPass = false,
    this.isEmail = false,
    this.nextFocus = false,
    this.spacingWhenInFocus = false,
    this.focusNode,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.inputFormatters,
    this.autovalidateMode,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final isFocus = ValueNotifier<bool>(false);
  late final FocusNode focusNode;
  String currentText = '';
  late bool isNotVisible;
  double paddingTop = 0.0;

  void listenerFocus() {
    if (FocusScope.of(context).focusedChild == focusNode) {
      isFocus.value = true;
      if (widget.spacingWhenInFocus) {
        setState(() => paddingTop = 15);
      }
    } else {
      if (currentText.isEmpty) {
        isFocus.value = false;
        if (widget.spacingWhenInFocus) {
          setState(() => paddingTop = 0);
        }
      } else {
        isFocus.value = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isPass) {
      isNotVisible = true;
    } else {
      isNotVisible = false;
    }

    focusNode = widget.focusNode ?? FocusNode();
    focusNode.addListener(listenerFocus);

    if (widget.controller != null) {
      final text = widget.controller?.text ?? '';
      if (text.isNotEmpty) {
        isFocus.value = true;
      }
    }
  }

  @override
  void dispose() {
    focusNode.removeListener(listenerFocus);
    isFocus.dispose();
    if (widget.focusNode == null) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: paddingTop),
      height: 72 + paddingTop,
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
                      SizedBox(
                        height: state.hasError ? 30 : 45,
                        child: TextField(
                          controller: widget.controller,
                          keyboardType: widget.isEmail
                              ? TextInputType.emailAddress
                              : null,
                          focusNode: focusNode,
                          obscureText: isNotVisible,
                          style: TextStyles.fieldStyle(context).copyWith(
                            height: state.hasError ? 1.1 : 0.9,
                          ),
                          cursorColor:
                              Theme.of(context).colorScheme.inverseSurface,
                          inputFormatters: widget.inputFormatters,
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
                          decoration: InputDecoration(
                            hintText: widget.hint,
                            hintStyle: TextStyles.fieldStyle(context).copyWith(
                              height: 3.5,
                            ),
                            filled: true,
                            fillColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            hoverColor:
                                Theme.of(context).colorScheme.surfaceVariant,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: widget.isPass
                                ? isNotVisible
                                    ? IconButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: const Icon(
                                          Icons.visibility_outlined,
                                          size: 22,
                                        ),
                                        onPressed: () => setState(
                                            () => isNotVisible = false),
                                      )
                                    : IconButton(
                                        visualDensity: VisualDensity.compact,
                                        icon: const Icon(
                                          Icons.visibility_off_outlined,
                                          size: 22,
                                        ),
                                        onPressed: () =>
                                            setState(() => isNotVisible = true),
                                      )
                                : null,
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
                ValueListenableBuilder<bool>(
                  valueListenable: isFocus,
                  builder: (context, value, child) {
                    return AnimatedPositionedDirectional(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linearToEaseOut,
                      start: value ? 2.0 : 7.0,
                      bottom: value
                          ? state.hasError
                              ? 52.0
                              : 50.0
                          : state.hasError
                              ? 28.0
                              : 11.0,
                      child: IgnorePointer(
                        child: Text(
                          widget.title,
                          style: TextStyles.titleFieldStyle(context),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }),
    );
  }
}
