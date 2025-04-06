import 'package:cyoap_core/grammar/analyser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final snackBarErrorProvider = StateNotifierProvider<SnackBarErrorNotifier, List<String>>((ref) {
  return SnackBarErrorNotifier();
});

class SnackBarErrorNotifier extends StateNotifier<List<String>> {
  SnackBarErrorNotifier() : super([]);

  void update() {
    state = [...Analyser().errorList];
  }

  void clear() {
    state = [];
    Analyser().clearError();
  }
}
