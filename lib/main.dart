import 'package:custom_bloc_provider/cubits/market_info_cubit.dart';
import 'package:custom_bloc_provider/cubits/price_cubit.dart';
import 'package:custom_bloc_provider/cubits/symbol_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_mediator/mediator_bloc_provider.dart';

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
  bool showSymbol = false;
  bool showPrice = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: showSymbol
                    ? MediatorBlocProvider<SymbolCubit>(
                        create: (BuildContext context) {
                          return SymbolCubit();
                        },
                        child: Builder(
                          builder: (context) {
                            return BlocBuilder<SymbolCubit, SymbolState>(
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    Text(state.name),
                                    TextButton(
                                      onPressed:
                                          BlocProvider.of<SymbolCubit>(context)
                                              .next,
                                      child: Text("next"),
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
                    showSymbol = !showSymbol;
                  });
                },
                child: Text("toggle Symbol"),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: showPrice
                    ? MediatorBlocProvider<PriceCubit>(
                        create: (BuildContext context) {
                          return PriceCubit();
                        },
                        child: Builder(
                          builder: (context) {
                            return BlocBuilder<PriceCubit, PriceState>(
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    Text(state.value.toString()),
                                    TextButton(
                                      onPressed:
                                          BlocProvider.of<PriceCubit>(context)
                                              .next,
                                      child: Text("next"),
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
                    showPrice = !showPrice;
                  });
                },
                child: Text("toggle Price"),
              )
            ],
          ),
          MediatorBlocProvider<MarketInfoCubit>(
            create: (BuildContext context) {
              return MarketInfoCubit();
            },
            child: Builder(
              builder: (context) {
                return BlocBuilder<MarketInfoCubit, MarketInfoState>(
                  builder: (context, state) {
                    if (state is LoadedMarketInfoState) {
                      return Text(state.symbol + " " + state.price.toString());
                    }
                    return Text("empty market");
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
