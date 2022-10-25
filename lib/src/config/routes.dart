import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stocks/src/config/routes/main.dart';

part 'routes.gr.dart';

class Routes {
  static const main = MainRouteHelper();
}

@AdaptiveAutoRouter(routes: [
  AutoRoute(
    page: MainRouteHelper.widget,
    path: MainRouteHelper.path,
    initial: true,
  ),
])
class AppRouter extends _$AppRouter {}
