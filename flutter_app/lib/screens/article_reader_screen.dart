import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/word.dart';
import '../models/app_theme.dart';
import '../services/storage_service.dart';
import '../services/speech_service.dart';

class ArticleReaderScreen extends StatefulWidget {
  final Article article;
  final StorageService storage;
  final SpeechService speech;
  final int themeIndex;
  final List<Word> words;

  const ArticleReaderScreen({
    super.key,
    required this.article,
    required this.storage,
    required this.speech,
    required this.themeIndex,
    required this.words,
  });

  @override
  State<ArticleReaderScreen> createState() => _ArticleReaderScreenState();
}

class _ArticleReaderScreenState extends State<ArticleReaderScreen> {
  final Set<int> _expandedParagraphs = {};
  bool _isPlaying = false;
  double _fontSize = 18.0;
  late final Map<String, Word> _wordMap;

  @override
  void initState() {
    super.initState();
    _wordMap = {};
    for (final w in widget.words) {
      _wordMap[w.word.toLowerCase()] = w;
    }
    if (!widget.storage.readArticles.contains(widget.article.id)) {
      widget.storage.readArticles.add(widget.article.id);
      widget.storage.save();
    }
  }

  Word? _findWord(String keyword) {
    final w = _wordMap[keyword.toLowerCase()];
    if (w != null) return w;
    final k = keyword.toLowerCase();
    for (final entry in _wordMap.entries) {
      if (entry.key.contains(k) || k.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  Future<void> _playAll() async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    for (final p in widget.article.paragraphs) {
      if (!_isPlaying || !mounted) break;
      await widget.speech.speak(p.en);
      if (!_isPlaying || !mounted) break;
      await Future.delayed(const Duration(milliseconds: 400));
    }
    if (mounted) setState(() => _isPlaying = false);
  }

  Future<void> _playSentence(String text) async {
    await _stopPlaying();
    setState(() => _isPlaying = true);
    await widget.speech.speak(text);
    if (mounted) setState(() => _isPlaying = false);
  }

  Future<void> _stopPlaying() async {
    setState(() => _isPlaying = false);
    await widget.speech.stop();
  }

  void _showWordPopup(BuildContext context, String keyword) {
    final word = _findWord(keyword);
    Future.delayed(const Duration(milliseconds: 300), () {
      widget.speech.speak(keyword);
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surfaceColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          side: microBorder(context),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(keyword,
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: onSurfaceColor(context))),
            if (word != null && word.phonetic.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(word.phonetic,
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 18,
                      color: Colors.grey[600])),
            ],
            if (word != null && word.meaning.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: stichTertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(kBorderRadius),
                ),
                child: Text(word.meaning,
                    style: TextStyle(
                        fontSize: 20,
                        color: onSurfaceColor(context),
                        fontWeight: FontWeight.w500)),
              ),
            ],
            if (word != null) ...[
              const SizedBox(height: 8),
              Text('${word.level} · ${word.topic}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ],
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => widget.speech.speak(keyword),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                    color: stichTertiary, shape: BoxShape.circle),
                child:
                    const Icon(Icons.volume_up, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = levelColors[widget.article.level] ?? Colors.grey;

    return Scaffold(
      primary: true,
      body: Container(
        color: surfaceColor(context),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(color),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  itemCount: widget.article.paragraphs.length,
                  itemBuilder: (ctx, i) =>
                      _buildParagraph(i, widget.article.paragraphs[i]),
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              widget.article.title,
              style: const TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
            child: Text(widget.article.level,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.stop : Icons.play_circle_fill,
              color: stichTertiary,
              size: 32,
            ),
            tooltip: _isPlaying ? '停止朗读' : '朗读全文',
            onPressed: _isPlaying ? _stopPlaying : _playAll,
          ),
        ],
      ),
    );
  }

  Widget _buildParagraph(int index, Paragraph para) {
    final expanded = _expandedParagraphs.contains(index);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (expanded) {
            _expandedParagraphs.remove(index);
          } else {
            _expandedParagraphs.add(index);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: surfaceColor(context),
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: Border.fromSide(microBorder(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildEnglishText(para)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _playSentence(para.en),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(Icons.volume_up,
                        color: stichTertiary, size: 20),
                  ),
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: stichSecondary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(kBorderRadius),
                  ),
                  child: Text(
                    para.zh,
                    style: TextStyle(
                      fontSize: _fontSize - 2,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnglishText(Paragraph para) {
    if (para.keywords.isEmpty) {
      return Text(para.en,
          style: TextStyle(
              fontSize: _fontSize,
              height: 1.7,
              color: onSurfaceColor(context));
    }

    final text = para.en;
    final spans = <InlineSpan>[];
    int lastEnd = 0;

    final matches = <_Match>[];
    for (final kw in para.keywords) {
      final lower = text.toLowerCase();
      final kwLower = kw.toLowerCase();
      int start = 0;
      while (true) {
        final idx = lower.indexOf(kwLower, start);
        if (idx == -1) break;
        matches.add(_Match(idx, idx + kw.length, kw));
        start = idx + kw.length;
      }
    }
    matches.sort((a, b) => a.start.compareTo(b.start));

    final filtered = <_Match>[];
    for (final m in matches) {
      if (filtered.isEmpty || m.start >= filtered.last.end) {
        filtered.add(m);
      }
    }

    for (final m in filtered) {
      if (m.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, m.start),
          style: TextStyle(
              fontSize: _fontSize, height: 1.7, color: onSurfaceColor(context)),
        ));
      }
      final matched = text.substring(m.start, m.end);
      spans.add(WidgetSpan(
        child: GestureDetector(
          onTap: () => _showWordPopup(context, m.keyword),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: stichTertiary, width: 2),
              ),
            ),
            child: Text(
              matched,
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFb8860b),
                height: 1.7,
              ),
            ),
          ),
        ),
      ));
      lastEnd = m.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(
            fontSize: _fontSize, height: 1.7, color: onSurfaceColor(context)),
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('字号', style: TextStyle(fontSize: 13)),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 22),
            onPressed: () {
              if (_fontSize > 14) setState(() => _fontSize -= 2);
            },
          ),
          Text('${_fontSize.toInt()}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 22),
            onPressed: () {
              if (_fontSize < 28) setState(() => _fontSize += 2);
            },
          ),
          const SizedBox(width: 16),
          Text(
            '${widget.article.ketWordCount} 个KET单词',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}

class _Match {
  final int start;
  final int end;
  final String keyword;
  _Match(this.start, this.end, this.keyword);
}
