import 'models/models.dart';

abstract class ITickerReferenceRepository {
  Future<Iterable<TickerReference>> searchByName(String query);
}
