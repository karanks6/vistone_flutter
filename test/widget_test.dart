// Fix default test to use VistoneApp
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vistone_app/main.dart';
import 'package:vistone_app/providers/theme_provider.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
        child: const VistoneApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
    // flutter_animate schedules its initial frame with a zero-duration timer.
    await tester.pump(const Duration(milliseconds: 1));
  });
}
