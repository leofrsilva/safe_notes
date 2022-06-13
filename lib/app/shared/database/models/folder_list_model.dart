import 'folder_model.dart';

class FolderListModel {
  final FolderModel current;
  List<FolderListModel> childrens = [];

  FolderListModel({
    required this.current,
  });
}
