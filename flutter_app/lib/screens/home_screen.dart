import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/word.dart';
import '../models/app_theme.dart';
import '../models/achievement.dart';
import '../services/storage_service.dart';
import '../services/speech_service.dart';
import '../widgets/flashcard.dart';
import '../widgets/vocab_book.dart';
import '../widgets/streak_badge.dart';
import '../widgets/word_of_day_card.dart';
import '../widgets/achievement_dialog.dart';

class HomeScreen extends StatefulWidget {
  final int themeIndex;
  final VoidCallback onThemeToggle;

  const HomeScreen({
    super.key,
    required this.themeIndex,
    required this.onThemeToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  final StorageService _storage = StorageService();
  final SpeechService _speech = SpeechService();

  List<Word> _allWords = [];
  List<Word> _filteredWords = [];
  int _currentIndex = 0;
  String _currentMode = 'level';
  String _currentLevel = '黑1';
  String _currentTopic = '';
  bool _isPlaying = false;

  // 需求1: 操作历史栈，用于"上一个"撤销
  final List<_ActionRecord> _actionHistory = [];

  // 需求3: 统计筛选模式 null=不筛选, 'mastered', 'unknown', 'unlearned'
  String? _statsFilter;

  late AnimationController _cardAnimController;
  late Animation<double> _cardAnim;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cardAnimController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _cardAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _cardAnimController, curve: Curves.easeOut),
    );
    _init();
  }

  Future<void> _init() async {
    await _storage.init();
    await _speech.init();
    _speech.accent = _storage.accent;
    _speech.voice = _storage.voice;
    await _loadWords();
    _currentMode = _storage.lastMode;
    _currentLevel = _storage.lastLevel;
    _currentTopic = _storage.lastTopic;
    _statsFilter = _storage.statsFilter;
    _filterWords();
    _cardAnimController.forward();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveProgress();
    }
  }

  Future<void> _loadWords() async {
    final jsonStr = await rootBundle.loadString('assets/words.json');
    final data = WordData.fromJson(jsonDecode(jsonStr));
    _allWords = data.words;
  }

  void _filterWords() {
    // 先按级别/主题筛选
    List<Word> base;
    if (_currentMode == 'level') {
      base = _allWords.where((w) => w.level == _currentLevel).toList();
    } else {
      base = _allWords.where((w) => w.topic == _currentTopic).toList();
    }

    // 需求3: 再按统计筛选
    if (_statsFilter == 'mastered') {
      _filteredWords = base.where((w) => _storage.isMastered(w.id)).toList();
    } else if (_statsFilter == 'unknown') {
      _filteredWords = base.where((w) => _storage.isUnknown(w.id)).toList();
    } else if (_statsFilter == 'unlearned') {
      _filteredWords = base.where((w) =>
          !_storage.isMastered(w.id) && !_storage.isUnknown(w.id)).toList();
    } else {
      _filteredWords = base;
    }

    // 恢复进度
    if (_statsFilter == null) {
      if (_currentMode == 'level') {
        _currentIndex = _storage.levelProgress[_currentLevel] ?? 0;
      } else {
        _currentIndex = _storage.topicProgress[_currentTopic] ?? 0;
      }
    } else {
      _currentIndex = 0;
    }
    if (_currentIndex >= _filteredWords.length) _currentIndex = 0;
  }

  void _saveProgress() {
    _storage.statsFilter = _statsFilter;
    if (_statsFilter != null) {
      // 筛选模式只保存筛选状态，不保存卡片进度
      _storage.save();
      return;
    }
    if (_currentMode == 'level') {
      _storage.levelProgress[_currentLevel] = _currentIndex;
    } else {
      _storage.topicProgress[_currentTopic] = _currentIndex;
    }
    _storage.lastMode = _currentMode;
    _storage.lastLevel = _currentLevel;
    _storage.lastTopic = _currentTopic;
    _storage.save();
  }

  Future<void> _animateCard(VoidCallback action) async {
    await _cardAnimController.reverse();
    action();
    _cardAnimController.forward();
  }

  // 需求4: 到达最后一个时的处理
  void _onReachEnd() {
    final levels = ['黑1', '蓝2', '红3'];
    final currentIdx = levels.indexOf(_currentLevel);
    final hasNext = _currentMode == 'level' && currentIdx < levels.length - 1;
    final nextLabel = hasNext ? levels[currentIdx + 1] : null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
          side: const BorderSide(color: stichSurfaceContainer, width: 3),
        ),
        title: const Text('🎉 恭喜完成！'),
        content: Text(
          _currentMode == 'level'
              ? '$_currentLevel 全部完成！'
              : '$_currentTopic 全部完成！',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _animateCard(() {
                setState(() {
                  _currentIndex = 0;
                  _saveProgress();
                });
              });
            },
            child: const Text('🔄 重头再来'),
          ),
          if (hasNext && nextLabel != null)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _animateCard(() {
                  setState(() {
                    _currentLevel = nextLabel;
                    _filterWords();
                    _saveProgress();
                  });
                });
              },
              child: Text('➡️ 进入$nextLabel'),
            ),
        ],
      ),
    );
  }

  void _nextWord() {
    _animateCard(() {
      setState(() {
        _currentIndex++;
        if (_currentIndex >= _filteredWords.length) {
          _currentIndex = _filteredWords.length - 1;
          if (_currentIndex < 0) _currentIndex = 0;
          _saveProgress();
          // 需求4: 弹窗
          WidgetsBinding.instance.addPostFrameCallback((_) => _onReachEnd());
          return;
        }
        _saveProgress();
      });
    });
  }

  void _markMastered() {
    if (_filteredWords.isEmpty) return;
    final word = _filteredWords[_currentIndex];
    // 需求1: 记录操作历史
    String? prevState;
    if (_storage.isMastered(word.id)) {
      prevState = 'mastered';
    } else if (_storage.isUnknown(word.id)) {
      prevState = 'unknown';
    }
    _actionHistory.add(_ActionRecord(
      wordId: word.id,
      previousState: prevState,
      previousIndex: _currentIndex,
    ));
    _storage.markAsMastered(word.id);
    _storage.recordStudyDay();
    _checkAndNotifyAchievements();
    _saveProgress();
    _nextWord();
  }

  void _markUnknown() {
    if (_filteredWords.isEmpty) return;
    final word = _filteredWords[_currentIndex];
    String? prevState;
    if (_storage.isMastered(word.id)) {
      prevState = 'mastered';
    } else if (_storage.isUnknown(word.id)) {
      prevState = 'unknown';
    }
    _actionHistory.add(_ActionRecord(
      wordId: word.id,
      previousState: prevState,
      previousIndex: _currentIndex,
    ));
    _storage.markAsUnknown(word.id);
    _storage.recordStudyDay();
    _checkAndNotifyAchievements();
    _saveProgress();
    _nextWord();
  }

  void _checkAndNotifyAchievements() {
    final newAchievements = _storage.checkAchievements(_allWords);
    for (final id in newAchievements) {
      final a = achievements.firstWhere((a) => a.id == id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 解锁成就：${a.title}'),
            backgroundColor: stichSecondary,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // 需求1: 上一个（撤销）
  void _goBack() {
    if (_actionHistory.isEmpty) {
      // 没有操作历史，简单回退
      if (_currentIndex > 0) {
        _animateCard(() {
          setState(() {
            _currentIndex--;
            _saveProgress();
          });
        });
      }
      return;
    }
    final record = _actionHistory.removeLast();
    // 恢复之前的状态
    if (record.previousState == 'mastered') {
      _storage.markAsMastered(record.wordId);
    } else if (record.previousState == 'unknown') {
      _storage.markAsUnknown(record.wordId);
    } else {
      // 之前没有标记，清除当前标记
      _storage.mastered.remove(record.wordId);
      _storage.unknown.remove(record.wordId);
    }
    _animateCard(() {
      setState(() {
        _currentIndex = record.previousIndex;
        if (_currentIndex >= _filteredWords.length) {
          _currentIndex = _filteredWords.length - 1;
        }
        if (_currentIndex < 0) _currentIndex = 0;
        _saveProgress();
      });
    });
  }

  Future<void> _playWord() async {
    if (_filteredWords.isEmpty || _isPlaying) return;
    setState(() => _isPlaying = true);
    await _speech.speak(_filteredWords[_currentIndex].word);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isPlaying = false);
  }

  void _showVoiceSettings() {
    showDialog(
      context: context,
      builder: (ctx) {
        String accent = _storage.accent;
        int voice = _storage.voice;
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
                side: const BorderSide(color: stichSurfaceContainer, width: 3),
              ),
              title: const Row(
                children: [
                  Icon(Icons.record_voice_over, color: stichSecondary),
                  SizedBox(width: 8),
                  Text('语音设置', style: TextStyle(fontSize: 18)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('口音', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _voiceChip('🇺🇸 美式', accent == 'us', () {
                        setDialogState(() => accent = 'us');
                      }),
                      const SizedBox(width: 12),
                      _voiceChip('🇬🇧 英式', accent == 'uk', () {
                        setDialogState(() => accent = 'uk');
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('音色', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _voiceChip('👩 女声', voice == 0, () {
                        setDialogState(() => voice = 0);
                      }),
                      _voiceChip('👨 男声', voice == 1, () {
                        setDialogState(() => voice = 1);
                      }),
                      _voiceChip('🎭 情感女声', voice == 4, () {
                        setDialogState(() => voice = 4);
                      }),
                      _voiceChip('🎭 情感男声', voice == 3, () {
                        setDialogState(() => voice = 3);
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton.icon(
                      icon: const Icon(Icons.play_circle, size: 20),
                      label: const Text('试听'),
                      onPressed: () {
                        _speech.accent = accent;
                        _speech.voice = voice;
                        _speech.speak('hello');
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _storage.accent = accent;
                      _storage.voice = voice;
                      _speech.accent = accent;
                      _speech.voice = voice;
                      _storage.save();
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('确定'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _voiceChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? stichSecondary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? stichSecondary : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.grey[700],
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // 需求3: 点击统计条筛选
  void _toggleStatsFilter(String filter) {
    setState(() {
      if (_statsFilter == filter) {
        _statsFilter = null; // 取消筛选
      } else {
        _statsFilter = filter;
      }
      _filterWords();
    });
    _cardAnimController.forward(from: 0);
  }

  // 需求3: 计算当前级别/主题下的统计
  Map<String, int> _getStats() {
    List<Word> base;
    if (_currentMode == 'level') {
      base = _allWords.where((w) => w.level == _currentLevel).toList();
    } else {
      base = _allWords.where((w) => w.topic == _currentTopic).toList();
    }
    int mastered = 0, unknown = 0, unlearned = 0;
    for (final w in base) {
      if (_storage.isMastered(w.id)) {
        mastered++;
      } else if (_storage.isUnknown(w.id)) {
        unknown++;
      } else {
        unlearned++;
      }
    }
    return {'mastered': mastered, 'unknown': unknown, 'unlearned': unlearned};
  }

  Word? _getWordOfDay() {
    if (_allWords.isEmpty) return null;
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final unmastered = _allWords.where((w) => !_storage.isMastered(w.id)).toList();
    if (unmastered.isEmpty) return null;
    return unmastered[seed % unmastered.length];
  }

  List<String> get _topics {
    return _allWords.map((w) => w.topic).toSet().toList()..sort();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cardAnimController.dispose();
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: appThemes[widget.themeIndex].gradientColors,
          ),
        ),
        child: SafeArea(
          child: isLandscape
              ? _buildLandscapeLayout()
              : _buildPortraitLayout(),
        ),
      ),
    );
  }

  // ==================== 竖屏布局 ====================
  Widget _buildPortraitLayout() {
    final progress = _allWords.isEmpty
        ? 0.0
        : _storage.mastered.length / _allWords.length;
    final wotd = _getWordOfDay();
    return Column(
      children: [
        _buildTopBar(progress),
        StreakBadge(
          currentStreak: _storage.currentStreak,
          bestStreak: _storage.bestStreak,
        ),
        _buildStatsBar(),
        if (wotd != null)
          WordOfDayCard(word: wotd, speech: _speech),
        _buildModeSelector(),
        if (_currentMode == 'level') _buildLevelSelector(),
        if (_currentMode == 'topic') _buildTopicSelector(),
        Expanded(child: _buildCardArea(false)),
        _buildPortraitCounter(),
        _buildActionButtons(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPortraitCounter() {
    if (_filteredWords.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '${_currentIndex + 1} / ${_filteredWords.length}',
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
    );
  }

  // ==================== 横屏布局 ====================
  Widget _buildLandscapeLayout() {
    final progress = _allWords.isEmpty
        ? 0.0
        : _storage.mastered.length / _allWords.length;
    final wotd = _getWordOfDay();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 900;
    final leftWidth = isTablet ? 160.0 : 130.0;
    final rightWidth = isTablet ? 100.0 : 80.0;

    return Column(
      children: [
        _buildTopBarCompact(progress),
        Expanded(
          child: Row(
            children: [
              // 左侧：tab风格
              SizedBox(
                width: leftWidth,
                child: Column(
                  children: [
                    // Tab 栏
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 4, 4, 0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        children: [
                          Expanded(child: _tabItem('级别', 'level', isTablet)),
                          Expanded(child: _tabItem('主题', 'topic', isTablet)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Tab 内容
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 4),
                        child: _currentMode == 'level'
                            ? _buildLevelList(isTablet)
                            : _buildTopicList(isTablet),
                      ),
                    ),
                  ],
                ),
              ),
              // 中间：闪卡填满
              Expanded(
                child: Column(
                  children: [
                    if (wotd != null)
                      WordOfDayCard(word: wotd, speech: _speech),
                    Expanded(child: _buildCardArea(true)),
                  ],
                ),
              ),
              // 右侧：按钮
              SizedBox(
                width: rightWidth,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _actionBtnCompact(
                        icon: Icons.arrow_back,
                        label: '上一个',
                        color: Colors.grey[600]!,
                        onTap: _goBack,
                        isPad: isTablet,
                      ),
                      SizedBox(height: isTablet ? 16 : 10),
                      _actionBtnCompact(
                        icon: Icons.close,
                        label: '不会',
                        color: Colors.red,
                        onTap: _markUnknown,
                        isPad: isTablet,
                      ),
                      SizedBox(height: isTablet ? 16 : 10),
                      _actionBtnCompact(
                        icon: Icons.volume_up,
                        label: '发音',
                        color: stichSecondary,
                        onTap: _playWord,
                        isPad: isTablet,
                      ),
                      SizedBox(height: isTablet ? 16 : 10),
                      _actionBtnCompact(
                        icon: Icons.check,
                        label: '会了',
                        color: stichPrimary,
                        onTap: _markMastered,
                        isPad: isTablet,
                      ),
                      const SizedBox(height: 8),
                      if (_filteredWords.isNotEmpty)
                        Text(
                          '${_currentIndex + 1}/${_filteredWords.length}',
                          style: TextStyle(fontSize: isTablet ? 14 : 11, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== 需求3: 统计条 ====================
  Widget _buildStatsBar() {
    final stats = _getStats();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _statChip('✅ ${stats['mastered']}', 'mastered', Colors.green),
          const SizedBox(width: 8),
          _statChip('❌ ${stats['unknown']}', 'unknown', Colors.red),
          const SizedBox(width: 8),
          _statChip('📝 ${stats['unlearned']}', 'unlearned', Colors.grey),
        ],
      ),
    );
  }

  Widget _statChip(String label, String filter, Color color) {
    final active = _statsFilter == filter;
    return GestureDetector(
      onTap: () => _toggleStatsFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: active ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color, width: active ? 2 : 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? Colors.white : color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ==================== 顶栏 ====================
  Widget _buildTopBarCompact(double progress) {
    final stats = _getStats();
    final screenWidth = MediaQuery.of(context).size.width;
    final isPad = screenWidth > 900;
    final titleSize = isPad ? 20.0 : 16.0;
    final titleIconSize = isPad ? 28.0 : 22.0;
    final barIconSize = isPad ? 24.0 : 20.0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isPad ? 20 : 12, vertical: isPad ? 6 : 2),
      child: Row(
        children: [
          Icon(Icons.menu_book, color: stichPrimary, size: titleIconSize),
          const SizedBox(width: 6),
          Text('KET闪卡',
              style: GoogleFonts.fredoka(fontSize: titleSize, fontWeight: FontWeight.bold, color: stichPrimary)),
          const SizedBox(width: 12),
          // 横屏统计合并到顶栏
          _statChip('✅${stats['mastered']}', 'mastered', Colors.green),
          const SizedBox(width: 4),
          _statChip('❌${stats['unknown']}', 'unknown', Colors.red),
          const SizedBox(width: 4),
          _statChip('📝${stats['unlearned']}', 'unlearned', Colors.grey),
          const SizedBox(width: 4),
          StreakBadge(
            currentStreak: _storage.currentStreak,
            bestStreak: _storage.bestStreak,
          ),
          const Spacer(),
          SizedBox(
            width: isPad ? 80 : 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation(stichPrimary),
                minHeight: isPad ? 7 : 5,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text('${(progress * 100).round()}%', style: TextStyle(fontSize: isPad ? 14 : 12)),
          IconButton(
            icon: Icon(Icons.book, color: stichSecondary, size: barIconSize),
            tooltip: '单词本',
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: isPad ? 44 : 36, minHeight: isPad ? 44 : 36),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => VocabBookDialog(allWords: _allWords, storage: _storage, speech: _speech),
            ),
          ),
          IconButton(
            icon: Icon(Icons.emoji_events, color: stichTertiary, size: barIconSize),
            tooltip: '成就',
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: isPad ? 44 : 36, minHeight: isPad ? 44 : 36),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AchievementDialog(unlockedAchievements: _storage.unlockedAchievements),
            ),
          ),
          IconButton(
            icon: Icon(Icons.palette, color: stichTertiary, size: barIconSize),
            tooltip: '换背景',
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: isPad ? 44 : 36, minHeight: isPad ? 44 : 36),
            onPressed: widget.onThemeToggle,
          ),
          IconButton(
            icon: Icon(Icons.record_voice_over, color: stichSecondary, size: barIconSize),
            tooltip: '语音设置',
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: isPad ? 44 : 36, minHeight: isPad ? 44 : 36),
            onPressed: _showVoiceSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.menu_book, color: stichPrimary, size: 28),
          const SizedBox(width: 8),
          Text('KET闪卡',
              style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold, color: stichPrimary)),
          const Spacer(),
          Text('${_storage.mastered.length}/${_allWords.length}',
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation(stichPrimary),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('${(progress * 100).round()}%', style: const TextStyle(fontSize: 13)),
          IconButton(
            icon: const Icon(Icons.book, color: stichSecondary),
            tooltip: '单词本',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => VocabBookDialog(allWords: _allWords, storage: _storage, speech: _speech),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events, color: stichTertiary),
            tooltip: '成就',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AchievementDialog(unlockedAchievements: _storage.unlockedAchievements),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.palette, color: stichTertiary),
            tooltip: '换背景',
            onPressed: widget.onThemeToggle,
          ),
          IconButton(
            icon: const Icon(Icons.record_voice_over, color: stichSecondary),
            tooltip: '语音设置',
            onPressed: _showVoiceSettings,
          ),
        ],
      ),
    );
  }

  // ==================== 选择器 ====================
  Widget _buildModeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _modeBtn('按级别学习', 'level'),
          const SizedBox(width: 8),
          _modeBtn('按主题学习', 'topic'),
        ],
      ),
    );
  }

  Widget _modeBtn(String label, String mode) {
    final active = _currentMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentMode = mode;
          if (mode == 'topic' && _currentTopic.isEmpty && _topics.isNotEmpty) {
            _currentTopic = _topics.first;
          }
          _statsFilter = null;
          _filterWords();
          _saveProgress();
        });
        _cardAnimController.forward(from: 0);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? stichPrimary : Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildLevelSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ['黑1', '蓝2', '红3'].map((level) {
          final active = _currentLevel == level;
          final color = levelColors[level] ?? Colors.grey;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () {
                _animateCard(() {
                  setState(() {
                    _currentLevel = level;
                    _statsFilter = null;
                    _filterWords();
                    _saveProgress();
                  });
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: active
                      ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]
                      : [],
                ),
                transform: active ? (Matrix4.identity()..scale(1.1)) : Matrix4.identity(),
                child: Text(level,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopicSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _currentTopic.isEmpty ? null : _currentTopic,
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: stichSurfaceContainer, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: const BorderSide(color: stichSurfaceContainer, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        isExpanded: true,
        hint: const Text('请选择主题'),
        items: _topics.map((t) => DropdownMenuItem(value: t, child: Text(t, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: (v) {
          if (v == null) return;
          _animateCard(() {
            setState(() {
              _currentTopic = v;
              _statsFilter = null;
              _filterWords();
              _saveProgress();
            });
          });
        },
      ),
    );
  }

  List<Widget> _buildLevelButtonsVertical([bool isPad = false]) {
    return ['黑1', '蓝2', '红3'].map((level) {
      final active = _currentLevel == level;
      final color = levelColors[level] ?? Colors.grey;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: isPad ? 5 : 3),
        child: GestureDetector(
          onTap: () {
            _animateCard(() {
              setState(() {
                _currentLevel = level;
                _statsFilter = null;
                _filterWords();
                _saveProgress();
              });
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: isPad ? 14 : 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
              boxShadow: active ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 8)] : [],
              border: active ? Border.all(color: Colors.white, width: 2) : null,
            ),
            child: Text(level,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isPad ? 18 : 14)),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTopicSelectorCompact() {
    return DropdownButtonFormField<String>(
      value: _currentTopic.isEmpty ? null : _currentTopic,
      decoration: InputDecoration(
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: stichSurfaceContainer, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: stichSurfaceContainer, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        isDense: true,
      ),
      isExpanded: true,
      hint: const Text('选择主题', style: TextStyle(fontSize: 13)),
      style: const TextStyle(fontSize: 13, color: Colors.black),
      items: _topics.map((t) => DropdownMenuItem(value: t, child: Text(t, overflow: TextOverflow.ellipsis))).toList(),
      onChanged: (v) {
        if (v == null) return;
        _animateCard(() {
          setState(() {
            _currentTopic = v;
            _statsFilter = null;
            _filterWords();
            _saveProgress();
          });
        });
      },
    );
  }

  // ==================== 横屏左侧 Tab 风格 ====================
  Widget _tabItem(String label, String mode, bool isPad) {
    final active = _currentMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentMode = mode;
          if (mode == 'topic' && _currentTopic.isEmpty && _topics.isNotEmpty) {
            _currentTopic = _topics.first;
          }
          _statsFilter = null;
          _filterWords();
          _saveProgress();
        });
        _cardAnimController.forward(from: 0);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isPad ? 10 : 7),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: active
              ? [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 1))]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isPad ? 15 : 13,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            color: active ? stichPrimary : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelList(bool isPad) {
    return ListView(
      padding: EdgeInsets.zero,
      children: ['黑1', '蓝2', '红3'].map((level) {
        final active = _currentLevel == level;
        final color = levelColors[level] ?? Colors.grey;
        // 计算该级别的统计
        final words = _allWords.where((w) => w.level == level).toList();
        final masteredCount = words.where((w) => _storage.isMastered(w.id)).length;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: isPad ? 4 : 3),
          child: GestureDetector(
            onTap: () {
              _animateCard(() {
                setState(() {
                  _currentLevel = level;
                  _statsFilter = null;
                  _filterWords();
                  _saveProgress();
                });
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: isPad ? 14 : 10, horizontal: 12),
              decoration: BoxDecoration(
                color: active ? color : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: active ? null : Border.all(color: Colors.grey[300]!),
                boxShadow: active
                    ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))]
                    : [],
              ),
              child: Row(
                children: [
                  Container(
                    width: isPad ? 10 : 8,
                    height: isPad ? 10 : 8,
                    decoration: BoxDecoration(color: active ? Colors.white : color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      level,
                      style: TextStyle(
                        color: active ? Colors.white : Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: isPad ? 16 : 13,
                      ),
                    ),
                  ),
                  Text(
                    '$masteredCount/${words.length}',
                    style: TextStyle(
                      color: active ? Colors.white70 : Colors.grey[500],
                      fontSize: isPad ? 12 : 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopicList(bool isPad) {
    return ListView(
      padding: EdgeInsets.zero,
      children: _topics.map((topic) {
        final active = _currentTopic == topic;
        final words = _allWords.where((w) => w.topic == topic).toList();
        final masteredCount = words.where((w) => _storage.isMastered(w.id)).length;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: isPad ? 3 : 2),
          child: GestureDetector(
            onTap: () {
              _animateCard(() {
                setState(() {
                  _currentTopic = topic;
                  _statsFilter = null;
                  _filterWords();
                  _saveProgress();
                });
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: isPad ? 12 : 8, horizontal: 10),
              decoration: BoxDecoration(
                color: active ? stichPrimary : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: active ? null : Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      topic,
                      style: TextStyle(
                        color: active ? Colors.white : Colors.grey[800],
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        fontSize: isPad ? 13 : 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '$masteredCount/${words.length}',
                    style: TextStyle(
                      color: active ? Colors.white70 : Colors.grey[500],
                      fontSize: isPad ? 11 : 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ==================== 卡片区域 ====================
  Widget _buildCardArea(bool isLandscape) {
    if (_filteredWords.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('暂无单词', style: TextStyle(fontSize: 18)),
            if (_statsFilter != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => _toggleStatsFilter(_statsFilter!),
                child: const Text('清除筛选'),
              ),
            ],
          ],
        ),
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPad = isLandscape ? screenWidth > 900 : (screenWidth > 600 || screenHeight > 900);
    // pad竖屏也展开卡片填满竖向空间
    final shouldExpand = isLandscape || isPad;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FadeTransition(
          opacity: _cardAnim,
          child: FlashcardWidget(
            word: _filteredWords[_currentIndex],
            isPlaying: _isPlaying,
            onPlay: _playWord,
            expandVertical: shouldExpand,
            isPad: isPad,
          ),
        ),
      ),
    );
  }

  // ==================== 按钮 ====================
  Widget _buildActionButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final compact = screenWidth < 360;
        final hPad = compact ? 8.0 : 12.0;
        final vPad = compact ? 7.0 : 9.0;
        final iconSz = compact ? 15.0 : 17.0;
        final fontSz = compact ? 12.0 : 14.0;
        final radius = compact ? 10.0 : 12.0;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionBtn(icon: Icons.arrow_back, label: '上一个', color: Colors.grey[600]!, onTap: _goBack, hPad: hPad, vPad: vPad, iconSz: iconSz, fontSz: fontSz, radius: 32),
              _actionBtn(icon: Icons.close, label: '不会', color: Colors.red, onTap: _markUnknown, hPad: hPad, vPad: vPad, iconSz: iconSz, fontSz: fontSz, radius: 32),
              _actionBtn(icon: Icons.volume_up, label: '发音', color: stichSecondary, onTap: _playWord, hPad: hPad, vPad: vPad, iconSz: iconSz, fontSz: fontSz, radius: 32),
              _actionBtn(icon: Icons.check, label: '会了', color: stichPrimary, onTap: _markMastered, hPad: hPad, vPad: vPad, iconSz: iconSz, fontSz: fontSz, radius: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _actionBtn({
    required IconData icon, required String label, required Color color,
    required VoidCallback onTap,
    double hPad = 12, double vPad = 9, double iconSz = 17,
    double fontSz = 14, double radius = 12,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: iconSz),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.white, fontSize: fontSz, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _actionBtnCompact({
    required IconData icon, required String label,
    required Color color, required VoidCallback onTap,
    bool isPad = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: isPad ? 14 : 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: isPad ? 26 : 18),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: Colors.white, fontSize: isPad ? 14 : 10, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// 需求1: 操作记录
class _ActionRecord {
  final int wordId;
  final String? previousState; // 'mastered', 'unknown', or null
  final int previousIndex;

  _ActionRecord({
    required this.wordId,
    this.previousState,
    required this.previousIndex,
  });
}
