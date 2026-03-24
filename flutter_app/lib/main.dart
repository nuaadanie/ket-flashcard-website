import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/app_theme.dart';
import 'screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const KetFlashcardApp());
}

class KetFlashcardApp extends StatelessWidget {
  const KetFlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KET单词闪卡',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.quicksandTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: stichPrimary,
          primary: stichPrimary,
          secondary: stichSecondary,
          tertiary: stichTertiary,
          surface: stichSurface,
        ),
        scaffoldBackgroundColor: stichSurface,
      ),
      home: const MainScreen(),
    );
  }
}
