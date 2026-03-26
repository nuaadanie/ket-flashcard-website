# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

KET（剑桥KET考试）单词闪卡学习应用。包含两个实现：
- **Flutter App**（`flutter_app/`）：当前主力代码，跨平台 Dart/Flutter 应用（v2.0.1+3），支持 Android/iOS/Web/Windows/macOS/Linux
- **原始 Web App**（根目录 + `web-original/`）：纯 HTML/CSS/JS 实现，已归档备用

## 常用命令

所有 Flutter 相关操作均在 `flutter_app/` 目录下执行：

```bash
cd flutter_app
flutter pub get                    # 安装依赖
flutter run                        # 运行到连接的设备
flutter run -d chrome              # Web 端运行
flutter test                       # 运行所有单元测试
flutter test test/models/word_test.dart   # 运行单个测试文件
flutter build apk --release        # 构建 Release APK
flutter analyze                    # 静态分析（使用 flutter_lints）
```

原始 Web 版无需构建，直接用 HTTP 服务器静态托管即可（如 `python -m http.server 8000`）。

**注意**：本地环境受限，不要在本地运行 `flutter run`、`flutter test` 或 `flutter build`。所有 Flutter 构建和测试由 GitHub Actions CI 自动执行。开发时仅做代码修改和 `flutter analyze` 静态分析。

## 架构

### Flutter App 代码结构

```
flutter_app/lib/
├── main.dart              # 入口：Material 3 + Quicksand 字体 + AppTheme 配色
├── models/                # 数据模型
│   ├── word.dart          # 词汇模型（level/topic/phonetic/syllables/mastery）
│   ├── article.dart       # 阅读文章模型
│   ├── achievement.dart   # 成就系统模型
│   └── app_theme.dart     # 主题常量（stichPrimary/stichSecondary 等品牌色）
├── screens/               # 页面
│   ├── main_screen.dart   # 底部导航 Shell（两个 Tab：闪卡 + 阅读）
│   ├── home_screen.dart   # 闪卡主页（按级别/按主题两种学习模式）
│   ├── reading_screen.dart# 阅读文章列表
│   └── article_reader_screen.dart  # 文章阅读器
├── services/              # 服务层
│   ├── storage_service.dart # shared_preferences 本地持久化
│   └── speech_service.dart  # flutter_tts + 有道词典在线 fallback
├── widgets/               # UI 组件
│   ├── flashcard.dart     # 核心闪卡组件
│   ├── vocab_book.dart    # 单词本（已会/不会/全部筛选）
│   ├── achievement_dialog.dart  # 成就弹窗
│   ├── streak_badge.dart  # 连续学习徽章
│   └── word_of_day_card.dart    # 每日一词卡片
└── assets/                # 静态资源
    ├── words.json         # 词汇数据（1702 个 KET 核心词汇）
    ├── articles.json      # 阅读文章数据
    └── fonts/             # 字体文件（Fredoka/Inter/Quicksand）
```

### 关键依赖

- `flutter_tts` (^4.0.2) — 文本转语音（有道在线 fallback 使用 `audioplayers`）
- `shared_preferences` (^2.2.2) — 本地持久化
- `google_fonts` (^6.1.0) — Quicksand 字体
- `pdf` + `printing` + `path_provider` — PDF 导出

### 数据流

1. 词汇/文章数据从 `assets/*.json` 打包，运行时加载解析
2. 用户学习进度（已会/不会单词 ID 列表）通过 `shared_preferences` 本地存储
3. 两种学习模式（按级别/按主题）的浏览进度独立存储，但「已会/不会」标记全局共享

## 开发规范

### 流程要求

根据 `CODING_RULES.md`，新需求必须走完整流程：
1. 需求确认 → `spec.md`
2. 设计确认 → `design.md`
3. 任务拆分 → `tasks.md`
4. 按 tasks.md 顺序执行，逐个标记完成

Bug 修复无需走此流程。

### Lint 配置

`flutter_app/analysis_options.yaml` 基于 `flutter_lints`，禁用了 `prefer_const_constructors` 和 `prefer_const_literals_to_create_immutables`。提交前运行 `flutter analyze` 检查。

### CI

GitHub Actions（`.github/workflows/build-apk.yml`）：push 到 `master` 且 `flutter_app/` 目录有变更时，自动运行 `flutter test` 然后 `flutter build apk --release`，APK 作为 artifact 上传保留 30 天。

### 词汇数据处理

根目录下的 Python 脚本（`parse_words.py`、`fix_words.py`、`generate_articles.py` 等）用于从原始 Word 文档解析和处理词汇/文章数据，最终输出到 `flutter_app/assets/`。
