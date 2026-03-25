import 'package:flutter/material.dart';
import 'models/app_theme.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KetFlashcardApp());
}

class KetFlashcardApp extends StatelessWidget {
  const KetFlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KET单词闪卡',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Quicksand',
        colorScheme: ColorScheme.fromSeed(
          seedColor: stichPrimary,
          primary: stichPrimary,
          secondary: stichSecondary,
          tertiary: stichTertiary,
          surface: stichSurface,
        ),
        scaffoldBackgroundColor: stichSurface,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Quicksand',
        colorScheme: ColorScheme.fromSeed(
          seedColor: stichPrimary,
          brightness: Brightness.dark,
          primary: stichPrimary,
          secondary: stichSecondary,
          tertiary: stichTertiary,
          surface: darkSurface,
        ),
        scaffoldBackgroundColor: darkSurface,
      ),
      home: const MainScreen(),
    );
  }
}
