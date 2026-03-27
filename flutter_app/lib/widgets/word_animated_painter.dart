import 'dart:math';
import 'package:flutter/material.dart';
import '../models/word_visual.dart';

/// 通用动画插画 Widget：根据 WordVisual 配置渲染动画
class WordAnimatedIllustration extends StatefulWidget {
  final WordVisual visual;
  final double size;

  const WordAnimatedIllustration({
    super.key,
    required this.visual,
    this.size = 200,
  });

  @override
  State<WordAnimatedIllustration> createState() =>
      _WordAnimatedIllustrationState();
}

class _WordAnimatedIllustrationState extends State<WordAnimatedIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    final duration = (2000 / widget.visual.animSpeed).round();
    _ctrl = AnimationController(
      duration: Duration(milliseconds: duration.clamp(800, 4000)),
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
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            painter: _WordVisualPainter(widget.visual, _ctrl.value),
          );
        },
      ),
    );
  }
}

class _WordVisualPainter extends CustomPainter {
  final WordVisual visual;
  final double t;

  _WordVisualPainter(this.visual, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // 背景色（如果有）
    if (visual.bgColor != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, w, h),
          const Radius.circular(16),
        ),
        Paint()..color = visual.bgColor!,
      );
    }

    // 阴影底座
    _drawShadow(canvas, w, h);

    // 绘制静态形状
    for (final shape in visual.shapes) {
      _drawShape(canvas, w, h, shape, 1.0, 1.0);
    }

    // 绘制动画形状
    if (visual.animShapes != null) {
      final animOffset = _getAnimOffset(w, h);
      final animScale = _getAnimScale();
      final animAlpha = _getAnimAlpha();
      for (final shape in visual.animShapes!) {
        canvas.save();
        canvas.translate(animOffset.dx, animOffset.dy);
        _drawShape(canvas, w, h, shape, animScale, animAlpha);
        canvas.restore();
      }
    }

    // 应用全局动画效果
    _applyGlobalAnim(canvas, w, h);
  }

  void _drawShadow(Canvas canvas, double w, double h) {
    final shadowScale = 1.0 - (_getBounce().abs() / 20);
    if (shadowScale > 0.3) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.9),
          width: w * 0.5 * shadowScale,
          height: h * 0.04 * shadowScale,
        ),
        Paint()..color = Colors.black.withOpacity(0.06),
      );
    }
  }

  double _getBounce() {
    switch (visual.animType) {
      case AnimType.bounce:
        return sin(t * pi * 2) * 8;
      case AnimType.shake:
        return sin(t * pi * 8) * 3;
      default:
        return 0;
    }
  }

  Offset _getAnimOffset(double w, double h) {
    switch (visual.animType) {
      case AnimType.bounce:
        return Offset(0, sin(t * pi * 2) * h * 0.06);
      case AnimType.slide:
        return Offset(sin(t * pi * 2) * w * 0.1, 0);
      case AnimType.shake:
        return Offset(sin(t * pi * 8) * w * 0.03, 0);
      case AnimType.wave:
        return Offset(0, sin(t * pi * 2) * h * 0.04);
      case AnimType.orbit:
        final angle = t * pi * 2;
        return Offset(cos(angle) * w * 0.12, sin(angle) * h * 0.12);
      case AnimType.flow:
        return Offset(sin(t * pi * 2) * w * 0.08, cos(t * pi * 2) * h * 0.08);
      default:
        return Offset.zero;
    }
  }

  double _getAnimScale() {
    switch (visual.animType) {
      case AnimType.pulse:
        return 0.85 + sin(t * pi * 2) * 0.15;
      case AnimType.expand:
        final val = sin(t * pi * 2);
        return val > 0 ? 1.0 + val * 0.2 : 1.0 + val * 0.1;
      case AnimType.breathe:
        return 0.9 + sin(t * pi * 2) * 0.1;
      case AnimType.morph:
        return 0.8 + sin(t * pi * 2) * 0.2;
      default:
        return 1.0;
    }
  }

  double _getAnimAlpha() {
    switch (visual.animType) {
      case AnimType.breathe:
        return 0.6 + sin(t * pi * 2) * 0.4;
      case AnimType.sparkle:
        return (sin(t * pi * 2) + 1) / 2;
      default:
        return 1.0;
    }
  }

  void _applyGlobalAnim(Canvas canvas, double w, double h) {
    switch (visual.animType) {
      case AnimType.rotate:
        canvas.save();
        canvas.translate(w / 2, h / 2);
        canvas.rotate(t * pi * 2);
        canvas.translate(-w / 2, -h / 2);
        for (final shape in visual.shapes) {
          _drawShape(canvas, w, h, shape, 1.0, 0.7);
        }
        canvas.restore();
        break;
      case AnimType.sparkle:
        _drawSparkles(canvas, w, h);
        break;
      default:
        break;
    }
  }

  void _drawSparkles(Canvas canvas, double w, double h) {
    final rng = Random(42);
    for (int i = 0; i < 6; i++) {
      final cx = rng.nextDouble() * w;
      final cy = rng.nextDouble() * h;
      final phase = t + i * 0.17;
      final opacity = ((sin((phase % 1.0) * pi * 2) + 1) / 2).clamp(0.0, 1.0);
      final scale = 0.4 + opacity * 0.6;
      final r = w * 0.03 * scale;
      final color = visual.palette[i % visual.palette.length];
      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;
      for (int j = 0; j < 4; j++) {
        final angle = j * pi / 4;
        canvas.drawLine(
          Offset(cx + cos(angle) * r * 0.3, cy + sin(angle) * r * 0.3),
          Offset(cx + cos(angle) * r, cy + sin(angle) * r),
          paint,
        );
      }
    }
  }

  void _drawShape(Canvas canvas, double w, double h, VisualShape shape,
      double scale, double alpha) {
    final cx = shape.x * w;
    final cy = shape.y * h;
    final sw = shape.w * w * scale;
    final sh = shape.h * h * scale;

    canvas.save();
    if (shape.rotation != null) {
      canvas.translate(cx, cy);
      canvas.rotate(shape.rotation!);
      canvas.translate(-cx, -cy);
    }

    final color = alpha < 1.0
        ? shape.color.withOpacity((shape.color.opacity * alpha).clamp(0.0, 1.0))
        : shape.color;
    final paint = Paint()..color = color;

    switch (shape.type) {
      case ShapeType.circle:
        canvas.drawCircle(Offset(cx, cy), sw / 2, paint);
        break;
      case ShapeType.oval:
        canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: sw, height: sh), paint);
        break;
      case ShapeType.rect:
        canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: sw, height: sh), paint);
        break;
      case ShapeType.roundedRect:
        final rrect = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, cy), width: sw, height: sh),
          Radius.circular(sw * 0.2),
        );
        canvas.drawRRect(rrect, paint);
        break;
      case ShapeType.triangle:
        final path = Path()
          ..moveTo(cx, cy - sh / 2)
          ..lineTo(cx - sw / 2, cy + sh / 2)
          ..lineTo(cx + sw / 2, cy + sh / 2)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.star:
        _drawStar(canvas, cx, cy, sw / 2, sw / 4, 5, paint);
        break;
      case ShapeType.diamond:
        final path = Path()
          ..moveTo(cx, cy - sh / 2)
          ..lineTo(cx + sw / 2, cy)
          ..lineTo(cx, cy + sh / 2)
          ..lineTo(cx - sw / 2, cy)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.heart:
        _drawHeart(canvas, cx, cy, sw, sh, paint);
        break;
      case ShapeType.arrow:
        _drawArrow(canvas, cx, cy, sw, sh, paint);
        break;
      case ShapeType.ring:
        canvas.drawCircle(
          Offset(cx, cy),
          sw / 2,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = shape.strokeWidth ?? 3,
        );
        break;
      case ShapeType.cross:
        final cw = sw * 0.25;
        canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: sw, height: cw), paint);
        canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: cw, height: sh), paint);
        break;
      case ShapeType.dot:
        canvas.drawCircle(Offset(cx, cy), sw * 0.15, paint);
        break;
    }

    // stroke
    if (shape.strokeColor != null) {
      final strokePaint = Paint()
        ..color = shape.strokeColor!
        ..style = PaintingStyle.stroke
        ..strokeWidth = shape.strokeWidth ?? 2;
      switch (shape.type) {
        case ShapeType.circle:
          canvas.drawCircle(Offset(cx, cy), sw / 2, strokePaint);
          break;
        case ShapeType.roundedRect:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset(cx, cy), width: sw, height: sh),
              Radius.circular(sw * 0.2),
            ),
            strokePaint,
          );
          break;
        default:
          break;
      }
    }

    canvas.restore();
  }

  void _drawStar(Canvas canvas, double cx, double cy, double outerR,
      double innerR, int points, Paint paint) {
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = i * pi / points - pi / 2;
      final x = cx + cos(angle) * r;
      final y = cy + sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, double cx, double cy, double w, double h, Paint paint) {
    final path = Path();
    final hw = w / 2, hh = h / 2;
    path.moveTo(cx, cy + hh * 0.6);
    path.cubicTo(cx - hw * 1.2, cy - hh * 0.2, cx - hw * 0.5, cy - hh, cx, cy - hh * 0.3);
    path.cubicTo(cx + hw * 0.5, cy - hh, cx + hw * 1.2, cy - hh * 0.2, cx, cy + hh * 0.6);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawArrow(Canvas canvas, double cx, double cy, double w, double h, Paint paint) {
    final path = Path();
    final hw = w / 2, hh = h / 2;
    path.moveTo(cx - hw * 0.15, cy - hh);
    path.lineTo(cx + hw * 0.15, cy - hh);
    path.lineTo(cx + hw * 0.15, cy + hh * 0.2);
    path.lineTo(cx + hw * 0.5, cy + hh * 0.2);
    path.lineTo(cx, cy + hh);
    path.lineTo(cx - hw * 0.5, cy + hh * 0.2);
    path.lineTo(cx - hw * 0.15, cy + hh * 0.2);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WordVisualPainter old) =>
      old.t != t || old.visual != visual;
}
