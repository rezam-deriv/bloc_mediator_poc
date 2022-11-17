import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

class PriceState {
  final int value;

  PriceState(this.value);
}

class PriceCubit extends Cubit<PriceState> {
  PriceCubit() : super(PriceState(0));

  int generateRandomInteger() {
    var r = Random();
    return r.nextInt(10000);
  }

  void next() => emit(PriceState(generateRandomInteger()));
}
