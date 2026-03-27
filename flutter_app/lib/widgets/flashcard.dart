import 'package:flutter/material.dart';
import '../models/word.dart';
import '../models/app_theme.dart';

class FlashcardWidget extends StatefulWidget {
  final Word word;
  final bool isPlaying;
  final VoidCallback onPlay;
  final bool expandVertical;
  final bool isPad;

  const FlashcardWidget({
    super.key,
    required this.word,
    required this.isPlaying,
    required this.onPlay,
    this.expandVertical = false,
    this.isPad = false,
  });

  @override
  State<FlashcardWidget> createState() => FlashcardWidgetState();
}

class FlashcardWidgetState extends State<FlashcardWidget> with SingleTickerProviderStateMixin {
  // 0 = front (blurred), 1 = meaning, 2 = meaning + example
  int _showLevel = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  void resetMeaning() {
    if (mounted) {
      setState(() => _showLevel = 0);
    }
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id) {
      _showLevel = 0;
    }
  }

  void _singleTap() {
    setState(() {
      _showLevel = (_showLevel + 1) % 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final levelColor = levelColors[widget.word.level] ?? Colors.grey;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final double wordSize;
    final double meaningSize;
    final double phoneticSize;
    final double playSize;
    final double playIconSize;
    final double tagFontSize;
    final double tagHPad;
    final double tagVPad;
    final EdgeInsets cardPadding;

    if (widget.isPad) {
      wordSize = isLandscape ? 76.0 : 96.0;
      meaningSize = isLandscape ? 36.0 : 48.0;
      phoneticSize = isLandscape ? 32.0 : 36.0;
      playSize = isLandscape ? 64.0 : 72.0;
      playIconSize = isLandscape ? 36.0 : 40.0;
      tagFontSize = 18.0;
      tagHPad = 20.0;
      tagVPad = 10.0;
      cardPadding = isLandscape
          ? const EdgeInsets.fromLTRB(36, 24, 36, 24)
          : const EdgeInsets.fromLTRB(48, 48, 48, 36);
    } else {
      wordSize = isLandscape ? 36.0 : 44.0; // spec: 44.0
      meaningSize = isLandscape ? 16.0 : 20.0;
      phoneticSize = isLandscape ? 14.0 : 16.0;
      playSize = isLandscape ? 36.0 : 44.0;
      playIconSize = isLandscape ? 20.0 : 24.0;
      tagFontSize = 12.0;
      tagHPad = 12.0;
      tagVPad = 4.0;
      cardPadding = isLandscape
          ? const EdgeInsets.fromLTRB(16, 10, 16, 10)
          : const EdgeInsets.fromLTRB(24, 24, 24, 16);
    }

    final frontContent = Column(
      mainAxisSize: widget.expandVertical ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: widget.expandVertical
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _buildTag(widget.word.level, levelColor, tagFontSize, tagHPad, tagVPad),
            _buildTag(widget.word.topic, stichSecondary, tagFontSize, tagHPad, tagVPad),
          ],
        ),
        Text(
          widget.word.phonetic,
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: phoneticSize,
            color: Colors.grey[500],
          ),
        ),
        Text(
          widget.word.word,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: wordSize,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
            color: onSurfaceColor(context),
          ),
          textAlign: TextAlign.center,
        ),
        // Meaning: tap to reveal
        AnimatedCrossFade(
          firstChild: Text(
            '释义',
            style: TextStyle(
              fontSize: meaningSize - 4,
              color: Colors.grey[400],
            ),
            textAlign: TextAlign.center,
          ),
          secondChild: Text(
            widget.word.meaning,
            style: TextStyle(
              fontSize: meaningSize - 4,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          crossFadeState: _showLevel >= 1
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 20),
        ),
        // Example on double-tap
        AnimatedOpacity(
          opacity: _showLevel == 2 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          curve: kAnimCurve,
          child: Text(
            widget.word.example,
            style: TextStyle(
              fontSize: meaningSize - 4,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: widget.isPlaying ? null : widget.onPlay,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: playSize,
              height: playSize,
              decoration: BoxDecoration(
                color: widget.isPlaying
                    ? stichTertiary.withOpacity(0.7)
                    : stichTertiary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isPlaying ? Icons.hourglass_top : Icons.play_arrow,
                color: Colors.white,
                size: playIconSize,
              ),
            ),
          ),
        ),
      ],
    );

    final card = GestureDetector(
      onTap: _singleTap,
      child: _buildCardFace(cardPadding, frontContent),
    );

    if (widget.expandVertical) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: SizedBox.expand(child: card),
      );
    }
    return card;
  }

  Widget _buildCardFace(EdgeInsets padding, Widget content) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor(context), // ceramic white, no pure white
        borderRadius: BorderRadius.circular(kBorderRadius), // 28.0
        border: Border.fromBorderSide(microBorder(context)), // 0.8px @ 4% opacity
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: content,
      ),
    );
  }

  Widget _buildTag(String text, Color color, double fontSize, double hPad, double vPad) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
