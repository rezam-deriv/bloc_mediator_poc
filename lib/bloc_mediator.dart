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

  void actionOnBlocsOfType<T extends BlocBase>(void Function(T) action) {
    blocs.where((element) => element is T).forEach((bloc) => action(bloc as T));
  }

  void onNewState(BlocBase bloc, dynamic state) {
    if (state is int && bloc is CubitA) {
      actionOnBlocsOfType<CubitB>((cubit) {
        cubit.onCubitAChange(state);
      });
    }

    if (state is int && bloc is CubitB) {
      actionOnBlocsOfType<CubitA>((cubit) {
        cubit.onCubitBChange(state);
      });
    }
  }
}
