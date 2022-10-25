import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:stocks/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'tap counter increment twice, and expect 2 as a result',
    (tester) async {
      await app.boot();
      await tester.pumpAndSettle();

      final blocRouteButton = find.widgetWithText(
        TextButton,
        'To BLoC screen',
      );

      await tester.tap(blocRouteButton);
      await tester.pumpAndSettle();

      final addButton = find.widgetWithIcon(FloatingActionButton, Icons.add);

      await tester.tap(addButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
    },
  );
}
