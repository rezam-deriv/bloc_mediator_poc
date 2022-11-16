import 'dart:async';

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

  List<T> getBlocsOfType<T extends BlocBase>() {
    return blocs.where((element) => element is T).map((e) => e as T).toList();
  }

  void onNewState(BlocBase bloc, dynamic state) {
    if (state is int && bloc is CubitA) {
      getBlocsOfType<CubitB>().forEach((cubit) {
        cubit.onCubitAChange(state);
      });
    }

    if (state is int && bloc is CubitB) {
      getBlocsOfType<CubitA>().forEach((cubit) {
        cubit.onCubitBChange(state);
      });
    }
  }
}
