import 'package:collection/collection.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocks/src/modules/main_screen/bloc/ticker_search_bloc.dart'
    hide PickTicker;
import 'package:stocks/src/modules/main_screen/view/widget/chart/bloc/chart_bloc.dart';
import 'package:stocks/src/modules/main_screen/view/widget/chart/bloc/chart_bloc_provider.dart';
import 'package:stocks/src/repositories/polygon_io/aggregates/src/models/timespan.dart';
import 'package:stocks/src/repositories/polygon_io/reference/ticker_reference_repository.dart';

class Chart extends StatelessWidget {
  final TickerReference tickerReference;

  const Chart({super.key, required this.tickerReference});

  @override
  Widget build(BuildContext context) => ChartBlocProvider(
        tickerReference: tickerReference,
        child: const _Chart(),
      );
}

class _Chart extends StatelessWidget {
  const _Chart();

  static const timespans = [
    TimespanSettings(
      timespan: Timespan.hour,
      multiplier: 1,
      duration: Duration(days: 1),
    ),
    TimespanSettings(
      timespan: Timespan.hour,
      multiplier: 12,
      duration: Duration(days: 7),
    ),
    TimespanSettings(
      timespan: Timespan.day,
      multiplier: 1,
      duration: Duration(days: 30),
    ),
    TimespanSettings(
      timespan: Timespan.day,
      multiplier: 3,
      duration: Duration(days: 90),
    ),
    TimespanSettings(
      timespan: Timespan.month,
      multiplier: 1,
      duration: Duration(days: 365),
    ),
    TimespanSettings(
      timespan: Timespan.quarter,
      multiplier: 1,
      duration: Duration(days: 1825),
    ),
  ];

  @override
  Widget build(BuildContext context) => BlocListener<ChartBloc, ChartState>(
        listenWhen: (previous, current) => previous.error != current.error,
        listener: (context, state) {
          if (state.error != ChartError.none) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('An error occurred: ${state.error}'),
                backgroundColor: Colors.red.shade900,
              ),
            );
          }
        },
        child: BlocListener<TickerSearchBloc, TickerSearchState>(
          listenWhen: (previous, current) =>
              previous.pickedTicker != current.pickedTicker,
          listener: (context, state) {
            if (state.pickedTicker != null) {
              context.read<ChartBloc>().add(PickTicker(state.pickedTicker!));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(child: TickerChart()),
              TickerDetails(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: TimespanOptions(),
              ),
            ],
          ),
        ),
      );
}

class TimespanOption extends StatelessWidget {
  final bool isSelected;
  final TimespanSettings settings;
  final void Function()? onTap;

  const TimespanOption({
    super.key,
    this.isSelected = false,
    required this.settings,
    this.onTap,
  });

  String get shortRepresentation {
    if (settings.duration.inDays < 7) {
      return '${settings.duration.inDays}D';
    }
    if (settings.duration.inDays < 30) {
      return '${(settings.duration.inDays / 7).toStringAsFixed(0)}W';
    }
    if (settings.duration.inDays < 365) {
      return '${(settings.duration.inDays / 30).toStringAsFixed(0)}M';
    }
    if (settings.duration.inDays >= 365) {
      return '${(settings.duration.inDays / 365).toStringAsFixed(0)}Y';
    }

    return settings.duration.inDays.toString();
  }

  @override
  Widget build(BuildContext context) => Semantics(
        selected: isSelected,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Chip(
            label: Text(shortRepresentation),
            backgroundColor: isSelected
                ? Theme.of(context).colorScheme.inversePrimary
                : null,
          ),
        ),
      );
}

class TickerChart extends StatelessWidget {
  const TickerChart({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ChartBloc, ChartState>(
        buildWhen: (previous, current) => !listEquals(
          previous.bars.toList(),
          current.bars.toList(),
        ),
        builder: (context, state) => DChartLine(
          data: [
            {
              'id': 'primary',
              'data': state.bars
                  .map<Map<String, num>>((e) => {
                        'domain': e.timestamp -
                            (state.bars.firstOrNull?.timestamp ?? 0),
                        'measure': e.closePrice,
                      })
                  .toList()
            }
          ],
          lineColor: (_, __, ___) => Theme.of(context).colorScheme.secondary,
        ),
      );
}

class TimespanOptions extends StatelessWidget {
  const TimespanOptions({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ChartBloc, ChartState>(
        buildWhen: (previous, current) =>
            previous.timespanSettings != current.timespanSettings,
        builder: (context, state) => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _Chart.timespans
              .map<Widget>((e) => TimespanOption(
                    settings: e,
                    isSelected: state.timespanSettings == e,
                    onTap: () => context.read<ChartBloc>().add(PickTimespan(e)),
                  ))
              .toList(),
        ),
      );
}

class TickerDetails extends StatelessWidget {
  const TickerDetails({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ChartBloc, ChartState>(
        builder: (context, state) {
          return Card(
            child: ListTile(
              title: Text(state.tickerReference.name),
              subtitle: Text(state.tickerReference.ticker),
            ),
          );
        },
      );
}
