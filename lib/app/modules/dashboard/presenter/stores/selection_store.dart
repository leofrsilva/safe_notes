import 'package:rx_notifier/rx_notifier.dart';
import 'package:safe_notes/app/shared/database/models/note_model.dart';
import 'package:safe_notes/app/shared/database/views/folder_qtd_child_view.dart';

class SelectionStore {
  final _selectable = RxNotifier<bool>(false);
  RxNotifier<bool> get selectable => _selectable;

  toggleSelectable(bool newValue) {
    if (newValue != selectable.value) {
      selectable.value = newValue;
    }
  }

  //* --------------------------------------------------------------------
  //* -- Folders
  //* --------------------------------------------------------------------
  final _selectedFolderItems = RxNotifier<List<FolderQtdChildView>>([]);
  RxNotifier<List<FolderQtdChildView>> get selectedFolderItems =>
      _selectedFolderItems;

  bool checkQuantityFolderSelected(int qtd) {
    return _selectedFolderItems.value.length == qtd;
  }

  addAllItemFolderToSelection(List<FolderQtdChildView> folders) {
    _selectedFolderItems.value.clear();
    _selectedFolderItems.value.addAll(folders);
    var selecteds = _selectedFolderItems.value.toList();

    _selectedFolderItems.value = selecteds;
  }

  addItemFolderToSelection(FolderQtdChildView folder) {
    if (!_selectedFolderItems.value.contains(folder)) {
      _selectedFolderItems.value.add(folder);
      var selecteds = _selectedFolderItems.value.toList();

      _selectedFolderItems.value.clear();
      _selectedFolderItems.value = selecteds;
    }
  }

  removeItemFolderSelection(FolderQtdChildView folder) {
    _selectedFolderItems.value.remove(folder);
    var selecteds = _selectedFolderItems.value.toList();

    _selectedFolderItems.value.clear();
    _selectedFolderItems.value = selecteds;
  }

  clearFolder() {
    _selectedFolderItems.value = [];
  }

  //* --------------------------------------------------------------------
  //* -- Notes
  //* --------------------------------------------------------------------
  final _selectedNoteItems = RxNotifier<List<NoteModel>>([]);
  RxNotifier<List<NoteModel>> get selectedNoteItems => _selectedNoteItems;

  bool checkQuantityNoteSelected(int qtd) {
    return _selectedNoteItems.value.length == qtd;
  }

  addAllItemNoteToSelection(List<NoteModel> notes) {
    _selectedNoteItems.value.clear();
    _selectedNoteItems.value.addAll(notes);
    var selecteds = _selectedNoteItems.value.toList();

    _selectedNoteItems.value = selecteds;
  }

  addItemNoteToSelection(NoteModel note) {
    if (!_selectedNoteItems.value.contains(note)) {
      _selectedNoteItems.value.add(note);
      var selecteds = _selectedNoteItems.value.toList();

      _selectedNoteItems.value.clear();
      _selectedNoteItems.value = selecteds;
    }
  }

  removeItemNoteSelection(NoteModel note) {
    _selectedNoteItems.value.remove(note);
    var selecteds = _selectedNoteItems.value.toList();

    _selectedNoteItems.value.clear();
    _selectedNoteItems.value = selecteds;
  }

  clearNotes() {
    _selectedNoteItems.value = [];
  }
}
