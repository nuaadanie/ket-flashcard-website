import 'package:flutter/material.dart';

enum AnimType {
  bounce,  // 垂直弹跳
  pulse,   // 缩放脉冲
  wave,    // 波浪形变
  rotate,  // 旋转
  slide,   // 往返滑动
  expand,  // 扩展收缩
  breathe, // 呼吸（缩放+透明度）
  sparkle, // 闪烁
  orbit,   // 环绕
  shake,   // 抖动
  morph,   // 形变
  flow,    // 流动
}

enum ShapeType {
  circle,
  rect,
  roundedRect,
  oval,
  triangle,
  star,
  diamond,
  heart,
  arrow,
  ring,
  cross,
  dot,
}

class VisualShape {
  final ShapeType type;
  final double x;       // 中心 x (0..1)
  final double y;       // 中心 y (0..1)
  final double w;       // 宽度 (0..1)
  final double h;       // 高度 (0..1)
  final Color color;
  final Color? strokeColor;
  final double? strokeWidth;
  final double? rotation; // 弧度

  const VisualShape({
    required this.type,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.color,
    this.strokeColor,
    this.strokeWidth,
    this.rotation,
  });
}

class WordVisual {
  final List<Color> palette;
  final List<VisualShape> shapes;
  final AnimType animType;
  final double animSpeed;
  final List<VisualShape>? animShapes;
  final Color? bgColor;

  const WordVisual({
    required this.palette,
    required this.shapes,
    required this.animType,
    this.animSpeed = 1.0,
    this.animShapes,
    this.bgColor,
  });
}
