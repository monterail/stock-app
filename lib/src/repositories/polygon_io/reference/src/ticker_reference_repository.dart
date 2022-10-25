import 'package:dio/dio.dart';
import 'package:stocks/src/repositories/polygon_io/common/polygon_parse_exception.dart';

import 'abstract_ticker_reference_repository.dart';
import 'api/search_by_name.dart';
import 'models/models.dart';

class TickerReferenceRepository implements ITickerReferenceRepository {
  final Dio _client;
  final SearchByName _searchByName;

  TickerReferenceRepository({
    required Dio httpClient,
    required SearchByName searchByName,
  })  : _client = httpClient,
        _searchByName = searchByName;

  @override
  Future<List<TickerReference>> searchByName(String query) async {
    final response = await _searchByName(_client, query);
    try {
      return response.data['results']
          .map<TickerReference>(
              (e) => TickerReference.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw PolygonResponseParseException(e.toString());
    }
  }
}
