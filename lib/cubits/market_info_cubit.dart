import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MarketInfoState {}

class EmptyMarketInfoState extends MarketInfoState {}

class LoadedMarketInfoState extends MarketInfoState {
  final int price;
  final String symbol;
  LoadedMarketInfoState(this.price, this.symbol);
}

class MarketInfoCubit extends Cubit<MarketInfoState> {
  MarketInfoCubit() : super(EmptyMarketInfoState());

  void onMarketInfoUpdate(int price, String symbol) {
    emit(LoadedMarketInfoState(price, symbol));
  }
}
