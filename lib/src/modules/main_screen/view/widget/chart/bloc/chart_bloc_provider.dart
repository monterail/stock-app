import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocks/src/repositories/polygon_io/aggregates/aggregates_repository.dart';
import 'package:stocks/src/repositories/polygon_io/aggregates/src/api/aggregate_bars.dart';
import 'package:stocks/src/repositories/polygon_io/common/client.dart';
import 'package:stocks/src/repositories/polygon_io/reference/ticker_reference_repository.dart';

import 'chart_bloc.dart';

class ChartBlocProvider extends StatelessWidget {
  final Widget child;
  final TickerReference tickerReference;

  const ChartBlocProvider({
    super.key,
    required this.child,
    required this.tickerReference,
  });

  @override
  Widget build(BuildContext context) => RepositoryProvider(
        create: (context) => AggregatesRepository(
          httpClient: polygonClient,
          aggregateBars: aggregateBars,
        ),
        child: BlocProvider(
          create: (context) => ChartBloc(
            aggregatesRepository: context.read(),
            tickerReference: tickerReference,
          ),
          child: child,
        ),
      );
}
