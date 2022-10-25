part of 'ticker_search_bloc.dart';

abstract class TickerSearchEvent extends Equatable {
  const TickerSearchEvent();

  @override
  List<Object?> get props => [];
}

@autoequalMixin
class UpdateQuery extends TickerSearchEvent with _$UpdateQueryAutoequalMixin {
  final String query;
  UpdateQuery(this.query);
}

@autoequalMixin
class PickTicker extends TickerSearchEvent with _$UpdateQueryAutoequalMixin {
  final TickerReference ticker;
  PickTicker(this.ticker);
}
