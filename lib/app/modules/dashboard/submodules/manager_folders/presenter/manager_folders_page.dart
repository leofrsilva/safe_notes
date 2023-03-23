import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../presenter/reactive/i_reactive_list.dart';
import '../../../presenter/reactive/reactive_list.dart';
import 'manager_folders_controller.dart';
import 'widgets/ladder_folder_manager.dart';

class ManagerFoldersPage extends StatefulWidget {
  const ManagerFoldersPage({Key? key}) : super(key: key);

  @override
  State<ManagerFoldersPage> createState() => _ManagerFoldersPageState();
}

class _ManagerFoldersPageState extends State<ManagerFoldersPage> {
  late IReactiveList _reactiveList;
  late ManagerFoldersController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<ManagerFoldersController>();
    _reactiveList = _controller.reactiveList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Pastas'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 26),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _reactiveList as ReactiveList,
                builder: (context, child) {
                  return LadderFolderManager(
                    listFolders: _reactiveList.listFolder,
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                ),
                child: Divider(
                  thickness: 2.0,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => _controller.callAddSubFolderPage(
                        context,
                        _reactiveList.listFolder.first,
                      ),
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(
                          left: 14.0,
                          right: 14.0,
                          bottom: 5.0,
                        ),
                        child: Icon(
                          Icons.add_outlined,
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      label: Text(
                        'Criar Pasta',
                        style: TextStyle(
                          height: 1.5,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}
