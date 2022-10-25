import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stocks/src/environment/variables.dart';

Dio get polygonClient {
  final client = Dio(
    BaseOptions(
      baseUrl: EnvironmentVariables.polygonApiBaseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${EnvironmentVariables.polygonApiKey}',
      },
    ),
  );

  // Offload JSON parsing to another isolate to avoid blocking the UI one.
  (client.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

  return client;
}

_parseAndDecode(String response) => jsonDecode(response);

parseJson(String text) => compute(_parseAndDecode, text);
