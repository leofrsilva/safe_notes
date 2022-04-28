import 'package:flutter/material.dart';
import 'package:safe_notes/app/design/common/common.dart';

class ButtonManageFolders extends StatelessWidget {
  final Function() onTap;
  const ButtonManageFolders({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // color: ColorPalettes.secondy,
          color: ColorPalettes.blueGrey.withOpacity(0.25),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: Text(
          'Gerenciar pasta',
          style: TextStyle(
            fontFamily: 'JosefinSans',
            color: ColorPalettes.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
