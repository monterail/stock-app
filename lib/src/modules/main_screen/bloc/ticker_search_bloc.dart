import 'dart:async';

import 'package:autoequal/autoequal.dart';
import 'package:bloc_event_transformers/bloc_event_transformers.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocks/src/repositories/polygon_io/common/polygon_parse_exception.dart';
import 'package:stocks/src/repositories/polygon_io/reference/ticker_reference_repository.dart';
part 'ticker_search_bloc.g.dart';
part 'ticker_search_event.dart';
part 'ticker_search_state.dart';

class TickerSearchBloc extends Bloc<TickerSearchEvent, TickerSearchState> {
  final TickerReferenceRepository _tickerReferenceRepository;

  TickerSearchBloc({
    required TickerReferenceRepository tickerReferenceRepository,
    Duration queryDebounceDuration = const Duration(seconds: 1),
  })  : _tickerReferenceRepository = tickerReferenceRepository,
        super(const TickerSearchState()) {
    on<UpdateQuery>(
      _handleUpdateQuery,
      transformer: debounce(queryDebounceDuration),
    );
    on<PickTicker>(_handlePickTicker);
  }

  FutureOr<void> _handleUpdateQuery(
    UpdateQuery event,
    Emitter<TickerSearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(state.copyWith(queryResults: const []));
      return;
    }

    emit(state.copyWith(loadingState: TickerSearchLoadingState.busy));
    try {
      final result = await _tickerReferenceRepository.searchByName(event.query);
      emit(state.copyWith(
        queryResults: result,
        loadingState: TickerSearchLoadingState.done,
      ));
    } on DioError catch (e) {
      emit(
        state.copyWith(
          queryResults: const [],
          loadingState: TickerSearchLoadingState.error,
          searchError: e.type == DioErrorType.response
              ? TickerSearchError.serverError
              : TickerSearchError.connectionError,
        ),
      );
    } on PolygonResponseParseException {
      emit(
        state.copyWith(
          queryResults: const [],
          loadingState: TickerSearchLoadingState.error,
          searchError: TickerSearchError.parsingError,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          queryResults: const [],
          loadingState: TickerSearchLoadingState.error,
          searchError: TickerSearchError.unknownError,
        ),
      );
    }
  }

  FutureOr<void> _handlePickTicker(
    PickTicker event,
    Emitter<TickerSearchState> emit,
  ) {
    emit(state.copyWith(pickedTicker: event.ticker));
  }
}
