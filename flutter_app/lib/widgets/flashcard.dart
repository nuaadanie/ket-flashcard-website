import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/word.dart';
import '../models/app_theme.dart';

class FlashcardWidget extends StatefulWidget {
  final Word word;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback? onPlayExample;
  final bool expandVertical;
  final bool isPad;

  const FlashcardWidget({
    super.key,
    required this.word,
    required this.isPlaying,
    required this.onPlay,
    this.onPlayExample,
    this.expandVertical = false,
    this.isPad = false,
  });

  @override
  State<FlashcardWidget> createState() => FlashcardWidgetState();
}

class FlashcardWidgetState extends State<FlashcardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnim;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void resetMeaning() {
    if (mounted) {
      _flipController.reverse();
      _isFront = true;
    }
  }

  @override
  void didUpdateWidget(FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.word.id != widget.word.id) {
      _flipController.reset();
      _isFront = true;
    }
  }

  void _flip() {
    if (_flipController.isAnimating) return;
    if (_isFront) {
      _flipController.forward();
      _isFront = false;
    } else {
      _flipController.reverse();
      _isFront = true;
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

    final frontContent = Column(
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
          style: GoogleFonts.inter(
            fontSize: wordSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          '释义',
          style: TextStyle(
            fontSize: meaningSize,
            color: Colors.grey[350],
            decoration: TextDecoration.underline,
            decorationColor: Colors.grey[350],
          ),
          textAlign: TextAlign.center,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: widget.isPlaying ? null : widget.onPlay,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: playSize,
              height: playSize,
              decoration: BoxDecoration(
                color: widget.isPlaying ? stichTertiary.withOpacity(0.7) : stichTertiary,
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

    final backContent = Column(
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
          widget.word.meaning,
          style: TextStyle(fontSize: meaningSize, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
        if (widget.word.example.isNotEmpty) ...[
          SizedBox(height: widget.isPad ? 12 : 8),
          Text(
            widget.word.example,
            style: TextStyle(
              fontSize: meaningSize - 4,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: widget.isPlaying ? null : (widget.onPlayExample ?? widget.onPlay),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: playSize,
              height: playSize,
              decoration: BoxDecoration(
                color: widget.isPlaying ? stichTertiary.withOpacity(0.7) : stichTertiary,
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
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _flipAnim,
        builder: (context, child) {
          final angle = _flipAnim.value * pi;
          final isFrontVisible = angle < pi / 2;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateY(angle),
            child: isFrontVisible
                ? _buildCardFace(cardPadding, frontContent)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildCardFace(cardPadding, backContent),
                  ),
          );
        },
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

  Widget _buildCardFace(EdgeInsets padding, Widget content) {
    return Card(
      color: Colors.white,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(48),
        side: const BorderSide(color: stichSurfaceContainer, width: 4),
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
        borderRadius: BorderRadius.circular(24),
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
