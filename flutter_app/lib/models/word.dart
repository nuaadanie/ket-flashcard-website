class Word {
  final int id;
  final String word;
  final String phonetic;
  final String meaning;
  final String level;
  final String topic;
  final List<String> syllables;

  Word({
    required this.id,
    required this.word,
    required this.phonetic,
    required this.meaning,
    required this.level,
    required this.topic,
    this.syllables = const [],
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'] as int,
      word: json['word'] as String? ?? '',
      phonetic: json['phonetic'] as String? ?? '',
      meaning: json['meaning'] as String? ?? '',
      level: json['level'] as String? ?? '黑1',
      topic: json['topic'] as String? ?? '未分类',
      syllables: (json['syllables'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class WordData {
  final String version;
  final int total;
  final List<String> levels;
  final List<String> topics;
  final List<Word> words;

  WordData({
    required this.version,
    required this.total,
    required this.levels,
    required this.topics,
    required this.words,
  });

  factory WordData.fromJson(Map<String, dynamic> json) {
    return WordData(
      version: json['version'] as String? ?? '1.0',
      total: json['total'] as int? ?? 0,
      levels:
          (json['levels'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
              [],
      topics:
          (json['topics'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
              [],
      words: (json['words'] as List<dynamic>?)
              ?.map((e) => Word.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
