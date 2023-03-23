import 'package:flutter/material.dart';

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
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: Text(
          'Gerenciar pasta',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).colorScheme.inverseSurface
                : Theme.of(context).colorScheme.onInverseSurface,
          ),
        ),
      ),
    );
  }
}
