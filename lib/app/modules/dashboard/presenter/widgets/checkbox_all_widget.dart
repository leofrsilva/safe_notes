import 'package:flutter/material.dart';

class CheckboxAllWidget extends StatelessWidget {
  final bool selected;
  final Function()? onTap;
  final Function(bool?)? onChanged;

  const CheckboxAllWidget({
    Key? key,
    this.onTap,
    this.onChanged,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 1.0,
              ),
              child: Text(
                'Todos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Checkbox(
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Theme.of(context).colorScheme.primary;
                }
                return Theme.of(context).colorScheme.secondary;
              }),
              side: MaterialStateBorderSide.resolveWith(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return null;
                }
                return BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1.25,
                );
              }),
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              value: selected,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
