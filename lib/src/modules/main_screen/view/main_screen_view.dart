import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocks/src/modules/main_screen/bloc/ticker_search_bloc.dart';
import 'package:stocks/src/modules/main_screen/bloc/ticker_search_bloc_provider.dart';

import 'widget/chart/widget/chart.dart';
import 'widget/search_field/widget/search_field.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const TickerSearchBlocProvider(child: _MainScreen());
}

class _MainScreen extends StatelessWidget {
  const _MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocListener<TickerSearchBloc, TickerSearchState>(
        listenWhen: (previous, current) =>
            previous.searchError != current.searchError,
        listener: (context, state) {
          if (state.searchError != TickerSearchError.none) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('An error occurred: ${state.searchError}'),
                backgroundColor: Colors.red.shade900,
              ),
            );
          }
        },
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AnimatedSize(
                    duration: Duration(milliseconds: 700),
                    alignment: Alignment.topCenter,
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: SearchField(),
                  ),
                  BlocBuilder<TickerSearchBloc, TickerSearchState>(
                    builder: (context, state) => state.pickedTicker != null
                        ? Expanded(
                            child: Chart(tickerReference: state.pickedTicker!))
                        : Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
