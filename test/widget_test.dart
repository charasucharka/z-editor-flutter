// Basic Flutter widget smoke test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:z_editor/main.dart';

void main() {
  testWidgets('App builds and loads', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ZEditorRoot(
        initialLocale: const Locale('en'),
        initialThemeMode: ThemeMode.system,
        initialUiScale: 1.0,
        prefs: prefs,
      ),
    );

    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
