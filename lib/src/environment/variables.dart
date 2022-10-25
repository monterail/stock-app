class EnvironmentVariables {
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Unflavored app name',
  );
  static const String appSuffix = String.fromEnvironment('APP_SUFFIX');
  static const String polygonApiBaseUrl =
      String.fromEnvironment('APP_POLYGON_API_BASE_URL');
  static const String polygonApiKey =
      String.fromEnvironment('APP_POLYGON_API_KEY');
}
