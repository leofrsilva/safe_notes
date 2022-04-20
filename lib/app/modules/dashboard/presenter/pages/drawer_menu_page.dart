import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';

import '../dashboard_controller.dart';

class DrawerMenuPage extends StatelessWidget {
  DrawerMenuPage({Key? key}) : super(key: key);

  final drawerController = Modular.get<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Sizes.width(context),
        height: Sizes.height(context),
        color: Theme.of(context).backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: const Text('Sair'),
                onTap: () {
                  drawerController.logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
