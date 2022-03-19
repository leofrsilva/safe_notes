import 'package:flutter/material.dart';

import '../../common/common.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final String title;
  final bool isPass;
  final Function(String?)? onSaved;
  String? Function(String?)? validator;

  CustomTextField({
    Key? key,
    required this.title,
    this.isPass = false,
    this.onSaved,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with TickerProviderStateMixin {
  final isFocus = ValueNotifier<bool>(false);
  late final FocusNode focusNode;
  String currentText = '';
  late bool isNotVisible;

  @override
  void initState() {
    super.initState();
    if (widget.isPass) {
      isNotVisible = true;
    } else {
      isNotVisible = false;
    }

    focusNode = FocusNode();
    focusNode.addListener(() {
      if (FocusScope.of(context).focusedChild == focusNode) {
        isFocus.value = true;
      } else {
        if (currentText.isEmpty) {
          isFocus.value = false;
        } else {
          isFocus.value = true;
        }
      }
    });
  }

  @override
  void dispose() {
    isFocus.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              height: 45,
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
              child: TextFormField(
                focusNode: focusNode,
                obscureText: isNotVisible,
                onSaved: widget.onSaved,
                validator: widget.validator,
                cursorColor: Theme.of(context).primaryColor,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'JosefinSans',
                  color: ColorPalettes.greyDark,
                ),
                onChanged: (text) => currentText = text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorPalettes.whiteSemiTransparent,
                  hoverColor: ColorPalettes.whiteSemiTransparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: widget.isPass
                      ? isNotVisible
                          ? GestureDetector(
                              child: const Icon(Icons.visibility_outlined),
                              onTap: () {
                                setState(() => isNotVisible = false);
                              },
                            )
                          : GestureDetector(
                              child: const Icon(Icons.visibility_off_outlined),
                              onTap: () {
                                setState(() => isNotVisible = true);
                              },
                            )
                      : null,
                ),
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isFocus,
            builder: (context, value, child) {
              return AnimatedPositionedDirectional(
                duration: const Duration(milliseconds: 400),
                curve: Curves.linearToEaseOut,
                start: value ? 2.0 : 7.0,
                bottom: value ? 50.0 : 13.0,
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'JosefinSans',
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
