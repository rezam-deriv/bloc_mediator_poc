import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class SymbolState {
  final String name;

  SymbolState(this.name);
}

class SymbolCubit extends Cubit<SymbolState> {
  SymbolCubit() : super(SymbolState("initial"));

  String generateRandomString() {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(5, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  void next() => emit(SymbolState(generateRandomString()));
}
