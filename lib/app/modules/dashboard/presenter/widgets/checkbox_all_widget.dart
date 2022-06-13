import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/style/styles.dart';

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
              ),
              child: Text(
                'Todos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorPalettes.grey,
                  // color: ColorPalettes.black,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.topCenter,
            child: Checkbox(
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return ColorPalettes.secondy;
                }
                return ColorPalettes.grey;
              }),
              side: MaterialStateBorderSide.resolveWith(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return null;
                }
                return const BorderSide(
                  color: Colors.grey,
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
