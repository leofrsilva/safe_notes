import 'package:flutter/foundation.dart';

class ExpandedStore {
  final isExpanded = ValueNotifier<bool>(false);

  bool get expanded =>  isExpanded.value;

    void _setExpansion(bool shouldBeExpanded) {
    if (shouldBeExpanded != isExpanded.value) {
      isExpanded.value = shouldBeExpanded;      
    }
  }

  void toggleExpansion() {
    _setExpansion(!isExpanded.value);
  }
}
