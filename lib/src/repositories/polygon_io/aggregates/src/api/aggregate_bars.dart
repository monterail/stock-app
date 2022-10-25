import 'package:dio/dio.dart';

typedef AggregateBars = Future<Response> Function(
  Dio, {
  required String stocksTicker,
  required int multiplier,
  required String timespan,
  required String from,
  required String to,
});

final AggregateBars aggregateBars = (
  Dio httpClient, {
  required String stocksTicker,
  required int multiplier,
  required String timespan,
  required String from,
  required String to,
}) =>
    httpClient.get(
      '/v2/aggs/ticker/$stocksTicker/range/$multiplier/$timespan/$from/$to',
    );
