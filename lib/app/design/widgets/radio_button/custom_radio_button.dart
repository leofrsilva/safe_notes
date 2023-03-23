import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

// ignore: must_be_immutable
class CustomRadioButton<T> extends StatelessWidget {
  final String field;
  final String textOption1;
  final T option1;
  final String textOption2;
  final T option2;
  T? initialValue;

  String? Function(T?)? validator;
  void Function(T?)? onSaved;

  CustomRadioButton({
    Key? key,
    this.onSaved,
    this.validator,
    this.initialValue,
    required this.field,
    required this.textOption1,
    required this.option1,
    required this.textOption2,
    required this.option2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            field,
            style: TextStyles.titleFieldStyle(context),
          ),
        ),
        FormField<T>(
            initialValue: initialValue,
            validator: validator,
            onSaved: onSaved,
            builder: (FormFieldState<T> state) {
              return Column(
                children: [
                  Row(
                    children: [
                      Radio<T>(
                        value: option1,
                        groupValue: state.value,
                        onChanged: (T? val) {
                          state.didChange(val);
                          initialValue = val;
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          state.didChange(option1);
                          initialValue = option1;
                        },
                        child: Text(
                          textOption1,
                          style: TextStyles.fieldStyle(context),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<T>(
                        value: option2,
                        groupValue: state.value,
                        onChanged: (T? val) {
                          state.didChange(val);
                          initialValue = val;
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          state.didChange(option2);
                          initialValue = option2;
                        },
                        child: Text(
                          textOption2,
                          style: TextStyles.fieldStyle(context),
                        ),
                      ),
                    ],
                  ),
                  if (state.hasError)
                    Container(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        " ${state.errorText}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              );
            }),
      ],
    );
  }
}
