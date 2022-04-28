import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/styles/color_palettes.dart';
import 'package:safe_notes/app/design/widgets/widgets.dart';

// ignore: must_be_immutable
class InputModeDark extends StatelessWidget {
  bool isDark;
  final Function(bool)? onTap;

  InputModeDark({
    Key? key,
    this.onTap,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool? result = await showDialog<bool>(
          context: context,
          builder: (context) {
            bool? optionSelected;
            final _formKey = GlobalKey<FormState>();

            return Form(
              key: _formKey,
              child: AlertDialog(
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
                content: CustomRadioButton<bool>(
                  field: 'Escolha um tema',
                  textOption1: 'Claro',
                  option1: false,
                  textOption2: 'Escuro',
                  option2: true,
                  initialValue: isDark,
                  onSaved: (value) {
                    optionSelected = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: const Text('CANCELAR'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      _formKey.currentState?.save();
                      if (optionSelected == isDark) {
                        isDark = optionSelected ?? isDark;
                        Navigator.pop(context);
                      } else {
                        isDark = optionSelected ?? isDark;
                        Navigator.pop(context, optionSelected);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
        if (result != null && onTap != null) {
          onTap!(result);
        }
      },
      child: Row(
        children: [
          Container(
            height: 50,
            width: 55,
            alignment: Alignment.center,
            child: Icon(
              Icons.brightness_medium,
              color: ColorPalettes.blueGrey,
            ),
          ),
          Column(
            children: [
              const Text(
                'Tema',
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'JosefinSans',
                ),
              ),
              const SizedBox(height: 5),
              Text(
                isDark ? 'Escuro' : 'Claro',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'JosefinSans',
                  color: ColorPalettes.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
