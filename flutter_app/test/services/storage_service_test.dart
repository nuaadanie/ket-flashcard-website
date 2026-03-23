import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ket_flashcard/services/storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('StorageService mark/isMastered/isUnknown', () {
    late StorageService storage;

    setUp(() async {
      storage = StorageService();
      await storage.init();
    });

    test('initial state has empty lists', () {
      expect(storage.mastered, isEmpty);
      expect(storage.unknown, isEmpty);
    });

    test('markAsMastered sets mastered and clears unknown', () {
      storage.markAsMastered(10);

      expect(storage.isMastered(10), isTrue);
      expect(storage.isUnknown(10), isFalse);
    });

    test('markAsUnknown sets unknown and clears mastered', () {
      storage.markAsMastered(10);
      storage.markAsUnknown(10);

      expect(storage.isUnknown(10), isTrue);
      expect(storage.isMastered(10), isFalse);
    });

    test('markAsMastered removes from unknown', () {
      storage.markAsUnknown(5);
      storage.markAsMastered(5);

      expect(storage.isMastered(5), isTrue);
      expect(storage.isUnknown(5), isFalse);
      expect(storage.unknown, isNot(contains(5)));
    });

    test('markAsUnknown removes from mastered', () {
      storage.markAsMastered(5);
      storage.markAsUnknown(5);

      expect(storage.isUnknown(5), isTrue);
      expect(storage.isMastered(5), isFalse);
      expect(storage.mastered, isNot(contains(5)));
    });

    test('duplicate markAsMastered does not add twice', () {
      storage.markAsMastered(7);
      storage.markAsMastered(7);

      expect(storage.mastered.where((id) => id == 7).length, 1);
    });

    test('duplicate markAsUnknown does not add twice', () {
      storage.markAsUnknown(7);
      storage.markAsUnknown(7);

      expect(storage.unknown.where((id) => id == 7).length, 1);
    });

    test('isMastered returns false for unmarked id', () {
      expect(storage.isMastered(99), isFalse);
    });

    test('isUnknown returns false for unmarked id', () {
      expect(storage.isUnknown(99), isFalse);
    });
  });

  group('StorageService load', () {
    test('load parses saved JSON data', () async {
      final savedData = jsonEncode({
        'mastered': [1, 2, 3],
        'unknown': [4, 5],
        'lastMode': 'topic',
        'lastLevel': '蓝2',
        'lastTopic': '动物',
        'theme': 'ocean',
        'levelProgress': {'黑1': 5, '蓝2': 10},
        'topicProgress': {},
        'hasSeenMeaningTip': true,
        'readArticles': [100, 200],
        'accent': 'uk',
        'voice': 1,
        'statsFilter': null,
      });

      SharedPreferences.setMockInitialValues({'ket-flashcard': savedData});

      final storage = StorageService();
      await storage.init();

      expect(storage.mastered, [1, 2, 3]);
      expect(storage.unknown, [4, 5]);
      expect(storage.lastMode, 'topic');
      expect(storage.lastLevel, '蓝2');
      expect(storage.lastTopic, '动物');
      expect(storage.theme, 'ocean');
      expect(storage.levelProgress['黑1'], 5);
      expect(storage.levelProgress['蓝2'], 10);
      expect(storage.hasSeenMeaningTip, isTrue);
      expect(storage.readArticles, [100, 200]);
      expect(storage.accent, 'uk');
      expect(storage.voice, 1);
    });

    test('load handles old format levelProgress (int values)', () async {
      final savedData = jsonEncode({
        'mastered': [],
        'unknown': [],
        'levelProgress': {'黑1': 3},
        'topicProgress': {},
      });

      SharedPreferences.setMockInitialValues({'ket-flashcard': savedData});

      final storage = StorageService();
      await storage.init();

      expect(storage.levelProgress['黑1'], 3);
    });

    test('load handles new format levelProgress (map with currentIndex)',
        () async {
      final savedData = jsonEncode({
        'mastered': [],
        'unknown': [],
        'levelProgress': {
          '黑1': {'currentIndex': 7}
        },
        'topicProgress': {},
      });

      SharedPreferences.setMockInitialValues({'ket-flashcard': savedData});

      final storage = StorageService();
      await storage.init();

      expect(storage.levelProgress['黑1'], 7);
    });
  });
}
