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
          const HomeScreen(),
          ReadingScreen(
            storage: _storage,
            speech: _speech,
            themeIndex: _themeIndex,
            onThemeToggle: _toggleTheme,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        selectedItemColor: Colors.green[700],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.style),
            label: '单词',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: '阅读',
          ),
        ],
      ),
    );
  }
}
