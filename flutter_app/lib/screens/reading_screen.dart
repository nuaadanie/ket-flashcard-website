import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/article.dart';
import '../models/word.dart';
import '../models/app_theme.dart';
import '../services/storage_service.dart';
import '../services/speech_service.dart';
import 'article_reader_screen.dart';

class ReadingScreen extends StatefulWidget {
  final StorageService storage;
  final SpeechService speech;
  final int themeIndex;
  final VoidCallback onThemeToggle;

  const ReadingScreen({
    super.key,
    required this.storage,
    required this.speech,
    required this.themeIndex,
    required this.onThemeToggle,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  List<Article> _allArticles = [];
  List<Word> _allWords = [];
  String _currentLevel = '黑1';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final articlesStr = await rootBundle.loadString('assets/articles.json');
    final articlesData = jsonDecode(articlesStr) as Map<String, dynamic>;
    final articles = (articlesData['articles'] as List<dynamic>)
        .map((e) => Article.fromJson(e as Map<String, dynamic>))
        .toList();

    final wordsStr = await rootBundle.loadString('assets/words.json');
    final wordsData = jsonDecode(wordsStr) as Map<String, dynamic>;
    final words = (wordsData['words'] as List<dynamic>)
        .map((e) => Word.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _allArticles = articles;
      _allWords = words;
    });
  }

  List<Article> get _filtered =>
      _allArticles.where((a) => a.level == _currentLevel).toList();

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        color: stichSurface,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildLevelTabs(),
              Expanded(
                child: _filtered.isEmpty
                    ? const Center(child: Text('加载中...'))
                    : isLandscape
                        ? _buildLandscapeList()
                        : _buildPortraitList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.auto_stories, color: stichPrimary, size: 28),
          const SizedBox(width: 8),
          Text('KET阅读',
              style: GoogleFonts.fredoka(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: stichPrimary)),
          const Spacer(),
          Text('${_filtered.length} 篇文章',
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          IconButton(
            icon: const Icon(Icons.palette, color: stichTertiary),
            tooltip: '换背景',
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ['黑1', '蓝2', '红3'].map((level) {
          final active = _currentLevel == level;
          final color = levelColors[level] ?? Colors.grey;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: GestureDetector(
              onTap: () => setState(() => _currentLevel = level),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  color: active ? color : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: active ? null : Border.all(color: stichSurfaceContainer, width: 2),
                  boxShadow: active
                      ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)]
                      : [],
                ),
                child: Text(level,
                    style: TextStyle(
                      color: active ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPortraitList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filtered.length,
      itemBuilder: (ctx, i) => _buildArticleCard(_filtered[i]),
    );
  }

  Widget _buildLandscapeList() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _filtered.length,
      itemBuilder: (ctx, i) => _buildArticleCard(_filtered[i]),
    );
  }

  Widget _buildArticleCard(Article article) {
    final color = levelColors[article.level] ?? Colors.grey;
    final isRead = widget.storage.readArticles.contains(article.id);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleReaderScreen(
              article: article,
              storage: widget.storage,
              speech: widget.speech,
              themeIndex: widget.themeIndex,
              words: _allWords,
            ),
          ),
        );
      },
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
          side: const BorderSide(color: stichSurfaceContainer, width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.article, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(article.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      '${article.paragraphs.length} 段 · ${article.ketWordCount} 个KET单词',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              if (isRead)
                const Icon(Icons.check_circle, color: stichSecondary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}
