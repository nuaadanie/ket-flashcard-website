import 'package:flutter/material.dart';

class AppThemeData {
  final String name;
  final String label;
  final List<Color> gradientColors;

  const AppThemeData({
    required this.name,
    required this.label,
    required this.gradientColors,
  });
}

const appThemes = [
  AppThemeData(
    name: 'forest',
    label: '森林',
    gradientColors: [Color(0xFFd1fae5), Color(0xFFa7f3d0)],
  ),
  AppThemeData(
    name: 'ocean',
    label: '海洋',
    gradientColors: [Color(0xFFdbeafe), Color(0xFF93c5fd)],
  ),
  AppThemeData(
    name: 'desert',
    label: '沙漠',
    gradientColors: [Color(0xFFfef3c7), Color(0xFFfde68a)],
  ),
  AppThemeData(
    name: 'eye-care-green',
    label: '护眼绿',
    gradientColors: [Color(0xFFe8f5e9), Color(0xFFc8e6c9)],
  ),
  AppThemeData(
    name: 'eye-care-blue',
    label: '护眼蓝',
    gradientColors: [Color(0xFFe3f2fd), Color(0xFFbbdefb)],
  ),
  AppThemeData(
    name: 'eye-care-yellow',
    label: '护眼黄',
    gradientColors: [Color(0xFFfff9c4), Color(0xFFfff59d)],
  ),
  AppThemeData(
    name: 'eye-care-gray',
    label: '护眼灰',
    gradientColors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
  ),
];

// Stich design colors
const stichPrimary = Color(0xFFff6b6b);     // 珊瑚红
const stichSecondary = Color(0xFF1dd1a1);    // 薄荷绿
const stichTertiary = Color(0xFFfeca57);     // 金黄
const stichSurface = Color(0xFFffffff);      // 纯白背景
const stichSurfaceContainer = Color(0xFFe5e7eb); // 浅灰边框
const stichOnSurface = Color(0xFF2d3436);    // 深色文字

const levelColors = {
  '黑1': Colors.black,
  '蓝2': Colors.blue,
  '红3': Colors.red,
};
