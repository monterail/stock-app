import 'package:dio/dio.dart';
import 'package:stocks/src/repositories/polygon_io/aggregates/src/models/timespan.dart';
import 'package:stocks/src/repositories/polygon_io/common/polygon_parse_exception.dart';

import 'abstract_aggregates_repository.dart';
import 'api/aggregate_bars.dart';
import 'models/models.dart';

class AggregatesRepository implements IAggregatesRepository {
  final Dio _client;
  final AggregateBars _aggregateBars;

  AggregatesRepository({
    required Dio httpClient,
    required AggregateBars aggregateBars,
  })  : _client = httpClient,
        _aggregateBars = aggregateBars;

  @override
  Future<List<Bar>> bars({
    required String stocksTicker,
    int multiplier = 1,
    Timespan timespan = Timespan.day,
    required DateTime from,
    required DateTime to,
  }) async {
    assert(from.isBefore(to));
    assert(multiplier > 0);

    final response = await _aggregateBars(
      _client,
      stocksTicker: stocksTicker,
      multiplier: multiplier,
      timespan: timespan.value,
      from: from.dateAsText,
      to: to.dateAsText,
    );
    try {
      return response.data['results']
          .map<Bar>((e) => Bar.fromJson(
                e as Map<String, dynamic>,
              ))
          .toList();
    } catch (e) {
      throw PolygonResponseParseException(e.toString());
    }
  }
}

extension on DateTime {
  String get dateAsText => toIso8601String().substring(0, 10);
}
