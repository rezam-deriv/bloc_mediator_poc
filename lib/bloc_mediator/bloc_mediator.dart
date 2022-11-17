import 'dart:async';

import 'package:custom_bloc_provider/cubits/market_info_cubit.dart';
import 'package:custom_bloc_provider/cubits/price_cubit.dart';
import 'package:custom_bloc_provider/cubits/symbol_cubit.dart';
import 'package:custom_bloc_provider/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocMediator {
  BlocMediator._internal();

  static final BlocMediator _instance = BlocMediator._internal();

  static BlocMediator get instance => _instance;

  final List<BlocBase> blocs = [];
  final Map<BlocBase, StreamSubscription> subscriptions = {};

  void addBloc(BlocBase bloc) {
    print("adding ${bloc.runtimeType}");
    blocs.add(bloc);
    subscriptions[bloc] =
        bloc.stream.listen((state) => onNewState(bloc, state));
    onNewState(bloc, bloc.state);
  }

  void removeBloc(BlocBase bloc) {
    print("removing ${bloc.runtimeType}");
    if (subscriptions.containsKey(bloc)) {
      subscriptions[bloc]!.cancel();
      subscriptions.remove(bloc);
    }
    if (blocs.contains(bloc)) {
      blocs.remove(bloc);
    }
  }

  void actionOnBlocsOfType<T extends BlocBase>(void Function(T) action) {
    blocs.where((element) => element is T).forEach((bloc) => action(bloc as T));
  }

  void onNewState(BlocBase bloc, dynamic state) {
    if (state is PriceState) {
      if (blocs.whereType<SymbolCubit>().isNotEmpty) {
        actionOnBlocsOfType<MarketInfoCubit>((cubit) {
          cubit.updateMarketInfo(
              state.value, blocs.whereType<SymbolCubit>().first.state.name);
        });
      }
    } else if (state is SymbolState) {
      if (blocs.whereType<PriceCubit>().isNotEmpty) {
        actionOnBlocsOfType<MarketInfoCubit>((cubit) {
          cubit.updateMarketInfo(
              blocs.whereType<PriceCubit>().first.state.value, state.name);
        });
      }
    }
  }
}
