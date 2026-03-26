import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// CustomPaint illustrations for words.
/// Returns a widget for known words, or a default emoji-based fallback.
class WordIllustration extends StatelessWidget {
  final String word;
  final double size;

  const WordIllustration({super.key, required this.word, this.size = 120});

  static const _svgWords = {'surprise'};

  @override
  Widget build(BuildContext context) {
    final w = word.toLowerCase();

    // 1. Try SVG illustration
    if (_svgWords.contains(w)) {
      return SizedBox(
        width: size,
        height: size,
        child: SvgPicture.asset(
          'assets/illustrations/$w.svg',
          width: size,
          height: size,
        ),
      );
    }

    // 2. Try CustomPaint
    final painter = _getPainter(w);
    if (painter != null) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: painter),
      );
    }

    // 3. Fallback: emoji
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          _getEmoji(w),
          style: TextStyle(fontSize: size * 0.6),
        ),
      ),
    );
  }

  static CustomPainter? _getPainter(String word) {
    switch (word) {
      case 'surprise': return SurprisePainter();
      case 'online': return _OnlinePainter();
      default: return null;
    }
  }

  static String _getEmoji(String word) {
    const map = {
      'dog': '🐕', 'cat': '🐱', 'bird': '🐦', 'fish': '🐟',
      'house': '🏠', 'school': '🏫', 'book': '📚', 'music': '🎵',
      'water': '💧', 'food': '🍽️', 'family': '��‍👩‍👧‍👦', 'friend': '🤝',
      'hello': '👋', 'time': '⏰', 'sun': '☀️', 'rain': '🌧️',
      'happy': '😊', 'sad': '😢', 'love': '❤️', 'star': '⭐',
      'tree': '🌳', 'flower': '🌸', 'car': '🚗', 'bus': '🚌',
      'phone': '📱', 'computer': '💻', 'game': '🎮', 'sport': '⚽',
      'surprise': '🎁', 'online': '🌐', 'name': '📛',
    };
    return map[word] ?? '📝';
  }
}

// ─── Surprise: gift box with bow and sparkles ───
class SurprisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.92), width: w * 0.6, height: h * 0.06),
      Paint()..color = Colors.black.withOpacity(0.08),
    );

    // Box body
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.45, w * 0.64, h * 0.42),
      const Radius.circular(6),
    );
    canvas.drawRRect(boxRect, Paint()..color = const Color(0xFFFF6B6B));
    canvas.drawRRect(boxRect, Paint()..color = const Color(0xFFCC4444)..style = PaintingStyle.stroke..strokeWidth = 2);

    // Box lid
    final lidRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.13, h * 0.38, w * 0.74, h * 0.1),
      const Radius.circular(4),
    );
    canvas.drawRRect(lidRect, Paint()..color = const Color(0xFFFF8888));
    canvas.drawRRect(lidRect, Paint()..color = const Color(0xFFCC4444)..style = PaintingStyle.stroke..strokeWidth = 2);

    // Ribbon vertical
    canvas.drawRect(Rect.fromLTWH(w * 0.46, h * 0.38, w * 0.08, h * 0.49), Paint()..color = const Color(0xFFFFD93D));
    // Ribbon horizontal
    canvas.drawRect(Rect.fromLTWH(w * 0.13, h * 0.40, w * 0.74, h * 0.06), Paint()..color = const Color(0xFFFFD93D));

    // Bow
    final bowPaint = Paint()..color = const Color(0xFFFFD93D);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.38, h * 0.33), width: w * 0.2, height: h * 0.14), bowPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.62, h * 0.33), width: w * 0.2, height: h * 0.14), bowPaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.34), w * 0.04, Paint()..color = const Color(0xFFE6B800));

    // Sparkles
    _drawSparkle(canvas, Offset(w * 0.12, h * 0.18), w * 0.06, const Color(0xFFFFD93D));
    _drawSparkle(canvas, Offset(w * 0.85, h * 0.15), w * 0.05, const Color(0xFFFF6B6B));
    _drawSparkle(canvas, Offset(w * 0.08, h * 0.55), w * 0.04, const Color(0xFFFFD93D));
    _drawSparkle(canvas, Offset(w * 0.92, h * 0.60), w * 0.04, const Color(0xFFFF8888));

    // Exclamation marks
    final excPaint = Paint()..color = const Color(0xFFFF6B6B)..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.50, h * 0.08), Offset(w * 0.50, h * 0.22), excPaint);
    canvas.drawCircle(Offset(w * 0.50, h * 0.26), 2.5, excPaint);
  }

  void _drawSparkle(Canvas canvas, Offset center, double r, Color color) {
    final paint = Paint()..color = color..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final angle = i * pi / 4;
      canvas.drawLine(
        Offset(center.dx + cos(angle) * r * 0.3, center.dy + sin(angle) * r * 0.3),
        Offset(center.dx + cos(angle) * r, center.dy + sin(angle) * r),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Online: laptop with wifi signal ───
class _OnlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.9), width: w * 0.7, height: h * 0.06),
      Paint()..color = Colors.black.withOpacity(0.08),
    );

    // Laptop base
    final basePath = Path()
      ..moveTo(w * 0.15, h * 0.72)
      ..lineTo(w * 0.08, h * 0.82)
      ..quadraticBezierTo(w * 0.08, h * 0.86, w * 0.14, h * 0.86)
      ..lineTo(w * 0.86, h * 0.86)
      ..quadraticBezierTo(w * 0.92, h * 0.86, w * 0.92, h * 0.82)
      ..lineTo(w * 0.85, h * 0.72)
      ..close();
    canvas.drawPath(basePath, Paint()..color = const Color(0xFFB0BEC5));
    canvas.drawPath(basePath, Paint()..color = const Color(0xFF78909C)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Screen body
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.18, h * 0.28, w * 0.64, h * 0.44),
      const Radius.circular(6),
    );
    canvas.drawRRect(screenRect, Paint()..color = const Color(0xFF37474F));
    // Screen display
    final displayRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.22, h * 0.32, w * 0.56, h * 0.36),
      const Radius.circular(3),
    );
    canvas.drawRRect(displayRect, Paint()..color = const Color(0xFF4FC3F7));

    // Wifi arcs on screen
    final wifiCenter = Offset(w * 0.5, h * 0.55);
    final arcPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    for (int i = 1; i <= 3; i++) {
      final rect = Rect.fromCenter(center: wifiCenter, width: w * 0.1 * i, height: h * 0.08 * i);
      canvas.drawArc(rect, -pi * 0.75, pi * 0.5, false, arcPaint);
    }
    canvas.drawCircle(wifiCenter, 3, Paint()..color = Colors.white);

    // Globe icon hint
    final globePaint = Paint()..color = const Color(0xFF29B6F6)..strokeWidth = 1.5..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(w * 0.5, h * 0.15), w * 0.08, globePaint);
    canvas.drawLine(Offset(w * 0.42, h * 0.15), Offset(w * 0.58, h * 0.15), globePaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.15), width: w * 0.08, height: h * 0.12), globePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
