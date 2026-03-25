import 'package:flutter/material.dart';

class AppThemeData {
  final String name;
  final String label;
  final List<Color> gradientColors;
  final List<Color> darkGradientColors;

  const AppThemeData({
    required this.name,
    required this.label,
    required this.gradientColors,
    required this.darkGradientColors,
  });

  List<Color> colorsFor(Brightness b) =>
      b == Brightness.dark ? darkGradientColors : gradientColors;
}

const appThemes = [
  AppThemeData(
    name: 'forest',
    label: '森林',
    gradientColors: [Color(0xFFd1fae5), Color(0xFFa7f3d0)],
    darkGradientColors: [Color(0xFF0d2818), Color(0xFF14432a)],
  ),
  AppThemeData(
    name: 'ocean',
    label: '海洋',
    gradientColors: [Color(0xFFdbeafe), Color(0xFF93c5fd)],
    darkGradientColors: [Color(0xFF0c1929), Color(0xFF152847)],
  ),
  AppThemeData(
    name: 'desert',
    label: '沙漠',
    gradientColors: [Color(0xFFfef3c7), Color(0xFFfde68a)],
    darkGradientColors: [Color(0xFF2a2210), Color(0xFF3d3218)],
  ),
  AppThemeData(
    name: 'eye-care-green',
    label: '护眼绿',
    gradientColors: [Color(0xFFe8f5e9), Color(0xFFc8e6c9)],
    darkGradientColors: [Color(0xFF0d1f12), Color(0xFF14301d)],
  ),
  AppThemeData(
    name: 'eye-care-blue',
    label: '护眼蓝',
    gradientColors: [Color(0xFFe3f2fd), Color(0xFFbbdefb)],
    darkGradientColors: [Color(0xFF0c1520), Color(0xFF122538)],
  ),
  AppThemeData(
    name: 'eye-care-yellow',
    label: '护眼黄',
    gradientColors: [Color(0xFFfff9c4), Color(0xFFfff59d)],
    darkGradientColors: [Color(0xFF252310), Color(0xFF35321a)],
  ),
  AppThemeData(
    name: 'eye-care-gray',
    label: '护眼灰',
    gradientColors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
    darkGradientColors: [Color(0xFF1a1a1a), Color(0xFF252525)],
  ),
];

// ── Brand colors (skills.md spec) ──────────────────────────────
const brandAccent = Color(0xFF5C6BC0);       // 柔和靛蓝
const stichPrimary = brandAccent;             // 主品牌色 = 靛蓝
const stichSecondary = Color(0xFF00897B);    // 青绿（语音/辅助操作）
const stichTertiary = Color(0xFFFFA000);     // 琥珀金（播放/高亮）

// ── Surfaces & text ────────────────────────────────────────────
const stichSurface = Color(0xFFF8F9FD);      // 陶瓷白（含 2% 蓝调，禁止纯白）
const darkSurface = Color(0xFF0F1115);       // 曜石黑（含 3% 深蓝调）
const stichSurfaceContainer = Color(0xFFe5e7eb); // 浅灰边框
const stichOnSurface = Color(0xFF1A1C1E);    // 深色文字（陶瓷白底色上）
const stichOnSurfaceDark = Color(0xFFE2E2E6); // 浅色文字（曜石黑底色上）

// ── Semantic colors ────────────────────────────────────────────
const knowBg = Color(0xFFE8F5E9);            // 会了背景
const knowText = Color(0xFF2E7D32);          // 会了文字
const unknownBg = Color(0xFFFFEBEE);         // 不会背景
const unknownText = Color(0xFFC62828);       // 不会文字

// ── Level colors ───────────────────────────────────────────────
const levelColors = {
  '黑1': Color(0xFF37474F), // 深灰蓝（禁止纯黑）
  '蓝2': Color(0xFF1E88E5), // 稍深的蓝（在陶瓷白上更清晰）
  '红3': Color(0xFFE53935), // 稍亮的红
};

// ── Shape & spacing ────────────────────────────────────────────
const kBorderRadius = 28.0;
const kSpacingLarge = 24.0;
const kSpacingXLarge = 32.0;
const kMicroBorder = BorderSide(color: Color(0x0A000000), width: 0.8); // black @ 4% opacity

// ── Animation ──────────────────────────────────────────────────
const kAnimCurve = Curves.easeOutQuart;
const kButtonScaleDown = 0.94;

// ── Dark micro-border ──────────────────────────────────────────
const kMicroBorderDark = BorderSide(color: Color(0x14FFFFFF), width: 0.8);

// ── Theme-aware helpers ────────────────────────────────────────
Color surfaceColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? darkSurface : stichSurface;

Color onSurfaceColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? stichOnSurfaceDark : stichOnSurface;

BorderSide microBorder(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? kMicroBorderDark : kMicroBorder;
