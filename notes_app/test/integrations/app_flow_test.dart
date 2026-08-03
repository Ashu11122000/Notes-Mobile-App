import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Application Flow', () {
    testWidgets('Smoke test - MaterialApp builds successfully', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: Text('Notes App'))),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Notes App'), findsOneWidget);
    });
  });
}
