import 'package:flutter/material.dart';
import '../models/word.dart';
import '../models/app_theme.dart';
import '../services/speech_service.dart';

class WordOfDayCard extends StatefulWidget {
  final Word word;
  final SpeechService speech;

  const WordOfDayCard({
    super.key,
    required this.word,
    required this.speech,
  });

  @override
  State<WordOfDayCard> createState() => _WordOfDayCardState();
}

class _WordOfDayCardState extends State<WordOfDayCard> {
  bool _expanded = false;
  bool _isPlaying = false;

  Future<void> _play() async {
    if (_isPlaying) return;
    setState(() => _isPlaying = true);
    await widget.speech.speak(widget.word.word);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = levelColors[widget.word.level] ?? Colors.grey;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: surfaceColor(context),
          borderRadius: BorderRadius.circular(kBorderRadius),
          border: Border.fromSide(microBorder(context)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: stichTertiary,
                borderRadius: BorderRadius.circular(kBorderRadius),
              ),
              child: const Text(
                '今日一词',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.word.word,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: onSurfaceColor(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.word.phonetic,
                        style: const TextStyle(
                          fontFamily: 'RobotoMono',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: levelColor,
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: Text(
                          widget.word.level,
                          style: const TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    ],
                  ),
                  if (widget.word.example.isNotEmpty)
                    Text(
                      widget.word.example,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  if (_expanded) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.word.meaning,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
            GestureDetector(
              onTap: _isPlaying ? null : _play,
              child: Icon(
                _isPlaying ? Icons.hourglass_top : Icons.volume_up,
                color: stichSecondary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
