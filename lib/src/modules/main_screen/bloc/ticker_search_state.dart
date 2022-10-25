part of 'ticker_search_bloc.dart';

enum TickerSearchLoadingState { idle, busy, error, done }

enum TickerSearchError {
  none,
  connectionError,
  serverError,
  parsingError,
  unknownError,
}

@CopyWith()
@autoequalMixin
class TickerSearchState extends Equatable
    with _$TickerSearchStateAutoequalMixin {
  final TickerReference? pickedTicker;
  final Iterable<TickerReference> queryResults;
  final TickerSearchLoadingState loadingState;
  final TickerSearchError searchError;

  const TickerSearchState({
    this.pickedTicker,
    this.loadingState = TickerSearchLoadingState.idle,
    this.searchError = TickerSearchError.none,
    this.queryResults = const [],
  });
}
