part of 'chart_bloc.dart';

abstract class ChartEvent extends Equatable {
  const ChartEvent();

  @override
  List<Object?> get props => [];
}

@autoequalMixin
class PickTicker extends ChartEvent with _$PickTickerAutoequalMixin {
  final TickerReference tickerReference;
  PickTicker(this.tickerReference);
}

@autoequalMixin
class PickTimespan extends ChartEvent with _$PickTickerAutoequalMixin {
  final TimespanSettings timespanSettings;

  PickTimespan(this.timespanSettings);
}

@autoequalMixin
class FetchBars extends ChartEvent with _$PickTickerAutoequalMixin {
  final TickerReference tickerReference;
  final TimespanSettings timespanSettings;

  FetchBars(this.tickerReference, this.timespanSettings);
}
