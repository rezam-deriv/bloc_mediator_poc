## Idea

This poc uses the Mediator design pattern to heandle connection between blocs.
Instead of blocs, listening to each other, we have a Mediator class that keeps a reference to all blocs and handles communications between them.

Also for handling the bloc's life cycle and having multi blocs of the same type in one Application (instead of using `id` to recognize blocs) I used [BlocProvider] which handles the bloc's life cycle. and disposes the blocs when needed. so every subtree of widgets can have its bloc of a specific type. and we can access blocs using context traverse. like `BlocProvider.of<T>(context)`

## MediatorBlocProvider

[MediatorBlocProvider] is exactly like [BlocProvider] but adds the bloc to Mediator while creating. and removes it when disposing.

## process of converting [BlocProvider] to [MediatorBlocProvider]

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

## Pros and Cons

### Pros
- separation of blocs (since the communication is handled by the Mediator)
- simple and understandable logic
- more deterministic behavior
- handling `bloc.close` and removing the bloc automatically
- no need to handle blocs `id` in case of having multi blocs of the same type

### Cons
- onNewState function may become very large.
- in case of having more than one bloc of the same type in a widget subtree, only we have access to the nearest bloc of that type

## Suggestion

Instead of having a large onNewState in the Mediator, we can define how a cubit should deal with a new state using passing a callBack to [MediatorBlocProvider] while providing the bloc.