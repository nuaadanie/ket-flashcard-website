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

class FlashcardWidgetState extends State<FlashcardWidget> {
  bool _meaningVisible = false;

  void resetMeaning() {
    if (mounted) setState(() => _meaningVisible = false);
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id) {
      _meaningVisible = false;
    }
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
      wordSize = isLandscape ? 80.0 : 100.0;
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
      wordSize = isLandscape ? 36.0 : 48.0;
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

    // 同样字体大小，隐藏时灰色，显示时正常色
    final meaningWidget = Text(
      _meaningVisible ? widget.word.meaning : '释义',
      style: TextStyle(
        fontSize: meaningSize,
        color: _meaningVisible ? Colors.grey[700] : Colors.grey[350],
      ),
      textAlign: TextAlign.center,
    );

    final content = Column(
      mainAxisSize: widget.expandVertical ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: widget.expandVertical
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTag(widget.word.level, levelColor, tagFontSize, tagHPad, tagVPad),
            Flexible(child: _buildTag(widget.word.topic, Colors.green, tagFontSize, tagHPad, tagVPad)),
          ],
        ),
        Text(
          widget.word.phonetic,
          style: TextStyle(fontSize: phoneticSize, color: Colors.grey[600]),
        ),
        Text(
          widget.word.word,
          style: TextStyle(
            fontSize: wordSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
          textAlign: TextAlign.center,
        ),
        meaningWidget,
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: widget.isPlaying ? null : widget.onPlay,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: playSize,
              height: playSize,
              decoration: BoxDecoration(
                color: widget.isPlaying ? Colors.orange[300] : Colors.orange,
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
      onTap: () => setState(() => _meaningVisible = !_meaningVisible),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: cardPadding,
          child: content,
        ),
      ),
    );

    if (widget.expandVertical) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: SizedBox.expand(child: card),
      );
    }
    return card;
  }

  Widget _buildTag(String text, Color color, double fontSize, double hPad, double vPad) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
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
