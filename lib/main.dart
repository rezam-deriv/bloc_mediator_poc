import 'package:custom_bloc_provider/mediator_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitA extends Cubit<int> {
  CubitA() : super(0);

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);

  void onCubitBChange(int value) {
    print("this is CubitA: new value from CubitB : $value");
  }
}

class CubitB extends Cubit<int> {
  CubitB() : super(0);

  void increment() => emit(state + 1);

  void decrement() => emit(state - 1);

  void onCubitAChange(int value) {
    print("this is CubitB: new value from CubitA : $value");
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showA = false;
  bool showB = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: showA
                    ? MediatorBlocProvider<CubitA>(
                        create: (BuildContext context) {
                          return CubitA();
                        },
                        child: Builder(
                          builder: (context) {
                            return BlocBuilder<CubitA, int>(
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    TextButton(
                                      onPressed:
                                          BlocProvider.of<CubitA>(context)
                                              .decrement,
                                      child: Text("-"),
                                    ),
                                    Text(state.toString()),
                                    TextButton(
                                      onPressed:
                                          BlocProvider.of<CubitA>(context)
                                              .increment,
                                      child: Text("+"),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Container(),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    showA = !showA;
                  });
                },
                child: Text("toggle A"),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: showB
                    ? MediatorBlocProvider<CubitB>(
                        create: (BuildContext context) {
                          return CubitB();
                        },
                        child: Builder(
                          builder: (context) {
                            return BlocBuilder<CubitB, int>(
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    TextButton(
                                      onPressed:
                                          BlocProvider.of<CubitB>(context)
                                              .decrement,
                                      child: Text("-"),
                                    ),
                                    Text(state.toString()),
                                    TextButton(
                                      onPressed:
                                          BlocProvider.of<CubitB>(context)
                                              .increment,
                                      child: Text("+"),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Container(),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    showB = !showB;
                  });
                },
                child: Text("toggle B"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
