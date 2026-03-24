import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/word.dart';

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
  String? statsFilter; // 当前统计筛选状态
  int currentStreak = 0;
  int bestStreak = 0;
  String? lastStudyDate; // "2026-03-23"
  List<String> unlockedAchievements = [];

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
      statsFilter = data['statsFilter'] as String?;
      currentStreak = data['currentStreak'] as int? ?? 0;
      bestStreak = data['bestStreak'] as int? ?? 0;
      lastStudyDate = data['lastStudyDate'] as String?;
      unlockedAchievements = (data['unlockedAchievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [];
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
      'statsFilter': statsFilter,
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastStudyDate': lastStudyDate,
      'unlockedAchievements': unlockedAchievements,
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

  void recordStudyDay() {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    if (lastStudyDate == todayStr) return;
    if (lastStudyDate != null) {
      final diff = today.difference(DateTime.parse(lastStudyDate!)).inDays;
      if (diff == 1) {
        currentStreak++;
      } else if (diff > 1) {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }
    lastStudyDate = todayStr;
    if (currentStreak > bestStreak) bestStreak = currentStreak;
    save();
  }

  List<String> checkAchievements(List<Word> allWords) {
    final newlyUnlocked = <String>[];

    void check(String id) {
      if (!unlockedAchievements.contains(id)) {
        unlockedAchievements.add(id);
        newlyUnlocked.add(id);
      }
    }

    final masteredCount = mastered.length;
    if (masteredCount >= 1) check('first_word');
    if (masteredCount >= 10) check('words_10');
    if (masteredCount >= 50) check('words_50');
    if (masteredCount >= 100) check('words_100');
    if (masteredCount >= 500) check('words_500');
    if (masteredCount >= 1000) check('words_1000');

    if (currentStreak >= 3) check('streak_3');
    if (currentStreak >= 7) check('streak_7');
    if (currentStreak >= 30) check('streak_30');

    final levelIds = {'黑1': 'level1_done', '蓝2': 'level2_done', '红3': 'level3_done'};
    for (final entry in levelIds.entries) {
      final levelWords = allWords.where((w) => w.level == entry.key).toList();
      if (levelWords.isNotEmpty &&
          levelWords.every((w) => mastered.contains(w.id))) {
        check(entry.value);
      }
    }

    if (newlyUnlocked.isNotEmpty) save();
    return newlyUnlocked;
  }
}
