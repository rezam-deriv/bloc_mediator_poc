# Intention
In this poc, I have tried to introduce a method for comunicatins between blocs.

# Idea
I used mediator design pattern where instead of listening blocs to each other we have a Mediator class witch keeps refrence to all blocs and handle comunications between them.

Also for handling blocs life cycle and having multi bloc of same type in one Application (instead of using `id` for recognize blocs) I used [BlocProvider] witch handles blocs life cycle and dispose blocs when needed. and every subtree of widgets can have its own bloc of a specific type. and we can access blocs using context traverse. like 'BlocProvider.of<T>(context)'

# MediatorBlocProvider
[MediatorBlocProvider] is exactly like [BlocProvider] but adds the bloc to Mediator when creating and removes it when disposing.

# process of converting [BlocProvider] to [MediatorBlocProvider]
just some minor changes neeeded :)
```dart
            create: _create,
            dispose: (_, bloc) => bloc.close(),
```
to 
```dart
            create: (BuildContext context) {
              T cubit = _create!(context);
              BlocMediator.instance.addBloc(cubit as BlocBase);
              return cubit;
            },
            dispose: (_, bloc) {
              BlocMediator.instance.removeBloc(bloc as BlocBase);
              bloc.close();
            },
```

# Pros and Cons

## Pros
    - sepratin of blocs (since the commnunicatin is handling in mediator)
    - simple and undrestandable logic
    - more deterministic behavier
    - handling bloc.dispos automaticly
    - no need to handle blocs `id` in case of having multi blocs of same type
    

## Cons
    - onNewState function may becomes very large.
    - in case of having more than one bloc of same type in a widgetsubtree, only we have access to nearest bloc of that type

# Suggestion
Instead of having a large onNewState in mediator we can define how a cubit should deal with a new state using passing a callBack to [MediatorBlocProvider] while providing the bloc.