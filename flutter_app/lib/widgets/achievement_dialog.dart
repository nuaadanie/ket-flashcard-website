import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../models/app_theme.dart';

class AchievementDialog extends StatelessWidget {
  final List<String> unlockedAchievements;

  const AchievementDialog({
    super.key,
    required this.unlockedAchievements,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Dialog(
      backgroundColor: surfaceColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
        side: Border.fromSide(microBorder(context)),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 24 : 16,
        vertical: isLandscape ? 8 : 24,
      ),
      child: Container(
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * (isLandscape ? 0.92 : 0.8),
        ),
        padding: EdgeInsets.all(isLandscape ? 12 : 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('成就',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(
                  '${unlockedAchievements.length}/${achievements.length}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isLandscape ? 4 : 2,
                  childAspectRatio: isLandscape ? 1.5 : 1.3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: achievements.length,
                itemBuilder: (ctx, i) {
                  final a = achievements[i];
                  final unlocked = unlockedAchievements.contains(a.id);
                  return _buildBadge(a, unlocked);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(Achievement achievement, bool unlocked) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: unlocked ? surfaceColor(context) : surfaceColor(context).withOpacity(0.5),
        borderRadius: BorderRadius.circular(kBorderRadius),
        border: Border.fromSide(microBorder(context)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            achievement.title.split(' ').first,
            style: TextStyle(
              fontSize: 28,
              color: unlocked ? null : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            achievement.title.substring(achievement.title.indexOf(' ') + 1),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: unlocked ? onSurfaceColor(context) : Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            unlocked ? achievement.description : '???',
            style: TextStyle(
              fontSize: 11,
              color: unlocked ? Colors.grey[600] : Colors.grey[400],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (!unlocked) ...[
            const SizedBox(height: 2),
            Icon(Icons.lock, size: 14, color: Colors.grey[400]),
          ],
        ],
      ),
    );
  }
}
