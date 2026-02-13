// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:eco_tisb/main.dart';

import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });

  setUpAll(() async {
    // Mock Supabase for testing
    await Supabase.initialize(
      url: 'https://example.supabase.co',
      anonKey: 'example',
    );
  });

  testWidgets('Welcome screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EcoTISBApp());

    // Verify that our welcome text is present.
    expect(find.text('TISB Swap'), findsOneWidget);
    expect(find.text('Login with Email'), findsOneWidget);
  });
}
