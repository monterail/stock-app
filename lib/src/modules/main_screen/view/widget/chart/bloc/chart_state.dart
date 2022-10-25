part of 'chart_bloc.dart';

enum ChartLoadingState { idle, busy, error, done }

enum ChartError {
  none,
  connectionError,
  serverError,
  parsingError,
  unknownError,
}

@CopyWith()
@autoequalMixin
class ChartState extends Equatable with _$ChartStateAutoequalMixin {
  final ChartLoadingState loadingState;
  final ChartError error;
  final Iterable<Bar> bars;
  final TimespanSettings timespanSettings;
  final TickerReference tickerReference;

  const ChartState({
    this.loadingState = ChartLoadingState.idle,
    this.error = ChartError.none,
    this.bars = const [],
    required this.timespanSettings,
    required this.tickerReference,
  });
}
