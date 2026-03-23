import 'package:flutter_test/flutter_test.dart';
import 'package:ket_flashcard/models/article.dart';

void main() {
  group('Paragraph', () {
    test('fromJson parses correctly', () {
      final json = {
        'en': 'The cat sat on the mat.',
        'zh': '猫坐在垫子上。',
        'keywords': ['cat', 'mat'],
      };
      final p = Paragraph.fromJson(json);

      expect(p.en, 'The cat sat on the mat.');
      expect(p.zh, '猫坐在垫子上。');
      expect(p.keywords, ['cat', 'mat']);
    });

    test('fromJson handles missing keywords', () {
      final json = {
        'en': 'Hello world.',
        'zh': '你好世界。',
      };
      final p = Paragraph.fromJson(json);

      expect(p.keywords, isEmpty);
    });
  });

  group('Article', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 1,
        'title': 'My Day',
        'level': '黑1',
        'topics': ['日常'],
        'paragraphs': [
          {
            'en': 'I wake up early.',
            'zh': '我早起。',
            'keywords': ['wake'],
          },
        ],
      };
      final article = Article.fromJson(json);

      expect(article.id, 1);
      expect(article.title, 'My Day');
      expect(article.level, '黑1');
      expect(article.topics, ['日常']);
      expect(article.paragraphs.length, 1);
      expect(article.paragraphs[0].en, 'I wake up early.');
    });

    test('fromJson handles missing fields with defaults', () {
      final json = {'id': 5};
      final article = Article.fromJson(json);

      expect(article.id, 5);
      expect(article.title, '');
      expect(article.level, '黑1');
      expect(article.topics, isEmpty);
      expect(article.paragraphs, isEmpty);
    });

    test('ketWordCount sums keywords across paragraphs', () {
      final json = {
        'id': 1,
        'title': 'Test',
        'level': '黑1',
        'paragraphs': [
          {
            'en': 'A',
            'zh': 'A',
            'keywords': ['cat', 'dog', 'bird'],
          },
          {
            'en': 'B',
            'zh': 'B',
            'keywords': ['fish'],
          },
          {
            'en': 'C',
            'zh': 'C',
            'keywords': [],
          },
        ],
      };
      final article = Article.fromJson(json);

      expect(article.ketWordCount, 4);
    });

    test('ketWordCount returns 0 for no paragraphs', () {
      final article = Article.fromJson({'id': 1});
      expect(article.ketWordCount, 0);
    });
  });
}
