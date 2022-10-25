class PolygonResponseParseException implements Exception {
  final String cause;

  PolygonResponseParseException(this.cause);

  @override
  String toString() => 'PolygonResponseParseException(cause: $cause)';
}
