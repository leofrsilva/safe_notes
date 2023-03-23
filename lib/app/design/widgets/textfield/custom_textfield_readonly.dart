import 'package:flutter/material.dart';

import '../../common/common.dart';

class CustomTextFieldReadOnly extends StatelessWidget {
  final String title;
  final String initialField;

  const CustomTextFieldReadOnly({
    Key? key,
    required this.title,
    required this.initialField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(top: 14.0, start: 8.0),
              child: Text(title, style: TextStyles.titleFieldStyle(context)),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                height: 45,
                padding: const EdgeInsetsDirectional.only(
                  start: 8.0,
                ),
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  initialField,
                  style: TextStyles.fieldStyle(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
