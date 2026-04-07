class Paragraph {
  final String en;
  final String zh;
  final List<String> keywords; // KET单词

  Paragraph({required this.en, required this.zh, this.keywords = const []});

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    return Paragraph(
      en: json['en'] as String? ?? '',
      zh: json['zh'] as String? ?? '',
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class Article {
  final int id;
  final String title;
  final String titleZh;
  final String level;
  final List<String> topics;
  final List<Paragraph> paragraphs;

  Article({
    required this.id,
    required this.title,
    this.titleZh = '',
    required this.level,
    this.topics = const [],
    this.paragraphs = const [],
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      titleZh: json['titleZh'] as String? ?? '',
      level: json['level'] as String? ?? '黑1',
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      paragraphs: (json['paragraphs'] as List<dynamic>?)
              ?.map((e) => Paragraph.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  int get ketWordCount {
    int count = 0;
    for (final p in paragraphs) {
      count += p.keywords.length;
    }
    return count;
  }
}
