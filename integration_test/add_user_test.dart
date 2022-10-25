import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:stocks/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'tap add user, expect his name displayed',
    (tester) async {
      await app.boot();
      await tester.pumpAndSettle();

      final addUserButton = find.widgetWithText(
        ElevatedButton,
        'Add',
      );

      await tester.tap(addUserButton);
      await tester.pumpAndSettle();

      expect(find.text('Jan Nowak'), findsOneWidget);
    },
  );
}
