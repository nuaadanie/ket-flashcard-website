# KET单词闪卡 Flutter App

基于 web 版 ket-flashcard-website 重写的跨平台 Flutter 应用。

## 初始化项目

由于 Flutter 平台文件（android/、ios/、web/ 等）需要通过 Flutter CLI 生成，请按以下步骤操作：

```bash
# 1. 确保已安装 Flutter SDK
# https://docs.flutter.dev/get-started/install

# 2. 在 flutter_app 目录下生成平台文件
cd flutter_app
flutter create --org com.ket.flashcard .

# 3. 安装依赖
flutter pub get

# 4. 运行
flutter run                    # 连接的设备
flutter run -d chrome          # Web
flutter run -d windows         # Windows
flutter run -d macos           # macOS
```

## 功能

- 1702 个 KET 核心词汇闪卡
- 按级别（黑1/蓝2/红3）或按主题学习
- 语音播放（原生 TTS + 有道词典 fallback）
- 学习进度本地持久化
- 单词本（已会/不会/全部筛选）
- 7 种背景主题切换
- 支持 Android、iOS、Web、Windows、macOS、Linux

## 原始 Web 版

原始 web 代码备份在 `../web-original/` 目录。
