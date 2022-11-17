import 'package:custom_bloc_provider/bloc_mediator/bloc_mediator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// This is exactly like [BlocProvider] but adds the bloc to Mediator when creating
/// and removes it when disposing.
class MediatorBlocProvider<T extends StateStreamableSource<Object?>>
    extends BlocProvider<T> {
  const MediatorBlocProvider({
    Key? key,
    required Create<T> create,
    Widget? child,
    bool lazy = true,
  })  : _create = create,
        _value = null,
        super(key: key, child: child, create: create, lazy: lazy);

  const MediatorBlocProvider.value({
    Key? key,
    required T value,
    Widget? child,
  })  : _value = value,
        _create = null,
        super.value(key: key, child: child, value: value);

  final Create<T>? _create;

  final T? _value;

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '$runtimeType used outside of MultiBlocProvider must specify a child',
    );
    final value = _value;
    return value != null
        ? InheritedProvider<T>.value(
            value: value,
            startListening: _startListening,
            lazy: lazy,
            child: child,
          )
        : InheritedProvider<T>(
            create: (BuildContext context) {
              T cubit = _create!(context);
              BlocMediator.instance.addBloc(cubit as BlocBase);
              return cubit;
            },
            dispose: (_, bloc) {
              BlocMediator.instance.removeBloc(bloc as BlocBase);
              bloc.close();
            },
            startListening: _startListening,
            child: child,
            lazy: lazy,
          );
  }

  static VoidCallback _startListening(
    InheritedContext<StateStreamable?> e,
    StateStreamable value,
  ) {
    final subscription = value.stream.listen(
      (dynamic _) => e.markNeedsNotifyDependents(),
    );
    return subscription.cancel;
  }
}
