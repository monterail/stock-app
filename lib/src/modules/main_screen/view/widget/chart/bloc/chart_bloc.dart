import 'dart:async';

import 'package:autoequal/autoequal.dart';
import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocks/src/repositories/polygon_io/aggregates/aggregates_repository.dart';
import 'package:stocks/src/repositories/polygon_io/aggregates/src/models/timespan.dart';
import 'package:stocks/src/repositories/polygon_io/common/polygon_parse_exception.dart';
import 'package:stocks/src/repositories/polygon_io/reference/ticker_reference_repository.dart';

part 'chart_bloc.g.dart';
part 'chart_event.dart';
part 'chart_state.dart';
part 'utils.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  final AggregatesRepository _aggregatesRepository;

  ChartBloc({
    required AggregatesRepository aggregatesRepository,
    TimespanSettings initialTimespanSettings = const TimespanSettings(
      duration: Duration(days: 1),
      multiplier: 1,
      timespan: Timespan.hour,
    ),
    required TickerReference tickerReference,
    Duration barFetchingThrottleDuration = const Duration(seconds: 1),
  })  : _aggregatesRepository = aggregatesRepository,
        super(
          ChartState(
            timespanSettings: initialTimespanSettings,
            tickerReference: tickerReference,
          ),
        ) {
    on<PickTicker>(_handlePickTicker);
    on<PickTimespan>(_handlePickTimespan);
    on<FetchBars>(
      _fetchBars,
      transformer: throttle(
        barFetchingThrottleDuration,
        trailing: true,
        leading: false,
      ),
    );
  }

  FutureOr<void> _handlePickTicker(
    PickTicker event,
    Emitter<ChartState> emit,
  ) async {
    emit(state.copyWith(tickerReference: event.tickerReference));
    add(FetchBars(state.tickerReference, state.timespanSettings));
  }

  FutureOr<void> _handlePickTimespan(
    PickTimespan event,
    Emitter<ChartState> emit,
  ) async {
    emit(state.copyWith(timespanSettings: event.timespanSettings));
    add(FetchBars(state.tickerReference, state.timespanSettings));
  }

  Future<void> _fetchBars(event, Emitter<ChartState> emit) async {
    emit(state.copyWith(loadingState: ChartLoadingState.busy));
    try {
      final to = DateTime.now();
      final result = await _aggregatesRepository.bars(
        stocksTicker: state.tickerReference.ticker,
        from: to.subtract(state.timespanSettings.duration),
        to: to,
        multiplier: state.timespanSettings.multiplier,
        timespan: state.timespanSettings.timespan,
      );
      emit(state.copyWith(
        bars: result,
        loadingState: ChartLoadingState.done,
      ));
    } on DioError catch (e) {
      emit(
        state.copyWith(
          loadingState: ChartLoadingState.error,
          error: e.type == DioErrorType.response
              ? ChartError.serverError
              : ChartError.connectionError,
        ),
      );
    } on PolygonResponseParseException {
      emit(
        state.copyWith(
          loadingState: ChartLoadingState.error,
          error: ChartError.parsingError,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loadingState: ChartLoadingState.error,
          error: ChartError.unknownError,
        ),
      );
    }
  }
}
