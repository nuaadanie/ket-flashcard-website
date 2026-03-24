import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ket_flashcard/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});

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

  testWidgets('App renders and shows bottom navigation tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(const KetFlashcardApp());
    // Wait for async init (storage, speech) to complete
    await tester.pumpAndSettle();

    // Verify bottom nav labels exist
    expect(find.text('单词'), findsOneWidget);
    expect(find.text('阅读'), findsOneWidget);
  });
}
