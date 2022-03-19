import 'package:flutter/material.dart';

class CardAdd extends StatelessWidget {
  final Function()? onTap;
  const CardAdd({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Card(
        child: ListTile(
          title: Text('Adicionar Conta'),
        ),
      ),
    );
  }
}
