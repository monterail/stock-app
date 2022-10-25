import 'package:dio/dio.dart';

typedef SearchByName = Future<Response> Function(Dio, String query);

final SearchByName searchByName = (
  Dio httpClient,
  String query,
) =>
    httpClient.get(
      '/v3/reference/tickers',
      queryParameters: {
        'market': 'stocks',
        'search': query,
      },
    );
