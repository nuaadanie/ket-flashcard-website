import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _key = 'ket-flashcard';
  late SharedPreferences _prefs;

  List<int> mastered = [];
  List<int> unknown = [];
  String lastMode = 'level';
  String lastLevel = '黑1';
  String lastTopic = '';
  String theme = 'forest';
  Map<String, int> levelProgress = {'黑1': 0, '蓝2': 0, '红3': 0};
  Map<String, int> topicProgress = {};
  bool hasSeenMeaningTip = false;
  List<int> readArticles = [];
  String accent = 'us'; // 'us' 美式, 'uk' 英式
  int voice = 0; // 0=女声, 1=男声, 3=情感男声, 4=情感女声

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    load();
  }

  void load() {
    final saved = _prefs.getString(_key);
    if (saved == null) return;
    try {
      final data = jsonDecode(saved) as Map<String, dynamic>;
      mastered = (data['mastered'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [];
      unknown = (data['unknown'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [];
      lastMode = data['lastMode'] as String? ?? 'level';
      lastLevel = data['lastLevel'] as String? ?? '黑1';
      lastTopic = data['lastTopic'] as String? ?? '';
      theme = data['theme'] as String? ?? 'forest';

      if (data['levelProgress'] != null) {
        final lp = data['levelProgress'] as Map<String, dynamic>;
        lp.forEach((key, value) {
          if (value is Map) {
            levelProgress[key] = (value['currentIndex'] as int?) ?? 0;
          } else if (value is int) {
            levelProgress[key] = value;
          }
        });
      }
      if (data['topicProgress'] != null) {
        final tp = data['topicProgress'] as Map<String, dynamic>;
        tp.forEach((key, value) {
          if (value is Map) {
            topicProgress[key] = (value['currentIndex'] as int?) ?? 0;
          } else if (value is int) {
            topicProgress[key] = value;
          }
        });
      }
      hasSeenMeaningTip = data['hasSeenMeaningTip'] as bool? ?? false;
      readArticles = (data['readArticles'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [];
      accent = data['accent'] as String? ?? 'us';
      voice = data['voice'] as int? ?? 0;
    } catch (e) {
      // ignore corrupt data
    }
  }

  Future<void> save() async {
    final data = jsonEncode({
      'mastered': mastered,
      'unknown': unknown,
      'lastMode': lastMode,
      'lastLevel': lastLevel,
      'lastTopic': lastTopic,
      'theme': theme,
      'levelProgress': levelProgress,
      'topicProgress': topicProgress,
      'hasSeenMeaningTip': hasSeenMeaningTip,
      'readArticles': readArticles,
      'accent': accent,
      'voice': voice,
    });
    await _prefs.setString(_key, data);
  }

  void markAsMastered(int wordId) {
    if (!mastered.contains(wordId)) mastered.add(wordId);
    unknown.remove(wordId);
  }

  void markAsUnknown(int wordId) {
    if (!unknown.contains(wordId)) unknown.add(wordId);
    mastered.remove(wordId);
  }

  bool isMastered(int wordId) => mastered.contains(wordId);
  bool isUnknown(int wordId) => unknown.contains(wordId);
}
