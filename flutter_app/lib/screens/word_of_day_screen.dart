import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/word.dart';
import '../models/app_theme.dart';
import '../services/storage_service.dart';
import '../services/speech_service.dart';
import '../data/word_illustrations.dart';
import '../widgets/word_illustration_widget.dart';

class WordOfDayScreen extends StatefulWidget {
  final StorageService storage;
  final SpeechService speech;
  final int themeIndex;
  final VoidCallback onThemeToggle;

  const WordOfDayScreen({
    super.key,
    required this.storage,
    required this.speech,
    required this.themeIndex,
    required this.onThemeToggle,
  });

  @override
  State<WordOfDayScreen> createState() => _WordOfDayScreenState();
}

class _WordOfDayScreenState extends State<WordOfDayScreen> {
  List<Word> _allWords = [];
  Word? _word;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jsonStr = await rootBundle.loadString('assets/words.json');
    final data = WordData.fromJson(jsonDecode(jsonStr));
    _allWords = data.words;
    _pickWord();
    setState(() {});
  }

  void _pickWord() {
    if (_allWords.isEmpty) return;
    // Pick a random verb or adjective that has an illustration
    final candidates = _allWords
        .where((w) =>
            (w.topic.startsWith('Verbs') || w.topic.startsWith('Adjectives')) &&
            wordIllustrations.containsKey(w.word.toLowerCase()))
        .toList();
    if (candidates.isEmpty) {
      _word = _allWords.first;
      return;
    }
    candidates.shuffle();
    _word = candidates.first;
  }

  Future<void> _play(String text) async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    await widget.speech.speak(text);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = appThemes[widget.themeIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: theme.colorsFor(Theme.of(context).brightness),
          ),
        ),
        child: SafeArea(
          child: _word == null
              ? const Center(child: CircularProgressIndicator())
              : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final w = _word!;
    final levelColor = levelColors[w.level] ?? Colors.grey;
    final illustration = wordIllustrations[w.word.toLowerCase()];

    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // 单词插画（手绘CustomPaint动画）
              if (illustration != null)
                Center(
                  child: WordIllustrationWidget(
                    illustration: illustration,
                    word: w.word.toLowerCase(),
                    size: 200,
                  ),
                ),
              const SizedBox(height: 16),
              // 单词卡片
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: surfaceColor(context),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  border: Border.fromBorderSide(microBorder(context)),
                ),
                child: Column(
                  children: [
                    // 标签行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: levelColor,
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                          child: Text(w.level, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: stichSecondary,
                            borderRadius: BorderRadius.circular(kBorderRadius),
                          ),
                          child: Text(w.topic, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 音标
                    Text(
                      w.phonetic,
                      style: TextStyle(
                        fontFamily: 'RobotoMono',
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[400]
                            : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 单词
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          w.word,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.2,
                            color: onSurfaceColor(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => _play(w.word),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: stichTertiary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isPlaying ? Icons.hourglass_top : Icons.volume_up,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // 释义
                    Text(
                      w.meaning,
                      style: TextStyle(fontSize: 20, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // 例句
              if (w.example.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: surfaceColor(context),
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    border: Border.fromBorderSide(microBorder(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.format_quote, color: stichTertiary, size: 20),
                          const SizedBox(width: 6),
                          Text('例句', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600])),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _play(w.example),
                            child: const Icon(Icons.volume_up, color: stichTertiary, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        w.example,
                        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, height: 1.5),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny, color: stichTertiary, size: 28),
          const SizedBox(width: 8),
          Text('今日一词',
              style: TextStyle(fontFamily: 'Quicksand', fontSize: 20, fontWeight: FontWeight.bold, color: stichTertiary)),
          const Spacer(),
          Text(
            '${DateTime.now().month}月${DateTime.now().day}日',
            style: TextStyle(fontSize: 13, color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
