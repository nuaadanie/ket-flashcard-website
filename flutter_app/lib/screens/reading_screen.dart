import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

  const ReadingScreen({
    super.key,
    required this.storage,
    required this.speech,
    required this.themeIndex,
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: appThemes[widget.themeIndex].colorsFor(Theme.of(context).brightness),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildLevelTabs(),
              Expanded(
                child: _filtered.isEmpty
                    ? const Center(child: Text('加载中...'))
                    : isLandscape
                        ? _buildLandscapeGrid()
                        : _buildPortraitGrid(),
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
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: stichPrimary)),
          const Spacer(),
          Text('${_filtered.length} 篇文章',
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
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
                  color: active ? color : surfaceColor(context),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  border: active ? null : Border.fromBorderSide(microBorder(context)),
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

  /// Bento Grid: portrait uses staggered 2-column masonry
  Widget _buildPortraitGrid() {
    return MasonryGridView.count(
      padding: const EdgeInsets.all(12),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: _filtered.length,
      itemBuilder: (ctx, i) => _buildArticleCard(_filtered[i]),
    );
  }

  Widget _buildLandscapeGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
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
        Navigator.of(context, rootNavigator: true).push(
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
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor(context),
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: Border.fromBorderSide(microBorder(context)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Level accent bar
            Container(
              height: 4,
              color: color,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: onSurfaceColor(context),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isRead)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.check_circle,
                              color: stichSecondary, size: 18),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: Text(
                          article.level,
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${article.paragraphs.length}段',
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
