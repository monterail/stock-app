import 'models/models.dart';
import 'models/timespan.dart';

abstract class IAggregatesRepository {
  Future<Iterable<Bar>> bars({
    required String stocksTicker,
    int multiplier = 1,
    Timespan timespan = Timespan.day,
    required DateTime from,
    required DateTime to,
  });
}
