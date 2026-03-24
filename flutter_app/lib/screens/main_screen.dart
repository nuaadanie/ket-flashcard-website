import 'package:flutter/material.dart';
import '../models/app_theme.dart';
import '../services/storage_service.dart';
import '../services/speech_service.dart';
import 'home_screen.dart';
import 'reading_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTab = 0;
  final StorageService _storage = StorageService();
  final SpeechService _speech = SpeechService();
  int _themeIndex = 0;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _storage.init();
    await _speech.init();
    // 从存储恢复语音设置
    _speech.accent = _storage.accent;
    _speech.voice = _storage.voice;
    _themeIndex = appThemes.indexWhere((t) => t.name == _storage.theme);
    if (_themeIndex < 0) _themeIndex = 0;
    setState(() => _ready = true);
  }

  void _toggleTheme() {
    setState(() {
      _themeIndex = (_themeIndex + 1) % appThemes.length;
      _storage.theme = appThemes[_themeIndex].name;
      _storage.save();
    });
  }

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: [
          HomeScreen(
            themeIndex: _themeIndex,
            onThemeToggle: _toggleTheme,
          ),
          ReadingScreen(
            storage: _storage,
            speech: _speech,
            themeIndex: _themeIndex,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
              border: Border.all(color: stichSurfaceContainer, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, '🎴', '单词'),
                _buildNavItem(1, '📚', '阅读'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String emoji, String label) {
    final active = _currentTab == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTab = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: active ? stichPrimary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: active ? FontWeight.bold : FontWeight.w500,
                color: active ? stichPrimary : Colors.grey[500],
              ),
            ),
            if (active) ...[
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: stichPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
