import 'package:flutter/material.dart';
import '../models/app_theme.dart';
import '../services/storage_service.dart';
import '../services/speech_service.dart';
import 'home_screen.dart';
import 'reading_screen.dart';
import 'word_of_day_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentTab = 0;
  late PageController _pageController;
  final StorageService _storage = StorageService();
  final SpeechService _speech = SpeechService();
  int _themeIndex = 0;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _init();
  }

  Future<void> _init() async {
    await _storage.init();
    await _speech.init();
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

  void _onPageChanged(int index) {
    setState(() => _currentTab = index);
  }

  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
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
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
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
          WordOfDayScreen(
            storage: _storage,
            speech: _speech,
            themeIndex: _themeIndex,
            onThemeToggle: _toggleTheme,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, Icons.style, '单词'),
              _buildNavItem(1, Icons.auto_stories, '阅读'),
              _buildNavItem(2, Icons.wb_sunny, '今日一词'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final active = _currentTab == index;
    return GestureDetector(
      onTap: () => _onNavTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: active ? stichPrimary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: active ? Border.all(color: stichPrimary.withOpacity(0.2), width: 1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: active ? stichPrimary : Colors.grey[400]),
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
