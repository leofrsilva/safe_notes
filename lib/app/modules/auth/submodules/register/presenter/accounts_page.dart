import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safe_notes/app/design/common/common.dart';

import 'package:safe_notes/app/shared/database/models/usuario_model.dart';
import 'widgets/card_add.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({Key? key}) : super(key: key);

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: Sizes.height(context) * 0.15,
            width: Sizes.width(context),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Modular.to.navigate('/auth/getin/');
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<UsuarioModel>>(
              future: null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done ||
                    snapshot.connectionState == ConnectionState.active) {
                  List<UsuarioModel> listUserModel = [];
                  if (snapshot.hasData) {
                    listUserModel = snapshot.data!;
                  }
                  return ListView.builder(
                    itemCount: listUserModel.length + 1,
                    itemBuilder: (context, index) {
                      if (index == listUserModel.length + 1) {
                        return CardAdd(
                          onTap: () {
                            Modular.to.navigate('/');
                          },
                        );
                      }
                      return const Card(
                        child: Text(''),
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
