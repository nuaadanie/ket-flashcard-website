import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/word.dart';
import '../models/app_theme.dart';
import '../services/storage_service.dart';
import '../services/speech_service.dart';
import '../widgets/word_illustration.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final unmastered = _allWords.where((w) => !widget.storage.isMastered(w.id)).toList();
    final pool = unmastered.isNotEmpty ? unmastered : _allWords;
    _word = pool[seed % pool.length];
  }

  Future<void> _play(String text) async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    await widget.speech.speak(text);
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _isPlaying = false);
  }

  String _getWiki(Word w) {
    if (w.wiki.isNotEmpty) return w.wiki;
    return '${w.word} 是 KET ${w.level} 级别词汇，属于"${w.topic}"主题。建议通过造句练习来加深记忆，在不同语境中理解它的用法。';
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

    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              // 插画对比：SVG(点击弹跳) vs CustomPaint(逐帧闪光)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      _AnimatedSvgDemo(),
                      const SizedBox(height: 4),
                      Text('SVG (点击弹跳)', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                  Column(
                    children: [
                      _AnimatedPaintDemo(),
                      const SizedBox(height: 4),
                      Text('CustomPaint (闪光)', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ],
                  ),
                ],
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
                        color: Colors.grey[500],
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
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
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
                          Text('例句', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600])),
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
              // 单词百科（数据保留，界面隐藏）
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
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),

        ],
      ),
    );
  }
}

// ─── SVG + Flutter动画：点击弹跳+摇晃 ───
class _AnimatedSvgDemo extends StatefulWidget {
  @override
  State<_AnimatedSvgDemo> createState() => _AnimatedSvgDemoState();
}

class _AnimatedSvgDemoState extends State<_AnimatedSvgDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 0.9), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.9, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _rotate = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.05, end: -0.05), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -0.05, end: 0.02), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 0.02, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onTap() {
    _ctrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: Transform.rotate(
              angle: _rotate.value,
              child: child,
            ),
          );
        },
        child: SizedBox(
          width: 140,
          height: 140,
          child: SvgPicture.asset(
            'assets/illustrations/surprise.svg',
            width: 140,
            height: 140,
          ),
        ),
      ),
    );
  }
}

// ─── CustomPaint + 逐帧动画：星星闪烁+盒子微动 ───
class _AnimatedPaintDemo extends StatefulWidget {
  @override
  State<_AnimatedPaintDemo> createState() => _AnimatedPaintDemoState();
}

class _AnimatedPaintDemoState extends State<_AnimatedPaintDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Reset animation on tap
        _ctrl.forward(from: 0);
      },
      child: SizedBox(
        width: 140,
        height: 140,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            return CustomPaint(
              painter: _AnimatedSurprisePainter(_ctrl.value),
            );
          },
        ),
      ),
    );
  }
}

class _AnimatedSurprisePainter extends CustomPainter {
  final double t; // 0..1 animation progress
  _AnimatedSurprisePainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final bounce = sin(t * pi * 2) * 3; // gentle vertical bounce

    canvas.save();
    canvas.translate(0, bounce);

    // Shadow (shrinks when box bounces up)
    final shadowScale = 1.0 - (bounce.abs() / 10);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.92 - bounce),
        width: w * 0.6 * shadowScale,
        height: h * 0.06 * shadowScale,
      ),
      Paint()..color = Colors.black.withOpacity(0.08),
    );

    // Box body
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.45, w * 0.64, h * 0.42),
      const Radius.circular(6),
    );
    canvas.drawRRect(boxRect, Paint()..color = const Color(0xFFFF6B6B));
    canvas.drawRRect(boxRect, Paint()..color = const Color(0xFFCC4444)..style = PaintingStyle.stroke..strokeWidth = 2);

    // Lid
    final lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.13, h * 0.38, w * 0.74, h * 0.1),
      const Radius.circular(4),
    );
    canvas.drawRRect(lidRect, Paint()..color = const Color(0xFFFF8888));
    canvas.drawRRect(lidRect, Paint()..color = const Color(0xFFCC4444)..style = PaintingStyle.stroke..strokeWidth = 2);

    // Ribbons
    canvas.drawRect(Rect.fromLTWH(w * 0.46, h * 0.38, w * 0.08, h * 0.49), Paint()..color = const Color(0xFFFFD93D));
    canvas.drawRect(Rect.fromLTWH(w * 0.13, h * 0.40, w * 0.74, h * 0.06), Paint()..color = const Color(0xFFFFD93D));

    // Bow
    final bowPaint = Paint()..color = const Color(0xFFFFD93D);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.38, h * 0.33), width: w * 0.2, height: h * 0.14), bowPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.62, h * 0.33), width: w * 0.2, height: h * 0.14), bowPaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.34), w * 0.04, Paint()..color = const Color(0xFFE6B800));

    // Exclamation
    final excPaint = Paint()..color = const Color(0xFFFF6B6B)..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.50, h * 0.08), Offset(w * 0.50, h * 0.22), excPaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.26), 2.5, excPaint);

    canvas.restore();

    // Sparkles with animated opacity (phase-shifted)
    _drawAnimSparkle(canvas, Offset(w * 0.12, h * 0.18), w * 0.06, const Color(0xFFFFD93D), t);
    _drawAnimSparkle(canvas, Offset(w * 0.85, h * 0.15), w * 0.05, const Color(0xFFFF6B6B), t + 0.33);
    _drawAnimSparkle(canvas, Offset(w * 0.08, h * 0.55), w * 0.04, const Color(0xFFFFD93D), t + 0.5);
    _drawAnimSparkle(canvas, Offset(w * 0.92, h * 0.60), w * 0.04, const Color(0xFFFF8888), t + 0.66);
  }

  void _drawAnimSparkle(Canvas canvas, Offset center, double r, Color color, double phase) {
    final opacity = ((sin((phase % 1.0) * pi * 2) + 1) / 2).clamp(0.0, 1.0);
    final scale = 0.5 + opacity * 0.5;
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final sr = r * scale;
    for (int i = 0; i < 4; i++) {
      final angle = i * pi / 4;
      canvas.drawLine(
        Offset(center.dx + cos(angle) * sr * 0.3, center.dy + sin(angle) * sr * 0.3),
        Offset(center.dx + cos(angle) * sr, center.dy + sin(angle) * sr),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AnimatedSurprisePainter old) => old.t != t;
}
