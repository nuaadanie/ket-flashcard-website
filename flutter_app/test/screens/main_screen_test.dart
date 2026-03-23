import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ket_flashcard/screens/main_screen.dart';

import '../test_fonts.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});

    // Mock google_fonts HTTP fetching with fake TTF bytes
    setupGoogleFontsMocks();

    // Mock path_provider for SpeechService.init()
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => '.',
    );

    // Mock audioplayers platform channel
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (MethodCall methodCall) async => null,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      null,
    );
  });

  testWidgets('Shows loading indicator then main page after init',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MainScreen()),
    );

    // Before init completes, should show loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let async init complete
    await tester.pumpAndSettle();

    // After init, loading indicator should be gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Bottom navigation has two tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MainScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('单词'), findsOneWidget);
    expect(find.text('阅读'), findsOneWidget);
  });

  testWidgets('Can switch between tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MainScreen()),
    );
    await tester.pumpAndSettle();

    // Default tab is 单词 (index 0)
    expect(find.text('单词'), findsOneWidget);

    // Tap on 阅读 tab
    await tester.tap(find.text('阅读'));
    await tester.pumpAndSettle();

    // Both tabs should still be visible in the nav bar
    expect(find.text('单词'), findsOneWidget);
    expect(find.text('阅读'), findsOneWidget);
  });
}
