import 'package:flutter/material.dart';
import '../models/app_theme.dart';

class StreakBadge extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;
  final VoidCallback? onTap;

  const StreakBadge({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (currentStreak == 0) return const SizedBox.shrink();
    return GestureDetector(
      onTap: onTap ?? () => _showStreakInfo(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: stichTertiary,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: stichTertiary.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔥', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '$currentStreak天',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStreakInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
          side: const BorderSide(color: stichSurfaceContainer, width: 3),
        ),
        title: const Text('🔥 连续学习'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('当前连续：$currentStreak 天',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('最佳记录：$bestStreak 天',
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
