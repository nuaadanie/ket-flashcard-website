import 'package:flutter/material.dart';
import '../models/word_visual.dart';

/// 今日一词插画配置：为每个动词和形容词定义视觉效果。
final Map<String, WordVisual> wordVisuals = {
  'add': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'clap': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFB74D)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFB74D)),
    ],
    animType: AnimType.shake,
    animSpeed: 1.2,
  ),
  'clean': WordVisual(
    palette: [Color(0xFF00BCD4), Color(0xFFE0F7FA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF00BCD4)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE0F7FA)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 1.2,
  ),
  'complete': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFC8E6C9)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFC8E6C9)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'count': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF7986CB)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'like': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'look at': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCE93D8)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'love': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFFF5252)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'paint': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFFC107), Color(0xFF4CAF50), Color(0xFF2196F3)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.circle, x: 0.65, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.flow,
    animSpeed: 1.2,
  ),
  'pick up': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFA1887F)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFA1887F)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'point': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF607D8B)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'show': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFC107)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'start': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF8BC34A)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'stop': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFE57373)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFE57373)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'talk': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF2196F3)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'try': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFE082)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFFFE082)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'want': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFE1BEE7)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE1BEE7)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'wave': WordVisual(
    palette: [Color(0xFF03A9F4), Color(0xFF81D4FA)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.5, w: 0.6, h: 0.15, color: Color(0xFF03A9F4)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'call': WordVisual(
    palette: [Color(0xFF009688), Color(0xFF80CBC4)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF009688)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF80CBC4)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF009688)),
    ],
    animType: AnimType.shake,
    animSpeed: 1.2,
  ),
  'carry': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFBCAAA4)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFBCAAA4)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'change': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF9800)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.morph,
    animSpeed: 1.2,
  ),
  'climb': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF8D6E63)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF8D6E63)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'dress up': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFFCE4EC)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFCE4EC)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 1.2,
  ),
  'drop': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF90CAF9)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'dry': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF9C4)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFF9C4)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 1.2,
  ),
  'fix': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFFB0BEC5)],
    shapes: [
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFB0BEC5)),
    ],
    animType: AnimType.rotate,
    animSpeed: 1.2,
  ),
  'help': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFE91E63)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFE91E63)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'invite': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFE1BEE7)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE1BEE7)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'laugh': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFF176)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'look for': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF9FA8DA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF9FA8DA)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'move': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFF8A65)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'need': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFEF9A9A)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.12, h: 0.35, color: Color(0xFFF44336)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'practise': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF7986CB)),
    ],
    animType: AnimType.rotate,
    animSpeed: 1.2,
  ),
  'shop': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'shout': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFFF5252)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF5252)),
    ],
    animType: AnimType.shake,
    animSpeed: 1.2,
  ),
  'travel': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF81D4FA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF81D4FA)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'wait': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFBDBDBD)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'water': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF4FC3F7)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF4FC3F7)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'act': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFCE93D8)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 1.2,
  ),
  'agree': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFA5D6A7)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'appear': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFE082)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFE082)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'arrive': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'believe': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFE1BEE7)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE1BEE7)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'borrow': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFCC80)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'camp': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF8D6E63)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF8D6E63)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'chat': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF2196F3)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'cycle': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF90A4AE)),
    ],
    animType: AnimType.rotate,
    animSpeed: 1.2,
  ),
  'decide': WordVisual(
    palette: [Color(0xFF673AB7), Color(0xFFB39DDB)],
    shapes: [
        VisualShape(type: ShapeType.diamond, x: 0.5, y: 0.45, w: 0.35, h: 0.35, color: Color(0xFF673AB7)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFB39DDB)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'design': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFF8A65)),
    ],
    animType: AnimType.rotate,
    animSpeed: 1.2,
  ),
  'disappear': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'enter': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF81C784)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'win a competition': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFD54F)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 1.2,
  ),
  'explain': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF90CAF9)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF90CAF9)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF2196F3)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'explore': WordVisual(
    palette: [Color(0xFF00BCD4), Color(0xFF4DD0E1)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF00BCD4)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF4DD0E1)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'fetch': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFA1887F)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFA1887F)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'finish': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFC8E6C9)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFC8E6C9)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'follow': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFFB0BEC5)],
    shapes: [
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFB0BEC5)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF607D8B)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'guess': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCE93D8)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'happen': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFE082)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFE082)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'hate': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFEF5350)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFFEF5350)),
    ],
    animType: AnimType.shake,
    animSpeed: 1.2,
  ),
  'hope': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFFFC107)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'hurry': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF8A65)),
    ],
    animType: AnimType.shake,
    animSpeed: 1.2,
  ),
  'improve': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'invent': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFD54F)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 1.2,
  ),
  'lift': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFBCAAA4)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.roundedRect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFBCAAA4)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'look after': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'look like': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFCE93D8)),
    ],
    animType: AnimType.morph,
    animSpeed: 1.2,
  ),
  'mind': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF9FA8DA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF9FA8DA)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'mix': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFF2196F3), Color(0xFFFFC107)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF2196F3)),
    ],
    animType: AnimType.flow,
    animSpeed: 1.2,
  ),
  'post': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFD7CCC8)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFD7CCC8)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'prefer': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFCE93D8)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'prepare': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFCC80)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'pull': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF607D8B)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'push': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF607D8B)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'remember': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF7986CB)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'repair': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFFB0BEC5)],
    shapes: [
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFB0BEC5)),
    ],
    animType: AnimType.rotate,
    animSpeed: 1.2,
  ),
  'repeat': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF9FA8DA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF9FA8DA)),
        VisualShape(type: ShapeType.circle, x: 0.65, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.orbit,
    animSpeed: 1.2,
  ),
  'save': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFA5D6A7)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'sound': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFE1BEE7)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE1BEE7)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9C27B0)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'stay': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFFB0BEC5)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF607D8B)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'thank': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 1.2,
  ),
  'tidy': WordVisual(
    palette: [Color(0xFF00BCD4), Color(0xFF80DEEA)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF00BCD4)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF80DEEA)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 1.2,
  ),
  'touch': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFCC80)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'turn': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF607D8B)),
    ],
    animType: AnimType.rotate,
    animSpeed: 1.2,
  ),
  'turn off': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFBDBDBD)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'turn on': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'use': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFFFCC80)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'visit': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF90CAF9)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF90CAF9)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'whisper': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCFD8DC)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'whistle': WordVisual(
    palette: [Color(0xFF03A9F4), Color(0xFF81D4FA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF03A9F4)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF81D4FA)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'wish': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 1.2,
  ),
  'be': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'can': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'choose': WordVisual(
    palette: [Color(0xFF673AB7), Color(0xFFB39DDB)],
    shapes: [
        VisualShape(type: ShapeType.diamond, x: 0.5, y: 0.45, w: 0.35, h: 0.35, color: Color(0xFF673AB7)),
        VisualShape(type: ShapeType.diamond, x: 0.5, y: 0.45, w: 0.35, h: 0.35, color: Color(0xFFB39DDB)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'come': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'do': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFE082)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFFFE082)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'get': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF81C784)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'give': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'go to bed': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF7986CB)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'go to sleep': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF7986CB)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'have': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFEF9A9A)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFEF9A9A)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'have got': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFA5D6A7)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'hold': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFBCAAA4)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.roundedRect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFBCAAA4)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'let’s': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'make': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFF8A65)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'put': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFFB0BEC5)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFB0BEC5)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'say': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'see': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCE93D8)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'would like': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'be called': WordVisual(
    palette: [Color(0xFF009688), Color(0xFF80CBC4)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF009688)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF80CBC4)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'bring': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFA1887F)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFA1887F)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'build': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFCC80)),
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'buy': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'catch': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFE082)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFE082)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'catch (a bus)': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'feed': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFA5D6A7)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'get dressed': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'get off': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF90CAF9)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF90CAF9)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'get on': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF90CAF9)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF90CAF9)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'get undressed': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'get up': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFFFF176)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'grow': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'have': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFEF9A9A)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFEF9A9A)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'hide': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'lose': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFBDBDBD)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'mean': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF9FA8DA)],
    shapes: [
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.2, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'must': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFE57373)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.12, h: 0.35, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFE57373)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'put on': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'send': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.roundedRect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'take': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFBCAAA4)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFBCAAA4)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'take off': WordVisual(
    palette: [Color(0xFF03A9F4), Color(0xFF81D4FA)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF03A9F4)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF81D4FA)),
    ],
    animType: AnimType.bounce,
    animSpeed: 1.2,
  ),
  'teach': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF7986CB)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'think': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCE93D8)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF9C27B0)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'wake': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFF176)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'begin': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'break': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFEF5350)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFEF5350)),
    ],
    animType: AnimType.shake,
    animSpeed: 1.2,
  ),
  'burn': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF9800)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'feel': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'find out': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFD54F)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 1.2,
  ),
  'forget': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCFD8DC)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'go out': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF9FA8DA)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF9FA8DA)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'hear': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFE1BEE7)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE1BEE7)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9C27B0)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'keep': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFA1887F)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFA1887F)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'leave': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF90A4AE)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'let': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFA5D6A7)),
    ],
    animType: AnimType.expand,
    animSpeed: 1.2,
  ),
  'lie': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.breathe,
    animSpeed: 1.2,
  ),
  'make sure': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFC8E6C9)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFC8E6C9)),
    ],
    animType: AnimType.pulse,
    animSpeed: 1.2,
  ),
  'sell': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFFFCC80)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'speak': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF2196F3)),
    ],
    animType: AnimType.wave,
    animSpeed: 1.2,
  ),
  'spend': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF81C784)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'take': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFBCAAA4)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFBCAAA4)),
    ],
    animType: AnimType.slide,
    animSpeed: 1.2,
  ),
  'angry': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFD32F2F)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFD32F2F)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'beautiful': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1), Color(0xFFFFC107)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'big': WordVisual(
    palette: [Color(0xFFE65100), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE65100)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'black': WordVisual(
    palette: [Color(0xFF212121), Color(0xFF424242)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF212121)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'blue': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.oval, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'brown': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFA1887F)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.oval, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFA1887F)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'clean': WordVisual(
    palette: [Color(0xFF00BCD4), Color(0xFFE0F7FA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF00BCD4)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE0F7FA)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'closed': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF90A4AE)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'cool': WordVisual(
    palette: [Color(0xFF00BCD4), Color(0xFF80DEEA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF00BCD4)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF80DEEA)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'correct': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFC8E6C9)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFC8E6C9)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'dirty': WordVisual(
    palette: [Color(0xFF795548), Color(0xFF8D6E63)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF8D6E63)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF795548)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'double': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF7986CB)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'English': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'fantastic': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F), Color(0xFFFF5722)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFD54F)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'favourite': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'fun': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFF176)),
    ],
    animType: AnimType.bounce,
    animSpeed: 0.8,
  ),
  'funny': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFF9800)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.bounce,
    animSpeed: 0.8,
  ),
  'good': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF81C784)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'gray': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.oval, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFBDBDBD)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'great': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFA5D6A7), Color(0xFFFFC107)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'happy': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFF176)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.bounce,
    animSpeed: 0.8,
  ),
  'her': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFBCAAA4)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF795548)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'his': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'its': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF8A65)),
    ],
    animType: AnimType.morph,
    animSpeed: 0.8,
  ),
  'long': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF9FA8DA)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.expand,
    animSpeed: 0.8,
  ),
  'my': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'new': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFC8E6C9)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFC8E6C9)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'nice': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'OK': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9C27B0)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'old': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFBCAAA4)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFBCAAA4)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'open': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF81C784)),
    ],
    animType: AnimType.expand,
    animSpeed: 0.8,
  ),
  'orange': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFB74D)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'our': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'paper': WordVisual(
    palette: [Color(0xFF00BCD4), Color(0xFF80DEEA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF00BCD4)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'pink': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'purple': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFCE93D8)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'red': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFE57373)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'right': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'sad': WordVisual(
    palette: [Color(0xFF5C6BC0), Color(0xFF9FA8DA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF5C6BC0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF9FA8DA)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF5C6BC0)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'scary': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFF4A148C)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF4A148C)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'short': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'small': WordVisual(
    palette: [Color(0xFF03A9F4), Color(0xFF81D4FA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF03A9F4)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'sorry': WordVisual(
    palette: [Color(0xFF5C6BC0), Color(0xFF9FA8DA)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF5C6BC0)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF9FA8DA)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'their': WordVisual(
    palette: [Color(0xFF009688), Color(0xFF80CBC4)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF009688)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'ugly': WordVisual(
    palette: [Color(0xFF795548), Color(0xFF8D6E63)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFF8D6E63)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'white': WordVisual(
    palette: [Color(0xFFECEFF1), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFECEFF1)),
        VisualShape(type: ShapeType.oval, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFCFD8DC)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'yellow': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'young': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF81C784)),
    ],
    animType: AnimType.bounce,
    animSpeed: 0.8,
  ),
  'your': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFBCAAA4)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'afraid': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF7B1FA2)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'all': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF7986CB)),
        VisualShape(type: ShapeType.circle, x: 0.65, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.orbit,
    animSpeed: 0.8,
  ),
  'all right': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF81C784)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'asleep': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF5C6BC0)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'awake': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFF176)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'back': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF607D8B)),
    ],
    animType: AnimType.slide,
    animSpeed: 0.8,
  ),
  'bad': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFEF5350)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFFEF5350)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'best': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFD54F)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'better': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.bounce,
    animSpeed: 0.8,
  ),
  'blond(e)': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF9C4)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFF9C4)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'boring': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'bottom': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF90A4AE)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'brave': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFFF5722)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.diamond, x: 0.5, y: 0.45, w: 0.35, h: 0.4, color: Color(0xFFFF5722)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'brilliant': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176), Color(0xFFFF5722)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFF176)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'busy': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF8A65)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF5722)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'careful': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.12, h: 0.35, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFCC80)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'clever': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFCE93D8)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'cloudy': WordVisual(
    palette: [Color(0xFF90A4AE), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF90A4AE)),
        VisualShape(type: ShapeType.oval, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFCFD8DC)),
    ],
    animType: AnimType.wave,
    animSpeed: 0.8,
  ),
  'cold': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFFB3E5FC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFB3E5FC)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF2196F3)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'curly': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFCC80)),
    ],
    animType: AnimType.wave,
    animSpeed: 0.8,
  ),
  'dangerous': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFFF5722)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.12, h: 0.35, color: Color(0xFFFF5722)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'different': WordVisual(
    palette: [Color(0xFF673AB7), Color(0xFFE91E63), Color(0xFF4CAF50)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF673AB7)),
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.diamond, x: 0.5, y: 0.45, w: 0.35, h: 0.35, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.morph,
    animSpeed: 0.8,
  ),
  'difficult': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFE57373)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFFE57373)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'dry': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF9C4)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFF9C4)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'easy': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFC8E6C9)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFC8E6C9)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'exciting': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF9800), Color(0xFFFFC107)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'fair': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFF176)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'famous': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFD54F)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'fat': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'fine': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'first': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFD54F)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'frightened': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF7B1FA2)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'hot': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFFF5722)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF5722)),
    ],
    animType: AnimType.wave,
    animSpeed: 0.8,
  ),
  'huge': WordVisual(
    palette: [Color(0xFFE65100), Color(0xFFFF6D00)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE65100)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'hungry': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFCC80)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'ill': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFBDBDBD)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'last': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF90A4AE)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'little': WordVisual(
    palette: [Color(0xFF03A9F4), Color(0xFF81D4FA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF03A9F4)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'loud': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFFF5252)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5252)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF44336)),
    ],
    animType: AnimType.wave,
    animSpeed: 0.8,
  ),
  'naughty': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF8A65)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'pretty': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'quick': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF8A65)),
    ],
    animType: AnimType.slide,
    animSpeed: 0.8,
  ),
  'quiet': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCFD8DC)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'round': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.rotate,
    animSpeed: 0.8,
  ),
  'safe': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.diamond, x: 0.5, y: 0.45, w: 0.35, h: 0.4, color: Color(0xFFA5D6A7)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'second': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF9FA8DA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF9FA8DA)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'sick': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFBDBDBD)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'slow': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCFD8DC)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'square': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'straight': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF607D8B)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'strong': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFE57373)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE57373)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'sunny': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFF176)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFF176)),
    ],
    animType: AnimType.rotate,
    animSpeed: 0.8,
  ),
  'surprised': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFF5722)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF5722)),
    ],
    animType: AnimType.expand,
    animSpeed: 0.8,
  ),
  'sweet': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'tall': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.expand,
    animSpeed: 0.8,
  ),
  'terrible': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFB71C1C)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFFB71C1C)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'thin': WordVisual(
    palette: [Color(0xFF90A4AE), Color(0xFFB0BEC5)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF90A4AE)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'third': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFA1887F)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFA1887F)),
        VisualShape(type: ShapeType.circle, x: 0.65, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF795548)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'thirsty': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'tired': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFBDBDBD)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'weak': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'well': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFA5D6A7)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'wet': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF4FC3F7)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF4FC3F7)),
    ],
    animType: AnimType.bounce,
    animSpeed: 0.8,
  ),
  'windy': WordVisual(
    palette: [Color(0xFF03A9F4), Color(0xFF81D4FA)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.5, w: 0.6, h: 0.15, color: Color(0xFF03A9F4)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF81D4FA)),
    ],
    animType: AnimType.wave,
    animSpeed: 0.8,
  ),
  'worse': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFEF5350)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFEF5350)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'worst': WordVisual(
    palette: [Color(0xFFB71C1C), Color(0xFFF44336)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFB71C1C)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFFF44336)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'wrong': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFE57373)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFFE57373)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'alone': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'amazing': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFF5722), Color(0xFF9C27B0)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5722)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'bored': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFBDBDBD)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'broken': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFEF5350)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFEF5350)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'cheap': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'dark': WordVisual(
    palette: [Color(0xFF212121), Color(0xFF424242)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF212121)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF424242)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'dear': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'deep': WordVisual(
    palette: [Color(0xFF1565C0), Color(0xFF0D47A1)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF1565C0)),
        VisualShape(type: ShapeType.oval, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF0D47A1)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'delicious': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFFF5722), Color(0xFFFFC107)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF5722)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'early': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFF176)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'empty': WordVisual(
    palette: [Color(0xFFCFD8DC), Color(0xFFECEFF1)],
    shapes: [
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFCFD8DC)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'enormous': WordVisual(
    palette: [Color(0xFFE65100), Color(0xFFFF6D00)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE65100)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'excellent': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFD54F)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'excited': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF9800)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.bounce,
    animSpeed: 0.8,
  ),
  'expensive': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFD54F)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'extinct': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFBDBDBD)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'far': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF90CAF9)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF90CAF9)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'fast': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF8A65)),
    ],
    animType: AnimType.slide,
    animSpeed: 0.8,
  ),
  'foggy': WordVisual(
    palette: [Color(0xFF90A4AE), Color(0xFFB0BEC5)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF90A4AE)),
        VisualShape(type: ShapeType.oval, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFB0BEC5)),
        VisualShape(type: ShapeType.oval, x: 0.65, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF90A4AE)),
    ],
    animType: AnimType.wave,
    animSpeed: 0.8,
  ),
  'friendly': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'frightening': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFF4A148C)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF4A148C)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'front': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF90A4AE)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'full': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFB74D)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'furry': WordVisual(
    palette: [Color(0xFF795548), Color(0xFFA1887F)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFA1887F)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFA1887F)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'glass': WordVisual(
    palette: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFB3E5FC)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE1F5FE)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'gold': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFD54F)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'middle': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'half': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF9FA8DA)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'hard': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF455A64)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF455A64)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'heavy': WordVisual(
    palette: [Color(0xFF5D4037), Color(0xFF795548)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF5D4037)),
    ],
    animType: AnimType.bounce,
    animSpeed: 0.8,
  ),
  'high': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
    ],
    animType: AnimType.bounce,
    animSpeed: 0.8,
  ),
  'horrible': WordVisual(
    palette: [Color(0xFFB71C1C), Color(0xFFF44336)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFB71C1C)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFFF44336)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'important': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.12, h: 0.35, color: Color(0xFFFFD54F)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'interested': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCE93D8)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'interesting': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFE1BEE7)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFE1BEE7)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'kind': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'large': WordVisual(
    palette: [Color(0xFFE65100), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE65100)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'late': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF5C6BC0)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF5C6BC0)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'lazy': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.oval, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'left': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF607D8B)),
    ],
    animType: AnimType.slide,
    animSpeed: 0.8,
  ),
  'light': WordVisual(
    palette: [Color(0xFFFFF9C4), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFF9C4)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFF176)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'lovely': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1), Color(0xFFFFC107)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'low': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF90A4AE)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'lucky': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFFFC107)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'married': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFF48FB1)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFF48FB1)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'metal': WordVisual(
    palette: [Color(0xFF90A4AE), Color(0xFFB0BEC5)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF90A4AE)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFB0BEC5)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'missing': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCFD8DC)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'next': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF64B5F6)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF2196F3)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF64B5F6)),
    ],
    animType: AnimType.slide,
    animSpeed: 0.8,
  ),
  'noisy': WordVisual(
    palette: [Color(0xFFFF5722), Color(0xFFFF8A65)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF8A65)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5722)),
    ],
    animType: AnimType.wave,
    animSpeed: 0.8,
  ),
  'online': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF81C784)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'plastic': WordVisual(
    palette: [Color(0xFF2196F3), Color(0xFF90CAF9)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF2196F3)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'pleased': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFF176)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFF176)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.bounce,
    animSpeed: 0.8,
  ),
  'poor': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFFBDBDBD)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'popular': WordVisual(
    palette: [Color(0xFFE91E63), Color(0xFFFF5722)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE91E63)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5722)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFE91E63)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'racing': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFFF5722)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF5722)),
    ],
    animType: AnimType.slide,
    animSpeed: 0.8,
  ),
  'ready': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF81C784)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'rich': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFFD54F)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFFFD54F)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'right': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFFA5D6A7)],
    shapes: [
        VisualShape(type: ShapeType.arrow, x: 0.5, y: 0.45, w: 0.25, h: 0.4, color: Color(0xFF4CAF50)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'same': WordVisual(
    palette: [Color(0xFF3F51B5), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF3F51B5)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF7986CB)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'several': WordVisual(
    palette: [Color(0xFF673AB7), Color(0xFFB39DDB)],
    shapes: [
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF673AB7)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFB39DDB)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF673AB7)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'silver': WordVisual(
    palette: [Color(0xFFB0BEC5), Color(0xFFCFD8DC)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFB0BEC5)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFCFD8DC)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'soft': WordVisual(
    palette: [Color(0xFFE1BEE7), Color(0xFFF3E5F5)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFE1BEE7)),
        VisualShape(type: ShapeType.oval, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFFF3E5F5)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'sore': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFEF9A9A)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFEF9A9A)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'special': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFF9C27B0)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.circle, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF9C27B0)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'spotted': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFCC80)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFCC80)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'strange': WordVisual(
    palette: [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    shapes: [
        VisualShape(type: ShapeType.diamond, x: 0.5, y: 0.45, w: 0.35, h: 0.35, color: Color(0xFF9C27B0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFCE93D8)),
    ],
    animType: AnimType.morph,
    animSpeed: 0.8,
  ),
  'striped': WordVisual(
    palette: [Color(0xFF607D8B), Color(0xFF90A4AE)],
    shapes: [
        VisualShape(type: ShapeType.rect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF607D8B)),
        VisualShape(type: ShapeType.rect, x: 0.35, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF90A4AE)),
        VisualShape(type: ShapeType.rect, x: 0.65, y: 0.6, w: 0.15, h: 0.15, color: Color(0xFF607D8B)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'sure': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF81C784)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFF81C784)),
    ],
    animType: AnimType.pulse,
    animSpeed: 0.8,
  ),
  'tidy': WordVisual(
    palette: [Color(0xFF00BCD4), Color(0xFF80DEEA)],
    shapes: [
        VisualShape(type: ShapeType.roundedRect, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF00BCD4)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF80DEEA)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'unfriendly': WordVisual(
    palette: [Color(0xFF9E9E9E), Color(0xFF78909C)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF9E9E9E)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFF78909C)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'unhappy': WordVisual(
    palette: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF5C6BC0)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF7986CB)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF5C6BC0)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'unkind': WordVisual(
    palette: [Color(0xFFF44336), Color(0xFFEF5350)],
    shapes: [
        VisualShape(type: ShapeType.heart, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFF44336)),
        VisualShape(type: ShapeType.cross, x: 0.5, y: 0.45, w: 0.3, h: 0.3, color: Color(0xFFEF5350)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'untidy': WordVisual(
    palette: [Color(0xFF795548), Color(0xFF8D6E63)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF795548)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF8D6E63)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF795548)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'unusual': WordVisual(
    palette: [Color(0xFF673AB7), Color(0xFFB39DDB)],
    shapes: [
        VisualShape(type: ShapeType.diamond, x: 0.5, y: 0.45, w: 0.35, h: 0.35, color: Color(0xFF673AB7)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFB39DDB)),
    ],
    animType: AnimType.morph,
    animSpeed: 0.8,
  ),
  'warm': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.ring, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFCC80)),
    ],
    animType: AnimType.breathe,
    animSpeed: 0.8,
  ),
  'wild': WordVisual(
    palette: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    shapes: [
        VisualShape(type: ShapeType.triangle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFF4CAF50)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFF8BC34A)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
  'wonderful': WordVisual(
    palette: [Color(0xFFFFC107), Color(0xFFFF5722), Color(0xFF9C27B0)],
    shapes: [
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFFC107)),
        VisualShape(type: ShapeType.star, x: 0.5, y: 0.45, w: 0.5, h: 0.5, color: Color(0xFFFF5722)),
    ],
    animType: AnimType.sparkle,
    animSpeed: 0.8,
  ),
  'worried': WordVisual(
    palette: [Color(0xFFFF9800), Color(0xFFFFCC80)],
    shapes: [
        VisualShape(type: ShapeType.circle, x: 0.5, y: 0.45, w: 0.45, h: 0.45, color: Color(0xFFFF9800)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFFCC80)),
        VisualShape(type: ShapeType.dot, x: 0.5, y: 0.5, w: 0.15, h: 0.15, color: Color(0xFFFF9800)),
    ],
    animType: AnimType.shake,
    animSpeed: 0.8,
  ),
};