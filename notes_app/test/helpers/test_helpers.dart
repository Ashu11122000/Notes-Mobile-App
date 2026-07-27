/// ============================================================================
/// File: test/helpers/test_helpers.dart
/// ============================================================================
///
/// Shared testing utilities.
///
/// Responsibilities
/// ----------------------------------------------------------------------------
/// • Build widgets inside MaterialApp.
/// • Pump widgets consistently.
/// • Wait for animations to finish.
/// • Create reusable DateTime values.
/// • Deep copy JSON objects.
/// • Provide reusable helper methods for unit, widget and integration tests.
///
/// This file intentionally contains no application business logic.
///
/// ============================================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Shared helper methods used across the entire test suite.
final class TestHelpers {
  TestHelpers._();

  // ===========================================================================
  // Widget Helpers
  // ===========================================================================

  /// Wraps a widget with a minimal MaterialApp.
  static Widget wrapWithMaterialApp(
    Widget child, {
    ThemeMode themeMode = ThemeMode.light,
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    Locale? locale,
  }) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: lightTheme ?? ThemeData(useMaterial3: true),
      darkTheme: darkTheme ?? ThemeData.dark(useMaterial3: true),
      locale: locale,
      home: child,
    );
  }

  /// Wraps a widget with MaterialApp and MultiProvider.
  static Widget wrapWithProviders(
    Widget child, {
    List<SingleChildWidget> providers = const <SingleChildWidget>[],
    ThemeMode themeMode = ThemeMode.light,
  }) {
    return MultiProvider(
      providers: providers,
      child: wrapWithMaterialApp(child, themeMode: themeMode),
    );
  }

  // ===========================================================================
  // Pump Helpers
  // ===========================================================================

  /// Pumps a widget and waits for the first frame.
  static Future<void> pumpWidget(WidgetTester tester, Widget widget) async {
    await tester.pumpWidget(widget);
    await tester.pump();
  }

  /// Waits until animations and scheduled frames have completed.
  static Future<void> pumpAndSettle(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Pumps a specific duration.
  static Future<void> pumpDuration(
    WidgetTester tester,
    Duration duration,
  ) async {
    await tester.pump(duration);
  }

  // ===========================================================================
  // Date Helpers
  // ===========================================================================

  /// Fixed date used throughout tests.
  static DateTime fixedDate() {
    return DateTime(2026, 1, 1, 10, 0);
  }

  /// Future date.
  static DateTime futureDate({int days = 1}) {
    return fixedDate().add(Duration(days: days));
  }

  /// Past date.
  static DateTime pastDate({int days = 1}) {
    return fixedDate().subtract(Duration(days: days));
  }

  // ===========================================================================
  // JSON Helpers
  // ===========================================================================

  /// Returns a deep copy of a JSON map.
  static Map<String, dynamic> cloneJson(Map<String, dynamic> json) {
    return Map<String, dynamic>.from(
      jsonDecode(jsonEncode(json)) as Map<String, dynamic>,
    );
  }

  /// Returns a deep copy of a JSON list.
  static List<Map<String, dynamic>> cloneJsonList(
    List<Map<String, dynamic>> list,
  ) {
    return (jsonDecode(jsonEncode(list)) as List<dynamic>)
        .cast<Map<String, dynamic>>();
  }

  // ===========================================================================
  // Finder Helpers
  // ===========================================================================

  static Finder text(String value) => find.text(value);

  static Finder key(String value) => find.byKey(Key(value));

  static Finder type<T extends Widget>() => find.byType(T);

  // ===========================================================================
  // Expectations
  // ===========================================================================

  static void expectVisible(String text) {
    expect(find.text(text), findsOneWidget);
  }

  static void expectNotVisible(String text) {
    expect(find.text(text), findsNothing);
  }

  static void expectWidget<T extends Widget>() {
    expect(find.byType(T), findsOneWidget);
  }
}
