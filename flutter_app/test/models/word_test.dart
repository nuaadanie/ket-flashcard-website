import 'package:flutter_test/flutter_test.dart';
import 'package:ket_flashcard/models/word.dart';

void main() {
  group('Word', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 1,
        'word': 'apple',
        'phonetic': '/ˈæp.əl/',
        'meaning': '苹果',
        'level': '黑1',
        'topic': '食物',
        'syllables': ['ap', 'ple'],
      };
      final word = Word.fromJson(json);

      expect(word.id, 1);
      expect(word.word, 'apple');
      expect(word.phonetic, '/ˈæp.əl/');
      expect(word.meaning, '苹果');
      expect(word.level, '黑1');
      expect(word.topic, '食物');
      expect(word.syllables, ['ap', 'ple']);
    });

    test('fromJson handles missing fields with defaults', () {
      final json = {'id': 42};
      final word = Word.fromJson(json);

      expect(word.id, 42);
      expect(word.word, '');
      expect(word.phonetic, '');
      expect(word.meaning, '');
      expect(word.level, '黑1');
      expect(word.topic, '未分类');
    });

    test('fromJson defaults syllables to empty list', () {
      final json = {
        'id': 1,
        'word': 'test',
        'phonetic': '',
        'meaning': '',
        'level': '黑1',
        'topic': '',
      };
      final word = Word.fromJson(json);

      expect(word.syllables, isEmpty);
    });
  });

  group('WordData', () {
    test('fromJson parses correctly', () {
      final json = {
        'version': '2.0',
        'total': 2,
        'levels': ['黑1', '蓝2'],
        'topics': ['食物', '动物'],
        'words': [
          {
            'id': 1,
            'word': 'apple',
            'phonetic': '',
            'meaning': '苹果',
            'level': '黑1',
            'topic': '食物',
          },
          {
            'id': 2,
            'word': 'cat',
            'phonetic': '',
            'meaning': '猫',
            'level': '黑1',
            'topic': '动物',
          },
        ],
      };
      final data = WordData.fromJson(json);

      expect(data.version, '2.0');
      expect(data.total, 2);
      expect(data.levels, ['黑1', '蓝2']);
      expect(data.topics, ['食物', '动物']);
      expect(data.words.length, 2);
      expect(data.words[0].word, 'apple');
      expect(data.words[1].word, 'cat');
    });

    test('fromJson handles missing fields with defaults', () {
      final data = WordData.fromJson({});

      expect(data.version, '1.0');
      expect(data.total, 0);
      expect(data.levels, isEmpty);
      expect(data.topics, isEmpty);
      expect(data.words, isEmpty);
    });
  });
}
