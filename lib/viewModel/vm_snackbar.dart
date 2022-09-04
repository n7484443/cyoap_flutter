import 'package:cyoap_flutter/model/grammar/analyser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final snackBarErrorProvider = StateNotifierProvider<SnackBarErrorNotifier, List<String>>((ref) {
  return SnackBarErrorNotifier();
});

class SnackBarErrorNotifier extends StateNotifier<List<String>> {
  SnackBarErrorNotifier() : super([]);

  void update(){
    if(Analyser().errorList.isNotEmpty){
      state = [...state, ...Analyser().errorList];
      Analyser().clearError();
    }
  }

  void clear(){
    state = [];
    Analyser().clearError();
  }
}