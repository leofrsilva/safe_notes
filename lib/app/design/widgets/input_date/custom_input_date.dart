import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

class CustomInputDate extends StatefulWidget {
  final String title;
  final bool nextFocus;
  final bool spacingWhenInFocus;
  final Function(String?)? onSaved;
  final TextEditingController controller;

  const CustomInputDate({
    Key? key,
    this.onSaved,
    this.nextFocus = false,
    this.spacingWhenInFocus = false,
    required this.controller,
    required this.title,
  }) : super(key: key);

  @override
  State<CustomInputDate> createState() => _CustomInputDateState();
}

class _CustomInputDateState extends State<CustomInputDate> {
  final isFocus = ValueNotifier<bool>(false);
  late final FocusNode focusNode;
  double paddingTop = 0.0;

  void listenerFocus() {
    if (FocusScope.of(context).focusedChild == focusNode) {
      isFocus.value = true;
      if (widget.spacingWhenInFocus) {
        setState(() => paddingTop = 15);
      }
    } else {
      if (widget.controller.text.isEmpty) {
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
    focusNode = FocusNode();
    focusNode.addListener(listenerFocus);

    final text = widget.controller.text;
    if (text.isNotEmpty) {
      isFocus.value = true;
    }
    // if (widget.textEditingController.text.isNotEmpty) {
    //   isFocus.value = true;
    // }
  }

  @override
  void dispose() {
    focusNode.removeListener(listenerFocus);
    focusNode.dispose();
    isFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: paddingTop),
      height: 70 + paddingTop,
      child: FormField<String>(
          initialValue: widget.controller.text,
          onSaved: widget.onSaved,
          validator: (String? date) {
            if (date == null || date.isEmpty) {
              return 'A data é obrigatória!';
            }
            if (Validation.ofData(date) == false) {
              return 'A data não é valida!';
            }
            return null;
          },
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
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: ColorPalettes.black.withOpacity(0.035),
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                            ),
                          ],
                        ),
                        child: TextField(
                          focusNode: focusNode,
                          style: TextStyles.fieldStyle,
                          controller: widget.controller,
                          cursorColor: Theme.of(context).primaryColor,
                          inputFormatters: [DataInputFormatter()],
                          onChanged: (String text) => state.didChange(text),
                          onEditingComplete: widget.nextFocus
                              ? () => FocusScope.of(context).nextFocus()
                              : null,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorPalettes.whiteSemiTransparent,
                            hoverColor: ColorPalettes.whiteSemiTransparent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.date_range_outlined,
                                size: 22,
                              ),
                              onPressed: () async {
                                DateTime? initalDate =
                                    widget.controller.text.toConvertDateTime;
                                DateTime? date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(DateTime.now().year -
                                      DateConstant.rangeOfYears),
                                  lastDate: DateTime.now(),
                                  initialDate: initalDate ?? DateTime.now(),
                                );
                                if (date != null) {
                                  widget.controller.text =
                                      date.toOriginalFormatString;
                                  state.didChange(date.toOriginalFormatString);

                                  focusNode.requestFocus();
                                }
                              },
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
                            style: TextStyles.errorFieldStyle,
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
                          ? 50.0
                          : state.hasError
                              ? 24.0
                              : 13.0,
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
