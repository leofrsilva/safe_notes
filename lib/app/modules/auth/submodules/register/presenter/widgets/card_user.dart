import 'package:flutter/material.dart';
import 'package:safe_notes/app/shared/database/models/usuario_model.dart';

class CardUser extends StatelessWidget {
  final Function()? onTap;
  final UsuarioModel model;
  const CardUser({
    Key? key,
    this.onTap,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: ListTile(
          title: Text(model.name),
        ),
      ),
    );
  }
}
