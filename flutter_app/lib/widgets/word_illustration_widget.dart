import 'dart:math';
import 'package:flutter/material.dart';
import '../data/word_illustrations.dart';

/// 单词插画 Widget：根据单词名称调用手绘 CustomPaint 插画
class WordIllustrationWidget extends StatefulWidget {
  final WordIllustration illustration;
  final String? word;      // 单词名称，用于选择对应的手绘插画
  final double size;

  const WordIllustrationWidget({
    super.key,
    required this.illustration,
    this.word,
    this.size = 200,
  });

  @override
  State<WordIllustrationWidget> createState() => _WordIllustrationWidgetState();
}

class _WordIllustrationWidgetState extends State<WordIllustrationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return CustomPaint(
            key: ValueKey(widget.word),
            painter: WordIllustrationPainter(
              illustration: widget.illustration,
              word: widget.word,
              t: _ctrl.value,
              isDark: isDark,
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Painter
// ═══════════════════════════════════════════════════════════════════════════════

class WordIllustrationPainter extends CustomPainter {
  final WordIllustration illustration;
  final String? word;
  final double t;
  final bool isDark;

  WordIllustrationPainter({
    required this.illustration,
    required this.word,
    required this.t,
    this.isDark = false,
  });

  // ── dark mode helpers ───────────────────────────────────────────────────

  /// Boost opacity for dark mode visibility
  double _dop(double opacity) => isDark ? (opacity * 1.6).clamp(0.0, 1.0) : opacity;

  /// Adjusted color for contrast: lighten on dark bg, darken on light bg
  Color _dc(Color c) {
    if (isDark) {
      // Dark mode: shift 60% toward white for luminance on dark backgrounds
      final r = c.red + ((255 - c.red) * 0.6).round();
      final g = c.green + ((255 - c.green) * 0.6).round();
      final b = c.blue + ((255 - c.blue) * 0.6).round();
      return Color.fromARGB(255, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255));
    }
    // Light mode: shift 25% toward black for contrast on light backgrounds
    final r = (c.red * 0.75).round();
    final g = (c.green * 0.75).round();
    final b = (c.blue * 0.75).round();
    return Color.fromARGB(255, r.clamp(0, 255), g.clamp(0, 255), b.clamp(0, 255));
  }

  /// Dark-boosted paint: lighter color + thicker strokes
  Paint _dp(Paint p) {
    if (!isDark) return p;
    final boosted = Paint()
      ..color = _dc(p.color)
      ..style = p.style
      ..strokeWidth = p.strokeWidth * 1.4
      ..strokeCap = p.strokeCap
      ..strokeJoin = p.strokeJoin
      ..blendMode = p.blendMode;
    if (p.shader != null) boosted.shader = p.shader;
    if (p.maskFilter != null) boosted.maskFilter = p.maskFilter;
    return boosted;
  }

  /// White outline stroke for dark mode
  Paint get _outlineP => Paint()
    ..color = Colors.white.withOpacity(0.6)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3.0
    ..strokeCap = StrokeCap.round;

  /// Minimum opacity to ensure visibility on any background
  /// Preserves 0 opacity (intentional transparency, e.g. gradient endpoints)
  double _minOp(double opacity) {
    if (opacity == 0) return 0;
    if (isDark) return opacity.clamp(0.4, 1.0);
    return opacity.clamp(0.5, 1.0);
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  void _drawParticles(Canvas canvas, Size size) {
    final rng = Random(word?.hashCode ?? 0);
    for (int i = 0; i < 8; i++) {
      final bx = rng.nextDouble() * size.width;
      final by = rng.nextDouble() * size.height;
      final speed = 0.5 + rng.nextDouble() * 1.5;
      final phase = rng.nextDouble() * pi * 2;
      final dx = bx + sin(t * pi * 2 * speed + phase) * size.width * 0.04;
      final dy = by + cos(t * pi * 2 * speed + phase * 1.3) * size.height * 0.04;
      final baseOpacity = isDark ? 0.25 : 0.15;
      final swing = isDark ? 0.15 : 0.1;
      final opacity = (baseOpacity + sin(t * pi * 2 + phase) * swing).clamp(0.05, 0.5);
      final r = (2.0 + rng.nextDouble() * 3) * (size.width / 200);
      canvas.drawCircle(
        Offset(dx, dy), r,
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(opacity)),
      );
    }
  }

  // ── main paint ─────────────────────────────────────────────────────────────

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // 背景渐变 (very subtle in dark mode so shapes stand out)
    final bgOpacity1 = isDark ? 0.08 : 0.22;
    final bgOpacity2 = isDark ? 0.05 : 0.14;
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          _dc(illustration.bg).withOpacity(bgOpacity1),
          _dc(illustration.accent).withOpacity(bgOpacity2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), Radius.circular(w * 0.1)),
      bgPaint,
    );

    // 粒子 (brighter in dark mode)
    _drawParticles(canvas, size);

    // 呼吸光环
    final ringPhase = sin(t * pi * 2);
    final ringOpacity = isDark ? 0.12 : 0.07;
    canvas.drawCircle(
      Offset(w / 2, h / 2), w * (0.36 + ringPhase * 0.02),
      Paint()
        ..color = _dc(illustration.bg).withOpacity(ringOpacity + ringPhase * 0.04)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isDark ? 2.0 : 1.5,
    );

    // Dark mode: outer glow ring for extra clarity
    if (isDark) {
      canvas.drawCircle(
        Offset(w / 2, h / 2), w * 0.42,
        Paint()
          ..color = _dc(illustration.accent).withOpacity(0.06)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0,
      );
    }

    // Dark mode: soft radial glow behind illustration for luminous feel
    if (isDark) {
      final glowPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            _dc(illustration.accent).withOpacity(0.25),
            _dc(illustration.bg).withOpacity(0.10),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(w / 2, h / 2), radius: w * 0.45));
      canvas.drawCircle(Offset(w / 2, h / 2), w * 0.45, glowPaint);
    }

    // 动画偏移
    final animOff = _getAnimOffset(w, h);

    canvas.save();
    canvas.translate(animOff.dx, animOff.dy);

    // 调用对应的单词手绘方法
    final drawFn = _drawMap[word?.toLowerCase()];
    if (drawFn != null) {
      drawFn(canvas, size);
    } else {
      _drawFallback(canvas, size);
    }

    canvas.restore();
  }

  Offset _getAnimOffset(double w, double h) {
    switch (illustration.anim) {
      case IllustAnim.bounce:
        return Offset(0, sin(t * pi * 2) * h * 0.04);
      case IllustAnim.wave:
        return Offset(sin(t * pi * 2) * w * 0.03, cos(t * pi * 2) * h * 0.02);
      case IllustAnim.float:
        return Offset(sin(t * pi * 2) * w * 0.025, sin(t * pi * 2 + 1) * h * 0.04);
      case IllustAnim.shake:
        return Offset(sin(t * pi * 10) * w * 0.015, 0);
      default:
        return Offset.zero;
    }
  }

  // ── dispatch table ─────────────────────────────────────────────────────────

  late final Map<String, void Function(Canvas, Size)> _drawMap = {
    'love':      _drawLove,
    'like':      _drawLike,
    'laugh':     _drawLaugh,
    'talk':      _drawTalk,
    'shout':     _drawShout,
    'run':       _drawRun,
    'walk':      _drawWalk,
    'jump':      _drawJump,
    'wave':      _drawWave,
    'help':      _drawHelp,
    'hot':       _drawHot,
    'cold':      _drawCold,
    'happy':     _drawHappy,
    'sad':       _drawSad,
    'angry':     _drawAngry,
    'fast':      _drawFast,
    'slow':      _drawSlow,
    'beautiful': _drawBeautiful,
    'dry':       _drawDry,
    'wet':       _drawWet,
    'clean':     _drawClean,
    'dirty':     _drawDirty,
    'great':     _drawGreat,
    'feel':      _drawFeel,
    // ── 新增40个 ──
    'eat':       _drawEat,
    'drink':     _drawDrink,
    'cook':      _drawCook,
    'read':      _drawRead,
    'write':     _drawWrite,
    'sing':      _drawSing,
    'dance':     _drawDance,
    'swim':      _drawSwim,
    'fly':       _drawFly,
    'sleep':     _drawSleep,
    'open':      _drawOpen,
    'close':     _drawClose,
    'throw':     _drawThrow,
    'catch':     _drawCatch,
    'climb':     _drawClimb,
    'sit':       _drawSit,
    'stand':     _drawStand,
    'find':      _drawFind,
    'bring':     _drawBring,
    'show':      _drawShow,
    'big':       _drawBig,
    'small':     _drawSmall,
    'tall':      _drawTall,
    'short':     _drawShort,
    'new':       _drawNew,
    'old':       _drawOld,
    'dark':      _drawDark,
    'light':     _drawLight,
    'strong':    _drawStrong,
    'weak':      _drawWeak,
    'tired':     _drawTired,
    'hungry':    _drawHungry,
    'scared':    _drawScared,
    'friendly':  _drawFriendly,
    'sick':      _drawSick,
    'deep':      _drawDeep,
    'sweet':     _drawSweet,
    'noisy':     _drawNoisy,
    'quiet':     _drawQuiet,
    'pretty':    _drawPretty,
    // ── 新增40个 第三批 ──
    'go':        _drawGo,
    'come':      _drawCome,
    'get':       _drawGet,
    'make':      _drawMake,
    'take':      _drawTake,
    'give':      _drawGive,
    'think':     _drawThink,
    'say':       _drawSay,
    'see':       _drawSee,
    'hear':      _drawHear,
    'want':      _drawWant,
    'need':      _drawNeed,
    'leave':     _drawLeave,
    'arrive':    _drawArrive,
    'begin':     _drawBegin,
    'finish':    _drawFinish,
    'buy':       _drawBuy,
    'sell':      _drawSell,
    'play':      _drawPlay,
    'win':       _drawWin,
    'lose':      _drawLose,
    'learn':     _drawLearn,
    'teach':     _drawTeach,
    'try':       _drawTry,
    'wait':      _drawWait,
    'call':      _drawCall,
    'ask':       _drawAsk,
    'answer':    _drawAnswer,
    'grow':      _drawGrow,
    'change':    _drawChange,
    'afraid':    _drawAfraid,
    'brave':     _drawBrave,
    'careful':   _drawCareful,
    'dangerous': _drawDangerous,
    'different': _drawDifferent,
    'difficult': _drawDifficult,
    'easy':      _drawEasy,
    'excited':   _drawExcited,
    'famous':    _drawFamous,
    'free':      _drawFree,
    'glad':      _drawGlad,
    // batch 4
    'act':       _drawAct,
    'add':       _drawAdd,
    'agree':     _drawAgree,
    'alone':     _drawAlone,
    'amazing':   _drawAmazing,
    'appear':    _drawAppear,
    'awake':     _drawAwake,
    'bad':       _drawBad,
    'believe':   _drawBelieve,
    'best':      _drawBest,
    'better':    _drawBetter,
    'black':     _drawBlack,
    'blue':      _drawBlue,
    'bored':     _drawBored,
    'boring':    _drawBoring,
    'borrow':    _drawBorrow,
    'break':     _drawBreak,
    'brilliant': _drawBrilliant,
    'broken':    _drawBroken,
    'brown':     _drawBrown,
    'build':     _drawBuild,
    'burn':      _drawBurn,
    'busy':      _drawBusy,
    'carry':     _drawCarry,
    'chat':      _drawChat,
    'cheap':     _drawCheap,
    'choose':    _drawChoose,
    'clap':      _drawClap,
    'clever':    _drawClever,
    'closed':    _drawClosed,
    'cloudy':    _drawCloudy,
    'complete':  _drawComplete,
    'cool':      _drawCool,
    'correct':   _drawCorrect,
    'count':     _drawCount,
    'curly':     _drawCurly,
    'decide':    _drawDecide,
    'delicious': _drawDelicious,
    'design':    _drawDesign,
    'disappear': _drawDisappear,
    // ── batch 5 (do–hold) ──
    'do':        _drawDo,
    'double':    _drawDouble,
    'drop':      _drawDrop,
    'early':     _drawEarly,
    'empty':     _drawEmpty,
    'enormous':  _drawEnormous,
    'enter':     _drawEnter,
    'excellent': _drawExcellent,
    'exciting':  _drawExciting,
    'expensive': _drawExpensive,
    'explain':   _drawExplain,
    'explore':   _drawExplore,
    'fair':      _drawFair,
    'fantastic': _drawFantastic,
    'far':       _drawFar,
    'fat':       _drawFat,
    'feed':      _drawFeed,
    'fetch':     _drawFetch,
    'fine':      _drawFine,
    'first':     _drawFirst,
    'fix':       _drawFix,
    'foggy':     _drawFoggy,
    'follow':    _drawFollow,
    'forget':    _drawForget,
    'frightened': _drawFrightened,
    'full':      _drawFull,
    'fun':       _drawFun,
    'funny':     _drawFunny,
    'furry':     _drawFurry,
    'good':      _drawGood,
    'gray':      _drawGray,
    'guess':     _drawGuess,
    'half':      _drawHalf,
    'happen':    _drawHappen,
    'hard':      _drawHard,
    'hate':      _drawHate,
    'have':      _drawHave,
    'heavy':     _drawHeavy,
    'hide':      _drawHide,
    'high':      _drawHigh,
    'hold':      _drawHold,
    // ── batch 6 (all–improve) ──
    'all':           _drawAll,
    'all right':     _drawAllRight,
    'asleep':        _drawAsleep,
    'back':          _drawBack,
    'be':            _drawBe,
    'be called':     _drawBeCalled,
    'blond(e)':      _drawBlondE,
    'bottom':        _drawBottom,
    'camp':          _drawCamp,
    'can':           _drawCan,
    'catch (a bus)': _drawCatchABus,
    'cycle':         _drawCycle,
    'dear':          _drawDear,
    'dress up':      _drawDressUp,
    'english':       _drawEnglish,
    'extinct':       _drawExtinct,
    'favourite':     _drawFavourite,
    'find out':      _drawFindOut,
    'frightening':   _drawFrightening,
    'front':         _drawFront,
    'get dressed':   _drawGetDressed,
    'get off':       _drawGetOff,
    'get on':        _drawGetOn,
    'get undressed': _drawGetUndressed,
    'get up':        _drawGetUp,
    'glass':         _drawGlass,
    'go out':        _drawGoOut,
    'go to bed':     _drawGoToBed,
    'go to sleep':   _drawGoToSleep,
    'gold':          _drawGold,
    'have got':      _drawHaveGot,
    'her':           _drawHer,
    'his':           _drawHis,
    'hope':          _drawHope,
    'horrible':      _drawHorrible,
    'huge':          _drawHuge,
    'hurry':         _drawHurry,
    'ill':           _drawIll,
    'important':     _drawImportant,
    'improve':       _drawImprove,
    // ── batch 7 (interested–ok) ──
    'interested':    _drawInterested,
    'interesting':   _drawInteresting,
    'invent':        _drawInvent,
    'invite':        _drawInvite,
    'its':           _drawIts,
    'keep':          _drawKeep,
    'kind':          _drawKind,
    'large':         _drawLarge,
    'last':          _drawLast,
    'late':          _drawLate,
    'lazy':          _drawLazy,
    'left':          _drawLeft,
    'let':           _drawLet,
    'let\'s':        _drawLets,
    'let\u2019s':    _drawLets,
    'lie':           _drawLie,
    'lift':          _drawLift,
    'little':        _drawLittle,
    'long':          _drawLong,
    'look after':    _drawLookAfter,
    'look at':       _drawLookAt,
    'look for':      _drawLookFor,
    'look like':     _drawLookLike,
    'loud':          _drawLoud,
    'lovely':        _drawLovely,
    'low':           _drawLow,
    'lucky':         _drawLucky,
    'make sure':     _drawMakeSure,
    'married':       _drawMarried,
    'mean':          _drawMean,
    'metal':         _drawMetal,
    'middle':        _drawMiddle,
    'mind':          _drawMind,
    'missing':       _drawMissing,
    'mix':           _drawMix,
    'move':          _drawMove,
    'must':          _drawMust,
    'my':            _drawMy,
    'naughty':       _drawNaughty,
    'next':          _drawNext,
    'nice':          _drawNice,
    'ok':            _drawOk,
    'online':        _drawOnline,
    'orange':        _drawOrange,
    'our':           _drawOur,
    'paint':         _drawPaint,
    'paper':         _drawPaper,
    'pick up':       _drawPickUp,
    'pink':          _drawPink,
    'plastic':       _drawPlastic,
    'pleased':       _drawPleased,
    'point':         _drawPoint,
    'poor':          _drawPoor,
    'popular':       _drawPopular,
    'post':          _drawPost,
    'practise':      _drawPractise,
    'prefer':        _drawPrefer,
    'prepare':       _drawPrepare,
    'pull':          _drawPull,
    'purple':        _drawPurple,
    'push':          _drawPush,
    'put':           _drawPut,
    'put on':        _drawPutOn,
    'quick':         _drawQuick,
    'racing':        _drawRacing,
    'ready':         _drawReady,
    'red':           _drawRed,
    'remember':      _drawRemember,
    'repair':        _drawRepair,
    'repeat':        _drawRepeat,
    'rich':          _drawRich,
    'right':         _drawRight,
    'round':         _drawRound,
    'safe':          _drawSafe,
    'same':          _drawSame,
    'save':          _drawSave,
    'scary':         _drawScary,
    'second':        _drawSecond,
    'send':          _drawSend,
    'several':       _drawSeveral,
    'shop':          _drawShop,
    'silver':        _drawSilver,
    'soft':          _drawSoft,
    'sore':          _drawSore,
    'sorry':         _drawSorry,
    'sound':         _drawSound,
    'speak':         _drawSpeak,
    'special':       _drawSpecial,
    'spend':         _drawSpend,
    'spotted':       _drawSpotted,
    'square':        _drawSquare,
    'start':         _drawStart,
    'stay':          _drawStay,
    'stop':          _drawStop,
    'straight':      _drawStraight,
    'strange':       _drawStrange,
    'striped':       _drawStriped,
    'sunny':         _drawSunny,
    'sure':          _drawSure,
    'surprised':     _drawSurprised,
    'take off':      _drawTakeOff,
    'terrible':      _drawTerrible,
    'thank':         _drawThank,
    'their':         _drawTheir,
    'thin':          _drawThin,
    'third':         _drawThird,
    'thirsty':       _drawThirsty,
    'tidy':          _drawTidy,
    'touch':         _drawTouch,
    'travel':        _drawTravel,
    'turn':          _drawTurn,
    'turn off':      _drawTurnOff,
    'turn on':       _drawTurnOn,
    'ugly':          _drawUgly,
    'unfriendly':    _drawUnfriendly,
    'unhappy':       _drawUnhappy,
    'unkind':        _drawUnkind,
    // ── batch 11 (untidy–your) ──
    'untidy':            _drawUntidy,
    'unusual':           _drawUnusual,
    'use':               _drawUse,
    'visit':             _drawVisit,
    'wake':              _drawWake,
    'warm':              _drawWarm,
    'water':             _drawWater,
    'well':              _drawWell,
    'whisper':           _drawWhisper,
    'whistle':           _drawWhistle,
    'white':             _drawWhite,
    'wild':              _drawWild,
    'win a competition': _drawWinACompetition,
    'windy':             _drawWindy,
    'wish':              _drawWish,
    'wonderful':         _drawWonderful,
    'worried':           _drawWorried,
    'worse':             _drawWorse,
    'worst':             _drawWorst,
    'would like':        _drawWouldLike,
    'wrong':             _drawWrong,
    'yellow':            _drawYellow,
    'young':             _drawYoung,
    'your':              _drawYour,
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // 基础形状
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawHeartShape(Canvas canvas, double cx, double cy, double hw, double hh, Paint paint) {
    final path = Path()
      ..moveTo(cx, cy + hh * 0.65)
      ..cubicTo(cx - hw * 0.05, cy + hh * 0.45, cx - hw * 0.55, cy + hh * 0.2,
          cx - hw * 0.55, cy - hh * 0.1)
      ..cubicTo(cx - hw * 0.55, cy - hh * 0.55, cx - hw * 0.15, cy - hh * 0.72,
          cx, cy - hh * 0.35)
      ..cubicTo(cx + hw * 0.15, cy - hh * 0.72, cx + hw * 0.55, cy - hh * 0.55,
          cx + hw * 0.55, cy - hh * 0.1)
      ..cubicTo(cx + hw * 0.55, cy + hh * 0.2, cx + hw * 0.05, cy + hh * 0.45,
          cx, cy + hh * 0.65)
      ..close();
    if (isDark) {
      canvas.drawPath(path, _outlineP);
    }
    canvas.drawPath(path, paint);
  }

  void _drawStarShape(Canvas canvas, double cx, double cy, double outerR, double innerR, int points, Paint paint) {
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = i * pi / points - pi / 2;
      final x = cx + cos(angle) * r;
      final y = cy + sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    if (isDark && outerR > 5) {
      canvas.drawPath(path, _outlineP);
    }
    canvas.drawPath(path, paint);
  }

  void _drawStickFigure(Canvas canvas, double cx, double cy, double scale,
      Color color, {
        double headR = 0.18,
        double bodyEndY = 0.9,
        double leftArmAngle = -0.6,
        double rightArmAngle = 0.6,
        double armLen = 0.35,
        double leftLegAngle = -0.4,
        double rightLegAngle = 0.4,
        double legLen = 0.45,
        double bodyTopY = -0.1,
        double headCY = -0.4,
      }) {
    final effectiveColor = _dc(color);
    final paint = Paint()
      ..color = effectiveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = (isDark ? 5.0 : 3.5) * scale
      ..strokeCap = StrokeCap.round;

    final headR2 = headR * scale;
    final bodyTop = Offset(cx, cy + bodyTopY * scale);
    final bodyBot = Offset(cx, cy + bodyEndY * scale);

    // head
    canvas.drawCircle(Offset(cx, cy + headCY * scale), headR2, paint);
    // body
    canvas.drawLine(bodyTop, bodyBot, paint);
    // arms from upper body
    final armY = cy + (bodyTopY + (bodyEndY - bodyTopY) * 0.15) * scale;
    canvas.drawLine(
      Offset(cx, armY),
      Offset(cx + cos(leftArmAngle) * armLen * scale, armY + sin(leftArmAngle) * armLen * scale),
      paint,
    );
    canvas.drawLine(
      Offset(cx, armY),
      Offset(cx + cos(rightArmAngle) * armLen * scale, armY + sin(rightArmAngle) * armLen * scale),
      paint,
    );
    // legs
    canvas.drawLine(
      bodyBot,
      Offset(cx + sin(leftLegAngle) * legLen * scale, bodyBot.dy + cos(leftLegAngle) * legLen * scale),
      paint,
    );
    canvas.drawLine(
      bodyBot,
      Offset(cx + sin(rightLegAngle) * legLen * scale, bodyBot.dy + cos(rightLegAngle) * legLen * scale),
      paint,
    );
  }

  void _drawFace(Canvas canvas, double cx, double cy, double r, Color color,
      {double smileFactor = 1.0, bool hasTears = false, bool hasAngryBrows = false}) {
    final effectiveColor = _dc(color);
    final paint = Paint()..color = effectiveColor;

    // face circle with outline in dark mode
    if (isDark) {
      canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 2.0);
    }
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // eyes
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.12), r * 0.12, eyePaint);
    canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.12), r * 0.12, eyePaint);
    // pupils (use dark color that's visible on light face)
    final pupilPaint = Paint()..color = isDark ? Colors.grey[800]! : Colors.black87;
    canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.1), r * 0.06, pupilPaint);
    canvas.drawCircle(Offset(cx + r * 0.3, cy - r * 0.1), r * 0.06, pupilPaint);

    // mouth
    final mouthPaint = Paint()
      ..color = smileFactor >= 0 ? Colors.white : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.06
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    if (smileFactor >= 0) {
      // smile
      mouthPath.addArc(
        Rect.fromCenter(center: Offset(cx, cy + r * 0.2), width: r * 0.6, height: r * 0.4 * smileFactor),
        0.1, pi - 0.2,
      );
    } else {
      // frown
      mouthPath.addArc(
        Rect.fromCenter(center: Offset(cx, cy + r * 0.45), width: r * 0.5, height: r * 0.3 * (-smileFactor)),
        pi + 0.2, pi - 0.4,
      );
    }
    canvas.drawPath(mouthPath, mouthPaint);

    // tears
    if (hasTears) {
      final tearPaint = Paint()..color = Colors.lightBlueAccent.withOpacity(0.7);
      final tearPhase = (sin(t * pi * 2) + 1) / 2;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(cx - r * 0.38, cy + r * 0.05 + tearPhase * r * 0.3),
          width: r * 0.08, height: r * 0.12,
        ),
        tearPaint,
      );
    }

    // angry brows
    if (hasAngryBrows) {
      final browPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.08
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(cx - r * 0.5, cy - r * 0.35),
        Offset(cx - r * 0.15, cy - r * 0.22),
        browPaint,
      );
      canvas.drawLine(
        Offset(cx + r * 0.15, cy - r * 0.22),
        Offset(cx + r * 0.5, cy - r * 0.35),
        browPaint,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 单词手绘插画（按字母序）
  // ═══════════════════════════════════════════════════════════════════════════

  // ── angry: 愤怒脸 + 蒸汽 ──────────────────────────────────────────────────
  void _drawAngry(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final r = w * 0.22;

    _drawFace(canvas, cx, cy, r, illustration.bg, smileFactor: -0.8, hasAngryBrows: true);

    // steam lines
    final steamPaint = Paint()
      ..color = _dc(illustration.accent)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final steamPhase = sin(t * pi * 2) * 0.5 + 0.5;
    for (int i = -1; i <= 1; i += 2) {
      final sx = cx + i * r * 0.8;
      final sy = cy - r * 1.1;
      final steamPath = Path()
        ..moveTo(sx, sy)
        ..cubicTo(sx + i * 8, sy - 15 * steamPhase, sx - i * 5, sy - 25 * steamPhase, sx + i * 3, sy - 35 * steamPhase);
      canvas.drawPath(steamPath, steamPaint);
    }
  }

  // ── beautiful: 蝴蝶 ───────────────────────────────────────────────────────
  void _drawBeautiful(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final wingW = w * 0.22, wingH = h * 0.2;

    final wingPhase = sin(t * pi * 2) * 0.15;

    // wings
    final wingPaint = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.8));
    final wingPaint2 = Paint()..color = _dc(illustration.accent);

    for (int side = -1; side <= 1; side += 2) {
      // upper wing
      canvas.save();
      canvas.translate(cx, cy - h * 0.05);
      canvas.scale(side.toDouble(), 1.0);
      final upperPath = Path()
        ..moveTo(0, 0)
        ..cubicTo(wingW * (1 + wingPhase), -wingH * 1.2, wingW * 1.3, -wingH * 0.3, wingW * 0.8, wingH * 0.2)
        ..cubicTo(wingW * 0.4, wingH * 0.3, 0, wingH * 0.1, 0, 0)
        ..close();
      canvas.drawPath(upperPath, wingPaint);

      // lower wing (smaller)
      final lowerPath = Path()
        ..moveTo(0, 0)
        ..cubicTo(wingW * (0.8 + wingPhase), wingH * 0.3, wingW * 0.9, wingH * 0.9, wingW * 0.4, wingH * 0.8)
        ..cubicTo(wingW * 0.2, wingH * 0.6, 0, wingH * 0.2, 0, 0)
        ..close();
      canvas.drawPath(lowerPath, wingPaint2);
      canvas.restore();
    }

    // body
    final bodyPaint = Paint()
      ..color = Colors.brown[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy - h * 0.15), Offset(cx, cy + h * 0.2), bodyPaint);

    // antennae
    final antPaint = Paint()
      ..color = Colors.brown[700]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy - h * 0.12), Offset(cx - w * 0.1, cy - h * 0.28), antPaint);
    canvas.drawLine(Offset(cx, cy - h * 0.12), Offset(cx + w * 0.1, cy - h * 0.28), antPaint);
    canvas.drawCircle(Offset(cx - w * 0.1, cy - h * 0.28), 3, Paint()..color = Colors.brown[700]!);
    canvas.drawCircle(Offset(cx + w * 0.1, cy - h * 0.28), 3, Paint()..color = Colors.brown[700]!);
  }

  // ── clean: 闪光 ✦ ─────────────────────────────────────────────────────────
  void _drawClean(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    final sparkles = [
      [0.5, 0.35, 0.15],
      [0.25, 0.3, 0.1],
      [0.75, 0.25, 0.08],
      [0.35, 0.65, 0.1],
      [0.65, 0.6, 0.12],
      [0.2, 0.55, 0.06],
      [0.8, 0.5, 0.07],
    ];

    for (int i = 0; i < sparkles.length; i++) {
      final sx = sparkles[i][0] * w;
      final sy = sparkles[i][1] * h;
      final sr = sparkles[i][2] * w;
      final phase = (t + i * 0.14) % 1.0;
      final alpha = ((sin(phase * pi * 2) + 1) / 2 * 0.6 + 0.4).clamp(0.0, 1.0);
      final scale = 0.6 + alpha * 0.4;

      final p = Paint()..color = (i % 2 == 0 ? illustration.bg : illustration.accent).withOpacity(alpha);

      // 4-pointed star sparkle
      _drawStarShape(canvas, sx, sy, sr * scale, sr * 0.3 * scale, 4, p);
    }

    // central glow
    final glowPaint = Paint()
      ..shader = RadialGradient(colors: [
        illustration.accent.withOpacity(_minOp(0.3)),
        illustration.accent.withOpacity(_minOp(0)),
      ]).createShader(Rect.fromCircle(center: Offset(w / 2, h * 0.45), radius: w * 0.3));
    canvas.drawCircle(Offset(w / 2, h * 0.45), w * 0.3, glowPaint);
  }

  // ── cold: 雪花 ────────────────────────────────────────────────────────────
  void _drawCold(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final r = w * 0.28;

    final flakePaint = Paint()
      ..color = _dc(illustration.bg)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // 6 main arms
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3 - pi / 2;
      final ex = cx + cos(angle) * r;
      final ey = cy + sin(angle) * r;
      canvas.drawLine(Offset(cx, cy), Offset(ex, ey), flakePaint);

      // branch decorations
      final midX = cx + cos(angle) * r * 0.6;
      final midY = cy + sin(angle) * r * 0.6;
      for (int j = -1; j <= 1; j += 2) {
        final branchAngle = angle + j * pi / 4;
        final bLen = r * 0.25;
        canvas.drawLine(
          Offset(midX, midY),
          Offset(midX + cos(branchAngle) * bLen, midY + sin(branchAngle) * bLen),
          flakePaint,
        );
      }

      // tip branches
      for (int j = -1; j <= 1; j += 2) {
        final branchAngle = angle + j * pi / 5;
        final bLen = r * 0.15;
        canvas.drawLine(
          Offset(ex, ey),
          Offset(ex + cos(branchAngle) * bLen, ey + sin(branchAngle) * bLen),
          flakePaint,
        );
      }
    }

    // center dot
    canvas.drawCircle(Offset(cx, cy), 4, Paint()..color = _dc(illustration.accent));
  }

  // ── dirty: 泥点溅射 ──────────────────────────────────────────────────────
  void _drawDirty(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final rng = Random(word?.hashCode ?? 0);

    // main splat
    final mainPaint = Paint()..color = _dc(illustration.bg);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: w * 0.3, height: h * 0.2),
      mainPaint,
    );

    // drip
    final dripPath = Path()
      ..moveTo(cx - w * 0.05, cy + h * 0.05)
      ..quadraticBezierTo(cx - w * 0.08, cy + h * 0.18, cx, cy + h * 0.22)
      ..quadraticBezierTo(cx + w * 0.06, cy + h * 0.16, cx + w * 0.02, cy + h * 0.05)
      ..close();
    canvas.drawPath(dripPath, mainPaint);

    // small splatter dots
    final dotPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7));
    for (int i = 0; i < 8; i++) {
      final angle = rng.nextDouble() * pi * 2;
      final dist = w * (0.15 + rng.nextDouble() * 0.15);
      final dotR = w * (0.015 + rng.nextDouble() * 0.025);
      canvas.drawCircle(
        Offset(cx + cos(angle) * dist, cy + sin(angle) * dist),
        dotR,
        dotPaint,
      );
    }

    // smudge marks
    final smudgePaint = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4));
    for (int i = 0; i < 3; i++) {
      final sx = cx + (rng.nextDouble() - 0.5) * w * 0.4;
      final sy = cy + (rng.nextDouble() - 0.5) * h * 0.3;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(sx, sy), width: w * 0.08, height: w * 0.05),
        smudgePaint,
      );
    }
  }

  // ── dry: 太阳 + 热浪 ─────────────────────────────────────────────────────
  void _drawDry(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.4;
    final r = w * 0.15;

    // sun body
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = _dc(illustration.bg));

    // face on sun
    final eyePaint = Paint()..color = Colors.orange[800]!;
    canvas.drawCircle(Offset(cx - r * 0.25, cy - r * 0.1), r * 0.08, eyePaint);
    canvas.drawCircle(Offset(cx + r * 0.25, cy - r * 0.1), r * 0.08, eyePaint);
    // smile
    final smilePaint = Paint()
      ..color = Colors.orange[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..addArc(Rect.fromCenter(center: Offset(cx, cy + r * 0.1), width: r * 0.4, height: r * 0.25), 0.2, pi - 0.4);
    canvas.drawPath(smilePath, smilePaint);

    // rays
    final rayPaint = Paint()
      ..color = _dc(illustration.accent)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final rayPhase = sin(t * pi * 2) * 0.1 + 1.0;
    for (int i = 0; i < 12; i++) {
      final angle = i * pi / 6;
      final innerR = r * 1.2;
      final outerR = r * (1.6 + (i % 2) * 0.3) * rayPhase;
      canvas.drawLine(
        Offset(cx + cos(angle) * innerR, cy + sin(angle) * innerR),
        Offset(cx + cos(angle) * outerR, cy + sin(angle) * outerR),
        rayPaint,
      );
    }

    // heat waves below
    final wavePaint = Paint()
      ..color = illustration.bg.withOpacity(_minOp(0.4))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final wy = h * 0.72 + i * h * 0.07;
      final wavePath = Path()..moveTo(w * 0.2, wy);
      for (double x = w * 0.2; x <= w * 0.8; x += 1) {
        wavePath.lineTo(x, wy + sin((x / w * 6 + t * pi * 2 + i) * 1.5) * 5);
      }
      canvas.drawPath(wavePath, wavePaint);
    }
  }

  // ── fast: 闪电 + 速度线 ───────────────────────────────────────────────────
  void _drawFast(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.42;

    // lightning bolt
    final boltPath = Path()
      ..moveTo(cx + w * 0.05, cy - h * 0.3)
      ..lineTo(cx - w * 0.12, cy + h * 0.02)
      ..lineTo(cx + w * 0.02, cy + h * 0.02)
      ..lineTo(cx - w * 0.08, cy + h * 0.3)
      ..lineTo(cx + w * 0.15, cy - h * 0.08)
      ..lineTo(cx, cy - h * 0.08)
      ..close();
    canvas.drawPath(boltPath, Paint()..color = _dc(illustration.bg));

    // glow
    final glowPaint = Paint()
      ..shader = RadialGradient(colors: [
        illustration.accent.withOpacity(_minOp(0.25)),
        illustration.accent.withOpacity(_minOp(0)),
      ]).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: w * 0.3));
    canvas.drawCircle(Offset(cx, cy), w * 0.3, glowPaint);

    // speed lines
    final speedPaint = Paint()
      ..color = illustration.accent.withOpacity(_minOp(0.6))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final linePhase = (t * 3) % 1.0;
    for (int i = 0; i < 5; i++) {
      final ly = h * 0.15 + i * h * 0.14;
      final lx = w * (0.1 + ((linePhase + i * 0.13) % 1.0) * 0.3);
      final len = w * (0.08 + (i % 2) * 0.05);
      canvas.drawLine(Offset(lx, ly), Offset(lx + len, ly), speedPaint);
    }
  }

  // ── feel: 心形 + 手 ───────────────────────────────────────────────────────
  void _drawFeel(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.42;

    // hand (simplified palm shape)
    final handPaint = Paint()..color = const Color(0xFFBCAAA4);
    final handPath = Path()
      ..moveTo(cx + w * 0.05, cy + h * 0.2)
      ..lineTo(cx - w * 0.08, cy + h * 0.2)
      ..quadraticBezierTo(cx - w * 0.15, cy + h * 0.05, cx - w * 0.12, cy - h * 0.05)
      ..lineTo(cx - w * 0.06, cy - h * 0.05)
      ..lineTo(cx - w * 0.06, cy - h * 0.2)
      ..lineTo(cx, cy - h * 0.2)
      ..lineTo(cx, cy - h * 0.15)
      ..lineTo(cx + w * 0.04, cy - h * 0.15)
      ..lineTo(cx + w * 0.04, cy - h * 0.05)
      ..lineTo(cx + w * 0.1, cy - h * 0.05)
      ..quadraticBezierTo(cx + w * 0.14, cy + h * 0.05, cx + w * 0.05, cy + h * 0.2)
      ..close();
    canvas.drawPath(handPath, handPaint);

    // heart above hand
    final pulseS = 0.9 + sin(t * pi * 2) * 0.1;
    _drawHeartShape(canvas, cx + w * 0.01, cy - h * 0.22, w * 0.1 * pulseS, h * 0.1 * pulseS,
        Paint()..color = _dc(illustration.bg));
  }

  // ── great: 奖杯 + 星星 ───────────────────────────────────────────────────
  void _drawGreat(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.4;

    // trophy cup
    final cupPaint = Paint()..color = _dc(illustration.bg);
    final cupPath = Path()
      ..moveTo(cx - w * 0.15, cy - h * 0.2)
      ..quadraticBezierTo(cx - w * 0.18, cy + h * 0.05, cx - w * 0.05, cy + h * 0.1)
      ..lineTo(cx - w * 0.03, cy + h * 0.15)
      ..lineTo(cx + w * 0.03, cy + h * 0.15)
      ..lineTo(cx + w * 0.05, cy + h * 0.1)
      ..quadraticBezierTo(cx + w * 0.18, cy + h * 0.05, cx + w * 0.15, cy - h * 0.2)
      ..close();
    canvas.drawPath(cupPath, cupPaint);

    // handles
    final handlePaint = Paint()
      ..color = _dc(illustration.bg)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    for (int i = -1; i <= 1; i += 2) {
      final handlePath = Path()
        ..moveTo(cx + i * w * 0.15, cy - h * 0.12)
        ..quadraticBezierTo(cx + i * w * 0.25, cy, cx + i * w * 0.15, cy + h * 0.05);
      canvas.drawPath(handlePath, handlePaint);
    }

    // base
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.22), width: w * 0.2, height: h * 0.04),
      cupPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.28), width: w * 0.3, height: h * 0.03),
      cupPaint,
    );

    // star decoration
    final pulseS = 0.8 + sin(t * pi * 2) * 0.2;
    _drawStarShape(canvas, cx, cy - h * 0.05, w * 0.06 * pulseS, w * 0.025 * pulseS, 5,
        Paint()..color = _dc(illustration.accent));
  }

  // ── happy: 笑脸 ───────────────────────────────────────────────────────────
  void _drawHappy(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    _drawFace(canvas, w / 2, h * 0.45, w * 0.22, illustration.bg, smileFactor: 1.2);

    // blush
    final blushPaint = Paint()..color = Colors.pink[200]!.withOpacity(0.5);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2 - w * 0.17, h * 0.5), width: w * 0.1, height: h * 0.06),
      blushPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w / 2 + w * 0.17, h * 0.5), width: w * 0.1, height: h * 0.06),
      blushPaint,
    );
  }

  // ── help: 双手相握 ────────────────────────────────────────────────────────
  void _drawHelp(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;

    const handColor = Color(0xFFBCAAA4);
    final handshakePhase = sin(t * pi * 2) * 3;

    // left hand/arm
    final leftPaint = Paint()..color = handColor;
    final leftPath = Path()
      ..moveTo(cx - w * 0.3, cy + h * 0.05 + handshakePhase)
      ..quadraticBezierTo(cx - w * 0.2, cy - h * 0.1, cx - w * 0.05, cy - h * 0.05)
      ..lineTo(cx - w * 0.02, cy + h * 0.05)
      ..lineTo(cx - w * 0.08, cy + h * 0.12)
      ..close();
    canvas.drawPath(leftPath, leftPaint);

    // right hand/arm
    final rightPaint = Paint()..color = handColor.withOpacity(0.85);
    final rightPath = Path()
      ..moveTo(cx + w * 0.3, cy + h * 0.05 - handshakePhase)
      ..quadraticBezierTo(cx + w * 0.2, cy - h * 0.1, cx + w * 0.05, cy - h * 0.05)
      ..lineTo(cx + w * 0.02, cy + h * 0.05)
      ..lineTo(cx + w * 0.08, cy + h * 0.12)
      ..close();
    canvas.drawPath(rightPath, rightPaint);

    // handshake circle (connection)
    canvas.drawCircle(Offset(cx, cy - h * 0.02), w * 0.04, Paint()..color = _dc(illustration.bg));

    // heart above
    final pulseS = 0.8 + sin(t * pi * 2) * 0.15;
    _drawHeartShape(canvas, cx, cy - h * 0.25, w * 0.06 * pulseS, h * 0.06 * pulseS,
        Paint()..color = _dc(illustration.accent));

    // sparkle dots
    final sparkPaint = Paint()..color = _dc(illustration.accent);
    final sp = sin(t * pi * 2) * 0.5 + 0.5;
    canvas.drawCircle(Offset(cx - w * 0.15, cy - h * 0.2), 3 * sp, sparkPaint);
    canvas.drawCircle(Offset(cx + w * 0.15, cy - h * 0.22), 2.5 * sp, sparkPaint);
    canvas.drawCircle(Offset(cx, cy - h * 0.35), 2 * sp, sparkPaint);
  }

  // ── hot: 太阳 + 热浪 ─────────────────────────────────────────────────────
  void _drawHot(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.42;
    final r = w * 0.14;

    // sun body
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = _dc(illustration.bg));

    // rays (animated)
    final rayPaint = Paint()
      ..color = illustration.bg.withOpacity(_minOp(0.8))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    final rayPhase = sin(t * pi * 2) * 0.15 + 1.0;
    for (int i = 0; i < 12; i++) {
      final angle = i * pi / 6;
      final innerR = r * 1.15;
      final outerR = r * (1.6 + (i % 2) * 0.35) * rayPhase;
      canvas.drawLine(
        Offset(cx + cos(angle) * innerR, cy + sin(angle) * innerR),
        Offset(cx + cos(angle) * outerR, cy + sin(angle) * outerR),
        rayPaint,
      );
    }

    // heat shimmer lines
    final shimmerPaint = Paint()
      ..color = Colors.red[300]!.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final sy = h * 0.7 + i * h * 0.06;
      final path = Path()..moveTo(w * 0.25, sy);
      for (double x = w * 0.25; x <= w * 0.75; x += 2) {
        path.lineTo(x, sy + sin((x / w * 8 + t * pi * 3 + i) * 1.2) * 4);
      }
      canvas.drawPath(path, shimmerPaint);
    }

    // face on sun
    final facePaint = Paint()..color = Colors.orange[900]!;
    canvas.drawCircle(Offset(cx - r * 0.22, cy - r * 0.1), r * 0.07, facePaint);
    canvas.drawCircle(Offset(cx + r * 0.22, cy - r * 0.1), r * 0.07, facePaint);
  }

  // ── jump: 跳跃小人 ───────────────────────────────────────────────────────
  void _drawJump(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    _drawStickFigure(canvas, w / 2, h * 0.3, w * 0.35, illustration.bg,
      leftArmAngle: -2.2, rightArmAngle: -1.0,
      leftLegAngle: -0.5, rightLegAngle: 0.5,
      bodyEndY: 0.8,
    );

    // ground shadow
    final shadowPhase = sin(t * pi * 2);
    final shadowScale = (1.0 - shadowPhase.abs() * 0.6).clamp(0.2, 1.0);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w / 2, h * 0.88),
        width: w * 0.35 * shadowScale,
        height: h * 0.025 * shadowScale,
      ),
      Paint()..color = Colors.black.withOpacity(0.08),
    );

    // motion lines below feet
    final motionPaint = Paint()
      ..color = illustration.accent.withOpacity(_minOp(0.5))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = -1; i <= 1; i++) {
      canvas.drawLine(
        Offset(w / 2 + i * w * 0.06, h * 0.82),
        Offset(w / 2 + i * w * 0.06, h * 0.9),
        motionPaint,
      );
    }
  }

  // ── laugh: 笑脸 + 哈哈 ───────────────────────────────────────────────────
  void _drawLaugh(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    _drawFace(canvas, w / 2, h * 0.45, w * 0.22, illustration.bg, smileFactor: 1.5);

    // "HA HA" text effect - sparkle bursts
    final burstPhase = sin(t * pi * 4).abs();
    final burstPaint = Paint()..color = _dc(illustration.accent);
    for (int i = 0; i < 3; i++) {
      final angle = -pi / 3 + i * pi / 3;
      final dist = w * 0.3 + burstPhase * w * 0.05;
      final bx = w / 2 + cos(angle) * dist;
      final by = h * 0.45 + sin(angle) * dist;
      _drawStarShape(canvas, bx, by, w * 0.025, w * 0.01, 4, burstPaint);
    }
  }

  // ── like: 竖大拇指 ───────────────────────────────────────────────────────
  void _drawLike(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.42;

    final thumbPaint = Paint()..color = _dc(illustration.bg);

    // thumb (upward rectangle)
    final thumbPath = Path()
      ..moveTo(cx - w * 0.04, cy + h * 0.05)
      ..lineTo(cx - w * 0.06, cy - h * 0.2)
      ..quadraticBezierTo(cx - w * 0.06, cy - h * 0.3, cx, cy - h * 0.3)
      ..quadraticBezierTo(cx + w * 0.04, cy - h * 0.3, cx + w * 0.04, cy - h * 0.2)
      ..lineTo(cx + w * 0.02, cy + h * 0.05)
      ..close();
    canvas.drawPath(thumbPath, thumbPaint);

    // palm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - w * 0.15, cy + h * 0.05, w * 0.2, h * 0.18),
        const Radius.circular(6),
      ),
      thumbPaint,
    );

    // fingers
    for (int i = 0; i < 4; i++) {
      final fx = cx - w * 0.13 + i * w * 0.055;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(fx, cy + h * 0.23, w * 0.04, h * 0.12),
          const Radius.circular(4),
        ),
        thumbPaint,
      );
    }

    // sparkle on thumb
    final sparkleS = sin(t * pi * 2) * 0.5 + 0.5;
    _drawStarShape(canvas, cx + w * 0.06, cy - h * 0.22, w * 0.03 * sparkleS, w * 0.012 * sparkleS, 4,
        Paint()..color = _dc(illustration.accent));
  }

  // ── love: 心形脉搏 ───────────────────────────────────────────────────────
  void _drawLove(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.42;

    // heartbeat scale
    final phase = t * pi * 2;
    double s = 1.0;
    final beat = sin(phase * 2);
    if (beat > 0.7) {
      s = 1.0 + (beat - 0.7) * 0.15;
    } else if (beat > 0.3) {
      s = 1.0 + (beat - 0.3) * 0.05;
    }

    // outer glow
    final glowPaint = Paint()
      ..shader = RadialGradient(colors: [
        illustration.bg.withOpacity(_minOp(0.2 * s)),
        illustration.bg.withOpacity(_minOp(0)),
      ]).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: w * 0.35));
    canvas.drawCircle(Offset(cx, cy), w * 0.35, glowPaint);

    // heart
    _drawHeartShape(canvas, cx, cy, w * 0.22 * s, h * 0.22 * s, Paint()..color = _dc(illustration.bg));

    // small heart particles
    final rng = Random(42);
    for (int i = 0; i < 5; i++) {
      final px = cx + (rng.nextDouble() - 0.5) * w * 0.7;
      final py = cy + (rng.nextDouble() - 0.5) * h * 0.5;
      final floatY = py - sin(phase + i * 1.3) * h * 0.04;
      final ps = 0.6 + sin(phase + i * 0.7) * 0.3;
      _drawHeartShape(canvas, px, floatY, w * 0.03 * ps, h * 0.03 * ps,
          Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4 * ps)));
    }
  }

  // ── run: 奔跑小人 ─────────────────────────────────────────────────────────
  void _drawRun(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final phase = sin(t * pi * 2);
    _drawStickFigure(canvas, w / 2, h * 0.38, w * 0.35, illustration.bg,
      leftArmAngle: -2.0 + phase * 0.3,
      rightArmAngle: -0.8 - phase * 0.3,
      leftLegAngle: -0.7 + phase * 0.3,
      rightLegAngle: 0.7 - phase * 0.3,
      armLen: 0.4,
      legLen: 0.5,
    );

    // speed lines
    final speedPaint = Paint()
      ..color = illustration.accent.withOpacity(_minOp(0.5))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final linePhase = (t * 2) % 1.0;
    for (int i = 0; i < 4; i++) {
      final ly = h * 0.2 + i * h * 0.15;
      final lx = w * (0.05 + ((linePhase + i * 0.15) % 1.0) * 0.25);
      final len = w * 0.08;
      canvas.drawLine(Offset(lx, ly), Offset(lx + len, ly), speedPaint);
    }
  }

  // ── sad: 悲伤脸 + 泪滴 ───────────────────────────────────────────────────
  void _drawSad(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    _drawFace(canvas, w / 2, h * 0.45, w * 0.22, illustration.bg, smileFactor: -0.8, hasTears: true);

    // rain drops
    final dropPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4));
    final dropPhase = (t * 2) % 1.0;
    for (int i = 0; i < 6; i++) {
      final dx = w * (0.15 + (i * 0.12));
      final dy = h * ((dropPhase + i * 0.17) % 1.0);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(dx, dy), width: 3, height: 6),
        dropPaint,
      );
    }
  }

  // ── shout: 扩音器 + 声波 ──────────────────────────────────────────────────
  void _drawShout(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.42;

    // megaphone body
    final hornPaint = Paint()..color = _dc(illustration.bg);
    final hornPath = Path()
      ..moveTo(cx - w * 0.05, cy - h * 0.08)
      ..lineTo(cx + w * 0.15, cy - h * 0.18)
      ..lineTo(cx + w * 0.15, cy + h * 0.18)
      ..lineTo(cx - w * 0.05, cy + h * 0.08)
      ..close();
    canvas.drawPath(hornPath, hornPaint);

    // handle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(cx - w * 0.15, cy - h * 0.05, w * 0.12, h * 0.1),
        const Radius.circular(6),
      ),
      hornPaint,
    );

    // sound waves
    final wavePhase = sin(t * pi * 2) * 0.5 + 0.5;
    for (int i = 1; i <= 3; i++) {
      final waveR = w * (0.08 + i * 0.07) * (0.8 + wavePhase * 0.2);
      final alpha = (1.0 - i * 0.25).clamp(0.0, 1.0);
      final arcPaint = Paint()
        ..color = illustration.accent.withOpacity(_minOp(alpha))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      final wavePath = Path()
        ..addArc(Rect.fromCircle(center: Offset(cx + w * 0.15, cy), radius: waveR), -0.5, 1.0);
      canvas.drawPath(wavePath, arcPaint);
    }
  }

  // ── slow: 蜗牛 ────────────────────────────────────────────────────────────
  void _drawSlow(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.5;

    // body (slug)
    final bodyPaint = Paint()..color = const Color(0xFFBCAAA4);
    final bodyPath = Path()
      ..moveTo(cx - w * 0.2, cy + h * 0.05)
      ..quadraticBezierTo(cx - w * 0.15, cy - h * 0.02, cx, cy)
      ..quadraticBezierTo(cx + w * 0.15, cy + h * 0.02, cx + w * 0.22, cy + h * 0.06)
      ..lineTo(cx + w * 0.2, cy + h * 0.1)
      ..quadraticBezierTo(cx, cy + h * 0.08, cx - w * 0.2, cy + h * 0.1)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // shell (spiral)
    final shellCx = cx + w * 0.02;
    final shellCy = cy - h * 0.05;

    // shell outline
    canvas.drawOval(
      Rect.fromCenter(center: Offset(shellCx, shellCy), width: w * 0.18, height: h * 0.16),
      Paint()..color = _dc(illustration.bg),
    );

    // spiral inside
    final spiralPaint = Paint()
      ..color = _dc(illustration.accent)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final spiralPath = Path();
    for (double a = 0; a < pi * 4; a += 0.1) {
      final sr = a / (pi * 4) * w * 0.07;
      final sx = shellCx + cos(a) * sr;
      final sy = shellCy + sin(a) * sr;
      if (a == 0) {
        spiralPath.moveTo(sx, sy);
      } else {
        spiralPath.lineTo(sx, sy);
      }
    }
    canvas.drawPath(spiralPath, spiralPaint);

    // eye stalks
    final stalkPaint = Paint()
      ..color = const Color(0xFFBCAAA4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    for (int i = -1; i <= 1; i += 2) {
      final ex = cx - w * 0.15 + i * w * 0.04;
      canvas.drawLine(Offset(ex, cy - h * 0.02), Offset(ex + i * w * 0.02, cy - h * 0.15), stalkPaint);
      canvas.drawCircle(Offset(ex + i * w * 0.02, cy - h * 0.15), 3, Paint()..color = _dc(illustration.bg));
    }

    // slime trail
    final trailPaint = Paint()
      ..color = illustration.accent.withOpacity(_minOp(0.3))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final trailPath = Path()
      ..moveTo(cx + w * 0.22, cy + h * 0.08)
      ..quadraticBezierTo(cx + w * 0.3, cy + h * 0.1, cx + w * 0.35, cy + h * 0.06);
    canvas.drawPath(trailPath, trailPaint);
  }

  // ── talk: 对话气泡 ───────────────────────────────────────────────────────
  void _drawTalk(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.4;
    final bw = w * 0.55, bh = h * 0.32;

    // bubble
    final bubbleRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: bw, height: bh),
      Radius.circular(w * 0.06),
    );
    canvas.drawRRect(bubbleRRect, Paint()..color = _dc(illustration.bg));

    // tail
    final tailPath = Path()
      ..moveTo(cx - w * 0.08, cy + bh / 2 - 1)
      ..lineTo(cx - w * 0.15, cy + bh / 2 + h * 0.08)
      ..lineTo(cx + w * 0.02, cy + bh / 2 - 1)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = _dc(illustration.bg));

    // animated dots
    final dotPaint = Paint()..color = Colors.white;
    final dotPhase = (t * 3) % 1.0;
    for (int i = 0; i < 3; i++) {
      final da = ((dotPhase + i * 0.33) % 1.0);
      final dotSize = 5.0 + (1.0 - da) * 4;
      final dotX = cx - w * 0.1 + i * w * 0.1;
      final dotY = cy + sin(da * pi) * h * 0.03;
      canvas.drawCircle(Offset(dotX, dotY), dotSize, dotPaint);
    }
  }

  // ── walk: 行走小人 ───────────────────────────────────────────────────────
  void _drawWalk(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final phase = sin(t * pi * 2);
    _drawStickFigure(canvas, w / 2, h * 0.35, w * 0.35, illustration.bg,
      leftArmAngle: -1.8 + phase * 0.2,
      rightArmAngle: -1.2 - phase * 0.2,
      leftLegAngle: -0.3 + phase * 0.15,
      rightLegAngle: 0.3 - phase * 0.15,
      armLen: 0.35,
      legLen: 0.45,
    );

    // ground line
    final groundPaint = Paint()
      ..color = illustration.accent.withOpacity(_minOp(0.3))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(w * 0.15, h * 0.85), Offset(w * 0.85, h * 0.85), groundPaint);
  }

  // ── wave: 挥手 ───────────────────────────────────────────────────────────
  void _drawWave(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.4;
    final waveAngle = sin(t * pi * 2) * 0.3;

    // forearm
    final armPaint = Paint()
      ..color = const Color(0xFFBCAAA4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy + h * 0.2), Offset(cx - w * 0.05, cy - h * 0.05), armPaint);

    // hand (open palm)
    canvas.save();
    canvas.translate(cx - w * 0.05, cy - h * 0.05);
    canvas.rotate(waveAngle - 0.2);
    final handPaint = Paint()..color = const Color(0xFFBCAAA4);

    // palm
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-w * 0.06, -h * 0.12, w * 0.12, h * 0.1),
        const Radius.circular(6),
      ),
      handPaint,
    );

    // fingers
    for (int i = 0; i < 4; i++) {
      final fx = -w * 0.04 + i * w * 0.028;
      final fingerH = h * (0.06 + (i == 1 || i == 2 ? 0.02 : 0));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(fx, -h * 0.12 - fingerH, w * 0.02, fingerH),
          const Radius.circular(3),
        ),
        handPaint,
      );
    }
    // thumb
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-w * 0.07, -h * 0.08, w * 0.02, h * 0.05),
        const Radius.circular(3),
      ),
      handPaint,
    );
    canvas.restore();

    // motion lines
    final motionPaint = Paint()
      ..color = illustration.accent.withOpacity(_minOp(0.6))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final linePhase = (sin(t * pi * 2 + i * 0.8) + 1) / 2;
      final lx = cx - w * 0.15 - i * w * 0.08;
      final ly = cy - h * 0.12 + i * h * 0.06;
      canvas.drawLine(
        Offset(lx - w * 0.04 * linePhase, ly),
        Offset(lx + w * 0.04 * linePhase, ly),
        motionPaint,
      );
    }
  }

  // ── wet: 水滴 ─────────────────────────────────────────────────────────────
  void _drawWet(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.4;

    // main water drop
    final dropPath = Path()
      ..moveTo(cx, cy - h * 0.25)
      ..cubicTo(cx - w * 0.18, cy, cx - w * 0.15, cy + h * 0.15, cx, cy + h * 0.2)
      ..cubicTo(cx + w * 0.15, cy + h * 0.15, cx + w * 0.18, cy, cx, cy - h * 0.25)
      ..close();
    canvas.drawPath(dropPath, Paint()..color = _dc(illustration.bg));

    // highlight
    final hlPaint = Paint()..color = Colors.white.withOpacity(0.3);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - w * 0.04, cy - h * 0.02), width: w * 0.06, height: h * 0.08),
      hlPaint,
    );

    // small falling drops
    final fallPhase = (t * 1.5) % 1.0;
    final smallPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    for (int i = 0; i < 4; i++) {
      final dx = cx + (i - 1.5) * w * 0.15;
      final dy = h * ((fallPhase + i * 0.25) % 1.0);
      final dropH = 8.0 + (1.0 - ((fallPhase + i * 0.25) % 1.0)) * 4;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(dx, dy), width: 5, height: dropH),
        smallPaint,
      );
    }

    // splash at bottom
    final splashPaint = Paint()
      ..color = illustration.accent.withOpacity(_minOp(0.3))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final splashPhase = sin(t * pi * 2) * 0.5 + 0.5;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, h * 0.88), width: w * 0.2 * splashPhase, height: h * 0.06 * splashPhase),
      pi, pi, false, splashPaint,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 新增40个单词插画
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawEat(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final p = Paint()..color = _dc(illustration.accent);
    // plate
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.1), width: w * 0.4, height: h * 0.12), p);
    // fork
    final forkP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.7))..strokeWidth = 2.5..style = PaintingStyle.stroke;
    final forkPath = Path()
      ..moveTo(cx - w * 0.18, cy - h * 0.2)
      ..lineTo(cx - w * 0.18, cy + h * 0.02);
    for (int i = -1; i <= 1; i++) {
      forkPath.moveTo(cx - w * 0.18 + i * w * 0.03, cy - h * 0.2);
      forkPath.lineTo(cx - w * 0.18 + i * w * 0.03, cy - h * 0.28);
    }
    canvas.drawPath(forkPath, forkP);
    // food bounce
    final bounce = sin(t * pi * 2) * h * 0.01;
    canvas.drawCircle(Offset(cx + w * 0.05, cy + h * 0.03 + bounce), w * 0.06, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
  }

  void _drawDrink(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // cup body
    final cupP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    final cupPath = Path()
      ..moveTo(cx - w * 0.1, cy - h * 0.15)
      ..lineTo(cx - w * 0.08, cy + h * 0.15)
      ..lineTo(cx + w * 0.08, cy + h * 0.15)
      ..lineTo(cx + w * 0.1, cy - h * 0.15)
      ..close();
    canvas.drawPath(cupPath, cupP);
    // handle
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + w * 0.14, cy + h * 0.02), width: w * 0.1, height: h * 0.12),
      -pi * 0.4, pi * 0.8, false, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = 2.5,
    );
    // steam
    final steamP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35))..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = -1; i <= 1; i++) {
      final sx = cx + i * w * 0.05;
      final wave = sin(t * pi * 2 + i * 1.5) * w * 0.02;
      canvas.drawLine(Offset(sx + wave, cy - h * 0.18), Offset(sx - wave, cy - h * 0.28), steamP);
    }
  }

  void _drawCook(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.48;
    final p = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    // pot body
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.35, height: h * 0.2), Radius.circular(w * 0.04)), p,
    );
    // handles
    final hP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx - w * 0.2, cy - h * 0.02), Offset(cx - w * 0.26, cy - h * 0.02), hP);
    canvas.drawLine(Offset(cx + w * 0.2, cy - h * 0.02), Offset(cx + w * 0.26, cy - h * 0.02), hP);
    // steam lines
    final sP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = -1; i <= 1; i++) {
      final sx = cx + i * w * 0.08;
      final wave = sin(t * pi * 2 + i * 2) * w * 0.015;
      canvas.drawLine(Offset(sx, cy - h * 0.12), Offset(sx + wave, cy - h * 0.25), sP);
    }
  }

  void _drawRead(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // book pages
    final bookP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    final leftPage = Path()
      ..moveTo(cx, cy - h * 0.15)
      ..lineTo(cx - w * 0.18, cy - h * 0.1)
      ..lineTo(cx - w * 0.18, cy + h * 0.12)
      ..lineTo(cx, cy + h * 0.08)
      ..close();
    final rightPage = Path()
      ..moveTo(cx, cy - h * 0.15)
      ..lineTo(cx + w * 0.18, cy - h * 0.1)
      ..lineTo(cx + w * 0.18, cy + h * 0.12)
      ..lineTo(cx, cy + h * 0.08)
      ..close();
    canvas.drawPath(leftPage, bookP);
    canvas.drawPath(rightPage, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    // text lines
    final lineP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.25))..strokeWidth = 1..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final ly = cy - h * 0.04 + i * h * 0.05;
      canvas.drawLine(Offset(cx - w * 0.14, ly), Offset(cx - w * 0.03, ly), lineP);
      canvas.drawLine(Offset(cx + w * 0.03, ly), Offset(cx + w * 0.14, ly), lineP);
    }
  }

  void _drawWrite(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // paper
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy + h * 0.05), width: w * 0.3, height: h * 0.35), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25)));
    // text lines
    final lineP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.25))..strokeWidth = 1..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final ly = cy - h * 0.06 + i * h * 0.06;
      final lw = w * (0.18 - i * 0.02);
      canvas.drawLine(Offset(cx - w * 0.1, ly), Offset(cx - w * 0.1 + lw, ly), lineP);
    }
    // pencil
    final penP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    final tipY = cy - h * 0.06 + 3 * h * 0.06;
    final tipX = cx - w * 0.1 + w * (0.18 - 3 * 0.02);
    canvas.drawLine(Offset(tipX, tipY), Offset(tipX + w * 0.1, tipY - h * 0.18), penP);
  }

  void _drawSing(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    // microphone
    final micP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - h * 0.05), width: w * 0.08, height: h * 0.14), Radius.circular(w * 0.04)), micP,
    );
    final standP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx, cy + h * 0.02), Offset(cx, cy + h * 0.18), standP);
    // music notes floating
    final noteP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    for (int i = 0; i < 3; i++) {
      final phase = t * pi * 2 + i * 2.1;
      final nx = cx + w * (0.12 + i * 0.06) + sin(phase) * w * 0.03;
      final ny = cy - h * (0.1 + i * 0.06) + cos(phase) * h * 0.03;
      final nr = w * 0.025;
      canvas.drawOval(Rect.fromCenter(center: Offset(nx, ny), width: nr * 2, height: nr * 1.4), noteP);
      canvas.drawLine(Offset(nx + nr, ny), Offset(nx + nr, ny - h * 0.06), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 1.5);
    }
  }

  void _drawDance(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final sway = sin(t * pi * 2) * w * 0.04;
    final armUp = sin(t * pi * 2) * 0.3;
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6))..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    // head
    canvas.drawCircle(Offset(cx + sway, cy - h * 0.15), w * 0.05, p);
    // body
    canvas.drawLine(Offset(cx + sway, cy - h * 0.1), Offset(cx + sway, cy + h * 0.08), p);
    // arms up
    canvas.drawLine(Offset(cx + sway, cy - h * 0.04), Offset(cx + sway - w * 0.15, cy - h * (0.12 + armUp * 0.1)), p);
    canvas.drawLine(Offset(cx + sway, cy - h * 0.04), Offset(cx + sway + w * 0.15, cy - h * (0.08 + armUp * 0.15)), p);
    // legs
    final legSwing = sin(t * pi * 2) * w * 0.06;
    canvas.drawLine(Offset(cx + sway, cy + h * 0.08), Offset(cx + sway - w * 0.08 + legSwing, cy + h * 0.2), p);
    canvas.drawLine(Offset(cx + sway, cy + h * 0.08), Offset(cx + sway + w * 0.08 - legSwing, cy + h * 0.2), p);
  }

  void _drawSwim(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.48;
    final wave = sin(t * pi * 2) * w * 0.03;
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    // body horizontal
    canvas.drawLine(Offset(cx - w * 0.15 + wave, cy), Offset(cx + w * 0.1 + wave, cy), p);
    // head
    canvas.drawCircle(Offset(cx - w * 0.18 + wave, cy), w * 0.04, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    // arm splash
    final armAngle = sin(t * pi * 2) * 0.8;
    canvas.drawLine(Offset(cx + wave, cy), Offset(cx + w * 0.1 + wave + cos(armAngle) * w * 0.08, cy - h * 0.1 + sin(armAngle) * h * 0.05), p);
    // water waves
    final wP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..style = PaintingStyle.stroke..strokeWidth = 1.5;
    for (int i = 0; i < 3; i++) {
      final wy = cy + h * (0.08 + i * 0.06);
      final path = Path();
      for (double x = 0; x < w; x += 2) {
        final y = wy + sin((x / w * 4 + t * pi * 2 + i) * pi) * h * 0.015;
        if (x == 0) path.moveTo(x, y); else path.lineTo(x, y);
      }
      canvas.drawPath(path, wP);
    }
  }

  void _drawFly(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.4;
    final floatY = sin(t * pi * 2) * h * 0.04;
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    // body
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + floatY), width: w * 0.06, height: h * 0.12), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    // wings
    final wingFlap = sin(t * pi * 4) * 0.3;
    final wingP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - w * 0.1, cy - h * 0.04 + floatY), width: w * 0.18, height: h * 0.04 * (1 + wingFlap)), wingP);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.1, cy - h * 0.04 + floatY), width: w * 0.18, height: h * 0.04 * (1 + wingFlap)), wingP);
    // trail dots
    for (int i = 1; i <= 3; i++) {
      final dotAlpha = (0.3 - i * 0.08).clamp(0.0, 1.0);
      canvas.drawCircle(Offset(cx - w * 0.04 * i, cy + h * 0.1 + floatY + i * h * 0.02), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(dotAlpha)));
    }
  }

  void _drawSleep(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // pillow
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + h * 0.05), width: w * 0.35, height: h * 0.12), Radius.circular(w * 0.06)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)),
    );
    // Z letters floating
    final zP = TextStyle(color: illustration.bg.withOpacity(_minOp(0.6)), fontSize: w * 0.08, fontWeight: FontWeight.bold);
    for (int i = 0; i < 3; i++) {
      final phase = t * pi * 2 + i * 0.8;
      final zx = cx + w * (0.1 + i * 0.06) + sin(phase) * w * 0.02;
      final zy = cy - h * (0.08 + i * 0.07) + cos(phase) * h * 0.02;
      final tp = TextPainter(text: TextSpan(text: 'z', style: zP.copyWith(fontSize: w * (0.06 + i * 0.02))), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(zx - tp.width / 2, zy - tp.height / 2));
    }
    // closed eyes line
    final eyeP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx - w * 0.06, cy - h * 0.02), width: w * 0.06, height: h * 0.02), 0, pi, false, eyeP);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx + w * 0.06, cy - h * 0.02), width: w * 0.06, height: h * 0.02), 0, pi, false, eyeP);
  }

  void _drawOpen(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final angle = (sin(t * pi * 2) + 1) / 2 * 0.5; // 0 to 0.5 rad
    // door frame
    final frameP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..style = PaintingStyle.stroke..strokeWidth = 3;
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.3, height: h * 0.35), frameP);
    // door (opens with perspective)
    final doorP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    final doorW = w * 0.28 * cos(angle);
    canvas.drawRect(Rect.fromLTWH(cx - doorW / 2, cy - h * 0.17, doorW, h * 0.35), doorP);
    // handle
    canvas.drawCircle(Offset(cx + doorW * 0.3, cy + h * 0.02), w * 0.015, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
  }

  void _drawClose(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // door (closed)
    final doorP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.28, height: h * 0.35), doorP);
    // handle
    canvas.drawCircle(Offset(cx + w * 0.08, cy + h * 0.02), w * 0.015, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6)));
    // lock X
    final lockP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - w * 0.03, cy - h * 0.05), Offset(cx + w * 0.03, cy + h * 0.05), lockP);
    canvas.drawLine(Offset(cx + w * 0.03, cy - h * 0.05), Offset(cx - w * 0.03, cy + h * 0.05), lockP);
  }

  void _drawThrow(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // ball with motion
    final phase = t * pi * 2;
    final bx = cx + w * 0.15 + sin(phase) * w * 0.08;
    final by = cy - h * 0.1 + cos(phase) * h * 0.08;
    canvas.drawCircle(Offset(bx, by), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // motion lines
    final mP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.25))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final lx = bx - w * (0.08 + i * 0.04);
      canvas.drawLine(Offset(lx, by + h * 0.01 * i), Offset(lx - w * 0.04, by + h * 0.01 * i), mP);
    }
    // hand
    canvas.drawCircle(Offset(cx - w * 0.1, cy + h * 0.08), w * 0.035, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
  }

  void _drawCatch(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // net/basket shape
    final netP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.45))..style = PaintingStyle.stroke..strokeWidth = 2.5;
    final netPath = Path()
      ..moveTo(cx - w * 0.02, cy - h * 0.15)
      ..lineTo(cx - w * 0.15, cy + h * 0.08)
      ..lineTo(cx + w * 0.15, cy + h * 0.08)
      ..lineTo(cx + w * 0.02, cy - h * 0.15)
      ..close();
    canvas.drawPath(netPath, netP);
    // handle
    canvas.drawLine(Offset(cx - w * 0.02, cy - h * 0.15), Offset(cx - w * 0.02, cy - h * 0.25), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..strokeCap = StrokeCap.round);
    // ball coming in
    final ballY = cy - h * 0.05 + sin(t * pi * 2) * h * 0.05;
    canvas.drawCircle(Offset(cx + w * 0.08, ballY), w * 0.04, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
  }

  void _drawClimb(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.45, cy = h * 0.45;
    final climbY = sin(t * pi * 2) * h * 0.03;
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    // ladder
    final ladP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx - w * 0.08, cy - h * 0.2), Offset(cx - w * 0.12, cy + h * 0.2), ladP);
    canvas.drawLine(Offset(cx + w * 0.08, cy - h * 0.2), Offset(cx + w * 0.04, cy + h * 0.2), ladP);
    for (int i = 0; i < 4; i++) {
      final ry = cy - h * 0.15 + i * h * 0.1;
      final rxFrac = (ry - (cy - h * 0.2)) / (h * 0.4);
      final rx1 = cx - w * 0.08 - rxFrac * w * 0.04;
      final rx2 = cx + w * 0.08 - rxFrac * w * 0.04;
      canvas.drawLine(Offset(rx1, ry), Offset(rx2, ry), ladP);
    }
    // figure climbing
    final fy = cy + climbY;
    canvas.drawCircle(Offset(cx, fy - h * 0.1), w * 0.04, p);
    canvas.drawLine(Offset(cx, fy - h * 0.06), Offset(cx, fy + h * 0.06), p);
    canvas.drawLine(Offset(cx, fy), Offset(cx - w * 0.1, fy - h * 0.06), p);
    canvas.drawLine(Offset(cx, fy), Offset(cx + w * 0.06, fy - h * 0.04), p);
    canvas.drawLine(Offset(cx, fy + h * 0.06), Offset(cx - w * 0.04, fy + h * 0.16), p);
    canvas.drawLine(Offset(cx, fy + h * 0.06), Offset(cx + w * 0.06, fy + h * 0.14), p);
  }

  void _drawSit(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.48;
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    // chair
    final chairP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35))..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx - w * 0.1, cy - h * 0.15), Offset(cx - w * 0.1, cy + h * 0.15), chairP);
    canvas.drawLine(Offset(cx - w * 0.1, cy + h * 0.02), Offset(cx + w * 0.1, cy + h * 0.02), chairP);
    canvas.drawLine(Offset(cx + w * 0.1, cy + h * 0.02), Offset(cx + w * 0.1, cy + h * 0.15), chairP);
    canvas.drawLine(Offset(cx - w * 0.1, cy + h * 0.15), Offset(cx + w * 0.1, cy + h * 0.15), chairP);
    // sitting figure
    canvas.drawCircle(Offset(cx, cy - h * 0.12), w * 0.04, p);
    canvas.drawLine(Offset(cx, cy - h * 0.08), Offset(cx, cy + h * 0.02), p);
    canvas.drawLine(Offset(cx, cy + h * 0.02), Offset(cx - w * 0.06, cy + h * 0.02), p);
    canvas.drawLine(Offset(cx, cy + h * 0.02), Offset(cx + w * 0.06, cy + h * 0.02), p);
  }

  void _drawStand(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    // standing figure
    canvas.drawCircle(Offset(cx, cy - h * 0.15), w * 0.05, p);
    canvas.drawLine(Offset(cx, cy - h * 0.1), Offset(cx, cy + h * 0.1), p);
    canvas.drawLine(Offset(cx, cy - h * 0.04), Offset(cx - w * 0.12, cy + h * 0.02), p);
    canvas.drawLine(Offset(cx, cy - h * 0.04), Offset(cx + w * 0.12, cy + h * 0.02), p);
    canvas.drawLine(Offset(cx, cy + h * 0.1), Offset(cx - w * 0.08, cy + h * 0.22), p);
    canvas.drawLine(Offset(cx, cy + h * 0.1), Offset(cx + w * 0.08, cy + h * 0.22), p);
    // ground line
    canvas.drawLine(Offset(cx - w * 0.15, cy + h * 0.23), Offset(cx + w * 0.15, cy + h * 0.23), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5);
  }

  void _drawFind(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    // magnifying glass
    final pulse = 1.0 + sin(t * pi * 2) * 0.05;
    final gP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..style = PaintingStyle.stroke..strokeWidth = 3;
    canvas.drawCircle(Offset(cx - w * 0.04, cy - h * 0.02), w * 0.1 * pulse, gP);
    canvas.drawLine(Offset(cx - w * 0.04 + w * 0.07 * pulse, cy - h * 0.02 + w * 0.07 * pulse), Offset(cx + w * 0.1, cy + h * 0.1), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 3.5..strokeCap = StrokeCap.round);
    // sparkle inside glass
    final sparkle = ((sin(t * pi * 4) + 1) / 2).clamp(0.0, 1.0);
    canvas.drawCircle(Offset(cx - w * 0.02, cy - h * 0.04), w * 0.02, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3 * sparkle)));
  }

  void _drawBring(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // box
    final bounce = sin(t * pi * 2) * h * 0.015;
    final boxP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy - h * 0.02 + bounce), width: w * 0.22, height: h * 0.18), boxP);
    // tape line
    canvas.drawLine(Offset(cx, cy - h * 0.11 + bounce), Offset(cx, cy + h * 0.07 + bounce), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..strokeWidth = 2);
    // hands underneath
    final hP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - w * 0.12, cy + h * 0.1 + bounce), Offset(cx - w * 0.05, cy + h * 0.09 + bounce), hP);
    canvas.drawLine(Offset(cx + w * 0.12, cy + h * 0.1 + bounce), Offset(cx + w * 0.05, cy + h * 0.09 + bounce), hP);
  }

  void _drawShow(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // presentation board
    final boardP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - h * 0.03), width: w * 0.35, height: h * 0.25), Radius.circular(w * 0.02)), boardP,
    );
    // chart bars
    final barP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5));
    final heights = [0.08, 0.14, 0.1, 0.16];
    for (int i = 0; i < 4; i++) {
      final bx = cx - w * 0.12 + i * w * 0.08;
      final bh = h * heights[i];
      canvas.drawRect(Rect.fromLTWH(bx, cy + h * 0.1 - bh, w * 0.05, bh), barP);
    }
    // pointing hand
    final handP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = 2.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final pointPhase = sin(t * pi * 2) * w * 0.01;
    canvas.drawLine(Offset(cx + w * 0.2, cy - h * 0.12 + pointPhase), Offset(cx + w * 0.1, cy - h * 0.06 + pointPhase), handP);
  }

  // ── 形容词插画 ──

  void _drawBig(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final pulse = 1.0 + sin(t * pi * 2) * 0.04;
    // large circle
    canvas.drawCircle(Offset(cx, cy), w * 0.2 * pulse, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    // arrow pointing outward
    final aP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final angle = i * pi / 2;
      final r1 = w * 0.22 * pulse;
      final r2 = w * 0.3;
      canvas.drawLine(Offset(cx + cos(angle) * r1, cy + sin(angle) * r1), Offset(cx + cos(angle) * r2, cy + sin(angle) * r2), aP);
      // arrowhead
      final ax = cx + cos(angle) * r2;
      final ay = cy + sin(angle) * r2;
      canvas.drawLine(Offset(ax, ay), Offset(ax - cos(angle - 0.4) * w * 0.04, ay - sin(angle - 0.4) * w * 0.04), aP);
      canvas.drawLine(Offset(ax, ay), Offset(ax - cos(angle + 0.4) * w * 0.04, ay - sin(angle + 0.4) * w * 0.04), aP);
    }
  }

  void _drawSmall(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final pulse = 1.0 - sin(t * pi * 2) * 0.05;
    // small circle
    canvas.drawCircle(Offset(cx, cy), w * 0.08 * pulse, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // arrows pointing inward
    final aP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35))..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final angle = i * pi / 2 + pi / 4;
      canvas.drawLine(Offset(cx + cos(angle) * w * 0.25, cy + sin(angle) * w * 0.25), Offset(cx + cos(angle) * w * 0.15, cy + sin(angle) * w * 0.15), aP);
    }
    // sparkles around
    for (int i = 0; i < 5; i++) {
      final angle = i * pi * 2 / 5 + t * pi * 2;
      final r = w * 0.18;
      canvas.drawCircle(Offset(cx + cos(angle) * r, cy + sin(angle) * r), w * 0.01, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.2)));
    }
  }

  void _drawTall(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // tall figure
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, cy - h * 0.2), w * 0.04, p);
    canvas.drawLine(Offset(cx, cy - h * 0.16), Offset(cx, cy + h * 0.12), p);
    canvas.drawLine(Offset(cx, cy - h * 0.08), Offset(cx - w * 0.1, cy - h * 0.02), p);
    canvas.drawLine(Offset(cx, cy - h * 0.08), Offset(cx + w * 0.1, cy - h * 0.02), p);
    canvas.drawLine(Offset(cx, cy + h * 0.12), Offset(cx - w * 0.06, cy + h * 0.22), p);
    canvas.drawLine(Offset(cx, cy + h * 0.12), Offset(cx + w * 0.06, cy + h * 0.22), p);
    // height arrow
    final aP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.45))..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx + w * 0.18, cy - h * 0.22), Offset(cx + w * 0.18, cy + h * 0.22), aP);
    canvas.drawLine(Offset(cx + w * 0.18, cy - h * 0.22), Offset(cx + w * 0.15, cy - h * 0.17), aP);
    canvas.drawLine(Offset(cx + w * 0.18, cy - h * 0.22), Offset(cx + w * 0.21, cy - h * 0.17), aP);
    canvas.drawLine(Offset(cx + w * 0.18, cy + h * 0.22), Offset(cx + w * 0.15, cy + h * 0.17), aP);
    canvas.drawLine(Offset(cx + w * 0.18, cy + h * 0.22), Offset(cx + w * 0.21, cy + h * 0.17), aP);
  }

  void _drawShort(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // short figure
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, cy - h * 0.06), w * 0.04, p);
    canvas.drawLine(Offset(cx, cy - h * 0.02), Offset(cx, cy + h * 0.1), p);
    canvas.drawLine(Offset(cx, cy + h * 0.02), Offset(cx - w * 0.08, cy + h * 0.06), p);
    canvas.drawLine(Offset(cx, cy + h * 0.02), Offset(cx + w * 0.08, cy + h * 0.06), p);
    canvas.drawLine(Offset(cx, cy + h * 0.1), Offset(cx - w * 0.06, cy + h * 0.18), p);
    canvas.drawLine(Offset(cx, cy + h * 0.1), Offset(cx + w * 0.06, cy + h * 0.18), p);
    // double arrow horizontal (small height)
    final aP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.45))..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx + w * 0.16, cy - h * 0.08), Offset(cx + w * 0.16, cy + h * 0.18), aP);
    canvas.drawLine(Offset(cx + w * 0.16, cy - h * 0.08), Offset(cx + w * 0.13, cy - h * 0.03), aP);
    canvas.drawLine(Offset(cx + w * 0.16, cy - h * 0.08), Offset(cx + w * 0.19, cy - h * 0.03), aP);
    canvas.drawLine(Offset(cx + w * 0.16, cy + h * 0.18), Offset(cx + w * 0.13, cy + h * 0.13), aP);
    canvas.drawLine(Offset(cx + w * 0.16, cy + h * 0.18), Offset(cx + w * 0.19, cy + h * 0.13), aP);
  }

  void _drawNew(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    // sparkle star
    final sparkle = ((sin(t * pi * 2) + 1) / 2).clamp(0.0, 1.0);
    final sP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3 + sparkle * 0.3));
    _drawStarShape(canvas, cx, cy, w * 0.2, w * 0.08, 4, sP);
    // "NEW" text sparkle effect
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3 + t * pi;
      final r = w * 0.25 + sin(t * pi * 2 + i) * w * 0.03;
      final dotAlpha = ((sin(t * pi * 3 + i * 1.1) + 1) / 2).clamp(0.0, 1.0);
      canvas.drawCircle(Offset(cx + cos(angle) * r, cy + sin(angle) * r), w * 0.015, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.2 * dotAlpha)));
    }
  }

  void _drawOld(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    // hourglass
    final hP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 2.5..style = PaintingStyle.stroke;
    final topPath = Path()
      ..moveTo(cx - w * 0.1, cy - h * 0.15)
      ..lineTo(cx + w * 0.1, cy - h * 0.15)
      ..lineTo(cx + w * 0.02, cy)
      ..lineTo(cx - w * 0.02, cy)
      ..close();
    final bottomPath = Path()
      ..moveTo(cx - w * 0.02, cy)
      ..lineTo(cx + w * 0.02, cy)
      ..lineTo(cx + w * 0.1, cy + h * 0.15)
      ..lineTo(cx - w * 0.1, cy + h * 0.15)
      ..close();
    canvas.drawPath(topPath, hP);
    canvas.drawPath(bottomPath, hP);
    // sand falling
    final sandP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4));
    final sandPhase = (t * pi * 2) % (pi * 2);
    canvas.drawCircle(Offset(cx, cy + h * 0.02 + sandPhase / (pi * 2) * h * 0.08), w * 0.008, sandP);
    // sand pile at bottom
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.12), width: w * 0.12, height: h * 0.03), sandP);
  }

  void _drawDark(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // crescent moon
    final moonP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawCircle(Offset(cx, cy), w * 0.14, moonP);
    canvas.drawCircle(Offset(cx + w * 0.06, cy - h * 0.03), w * 0.12, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.22)));
    // stars
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4 + 0.3;
      final r = w * 0.28 + (i % 2) * w * 0.06;
      final starAlpha = ((sin(t * pi * 2 + i * 1.3) + 1) / 2).clamp(0.0, 1.0);
      canvas.drawCircle(Offset(cx + cos(angle) * r, cy + sin(angle) * r), w * (0.01 + starAlpha * 0.01), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2 + starAlpha * 0.3)));
    }
  }

  void _drawLight(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.4;
    // lightbulb
    final bulbP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawCircle(Offset(cx, cy - h * 0.02), w * 0.12, bulbP);
    // base
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.04, cy + h * 0.08, w * 0.08, h * 0.04), bulbP);
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.05, cy + h * 0.12, w * 0.1, h * 0.02), bulbP);
    // glow rays
    final glowAlpha = (sin(t * pi * 2) + 1) / 2 * 0.3 + 0.1;
    final glowP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(glowAlpha))..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final r1 = w * 0.16;
      final r2 = w * (0.22 + sin(t * pi * 2 + i) * 0.02);
      canvas.drawLine(Offset(cx + cos(angle) * r1, cy - h * 0.02 + sin(angle) * r1), Offset(cx + cos(angle) * r2, cy - h * 0.02 + sin(angle) * r2), glowP);
    }
  }

  void _drawStrong(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // flexed arm / bicep
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(_dop(0.5)))..strokeWidth = isDark ? 5 : 4..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final flexPhase = sin(t * pi * 2) * 0.15;
    final armPath = Path()
      ..moveTo(cx - w * 0.15, cy + h * 0.08)
      ..lineTo(cx - w * 0.08, cy - h * 0.02)
      ..quadraticBezierTo(cx + w * 0.02, cy - h * (0.15 + flexPhase), cx + w * 0.08, cy - h * 0.05)
      ..lineTo(cx + w * 0.15, cy + h * 0.02);
    if (isDark) {
      canvas.drawPath(armPath, Paint()..color = Colors.white.withOpacity(0.3)..strokeWidth = 7..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
    }
    canvas.drawPath(armPath, p);
    // fist
    final fistRRect = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + w * 0.16, cy + h * 0.04), width: w * 0.07, height: h * 0.06), Radius.circular(w * 0.02));
    if (isDark) {
      canvas.drawRRect(fistRRect, Paint()..color = Colors.white.withOpacity(0.25)..style = PaintingStyle.stroke..strokeWidth = 2);
    }
    canvas.drawRRect(
      fistRRect,
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(_dop(0.45))),
    );
    // power lines
    for (int i = 0; i < 3; i++) {
      final angle = -pi / 4 + i * 0.3;
      final r = w * 0.25;
      final sparkAlpha = ((sin(t * pi * 3 + i * 2) + 1) / 2).clamp(0.0, 1.0);
      final sparkOpacity = _dop(0.2 + sparkAlpha * 0.3);
      canvas.drawLine(
        Offset(cx + cos(angle) * r * 0.8, cy - h * 0.05 + sin(angle) * r * 0.8),
        Offset(cx + cos(angle) * r, cy - h * 0.05 + sin(angle) * r),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(sparkOpacity))..strokeWidth = isDark ? 3 : 2..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawWeak(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // wobbly figure
    final wobble = sin(t * pi * 2) * w * 0.02;
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx + wobble, cy - h * 0.12), w * 0.04, p);
    canvas.drawLine(Offset(cx + wobble, cy - h * 0.08), Offset(cx + wobble * 0.5, cy + h * 0.08), p);
    canvas.drawLine(Offset(cx + wobble, cy - h * 0.02), Offset(cx - w * 0.1 + wobble, cy + h * 0.04), p);
    canvas.drawLine(Offset(cx + wobble, cy - h * 0.02), Offset(cx + w * 0.1 + wobble, cy + h * 0.04), p);
    canvas.drawLine(Offset(cx + wobble * 0.5, cy + h * 0.08), Offset(cx - w * 0.08, cy + h * 0.2), p);
    canvas.drawLine(Offset(cx + wobble * 0.5, cy + h * 0.08), Offset(cx + w * 0.08, cy + h * 0.2), p);
    // dizzy marks
    final dP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final angle = t * pi * 2 + i * 2.1;
      final dx = cx + wobble + cos(angle) * w * 0.1;
      final dy = cy - h * 0.18 + sin(angle) * h * 0.03;
      canvas.drawLine(Offset(dx - w * 0.02, dy - h * 0.02), Offset(dx + w * 0.02, dy + h * 0.02), dP);
      canvas.drawLine(Offset(dx + w * 0.02, dy - h * 0.02), Offset(dx - w * 0.02, dy + h * 0.02), dP);
    }
  }

  void _drawTired(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // droopy face
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.45))..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, cy), w * 0.12, p);
    // droopy eyes
    canvas.drawLine(Offset(cx - w * 0.06, cy - h * 0.02), Offset(cx - w * 0.02, cy - h * 0.01), p);
    canvas.drawLine(Offset(cx + w * 0.02, cy - h * 0.01), Offset(cx + w * 0.06, cy - h * 0.02), p);
    // yawn mouth
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.06), width: w * 0.06, height: h * 0.03 + sin(t * pi * 2).abs() * h * 0.02), p);
    // zzz
    final zP = TextStyle(color: illustration.accent.withOpacity(_minOp(0.4)), fontSize: w * 0.06, fontWeight: FontWeight.bold);
    for (int i = 0; i < 2; i++) {
      final zx = cx + w * (0.14 + i * 0.05);
      final zy = cy - h * (0.08 + i * 0.06) + sin(t * pi * 2 + i) * h * 0.02;
      final tp = TextPainter(text: TextSpan(text: 'z', style: zP), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(zx, zy));
    }
  }

  void _drawHungry(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    // plate (empty)
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.05), width: w * 0.35, height: h * 0.1), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25)));
    // fork and knife crossed
    final fP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - w * 0.12, cy - h * 0.1), Offset(cx - w * 0.05, cy + h * 0.08), fP);
    for (int i = -1; i <= 1; i++) {
      canvas.drawLine(Offset(cx - w * 0.12 + i * w * 0.02, cy - h * 0.1), Offset(cx - w * 0.12 + i * w * 0.02, cy - h * 0.15), fP);
    }
    canvas.drawLine(Offset(cx + w * 0.12, cy - h * 0.1), Offset(cx + w * 0.05, cy + h * 0.08), fP);
    // growling stomach
    final growl = sin(t * pi * 4).abs();
    canvas.drawCircle(Offset(cx, cy + h * 0.12), w * (0.02 + growl * 0.01), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.15 + growl * 0.15)));
  }

  void _drawScared(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final shake = sin(t * pi * 10) * w * 0.01;
    // face
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.45))..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx + shake, cy), w * 0.12, p);
    // wide eyes
    canvas.drawCircle(Offset(cx - w * 0.05 + shake, cy - h * 0.02), w * 0.025, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    canvas.drawCircle(Offset(cx + w * 0.05 + shake, cy - h * 0.02), w * 0.025, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    // pupils
    canvas.drawCircle(Offset(cx - w * 0.05 + shake, cy - h * 0.02), w * 0.012, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    canvas.drawCircle(Offset(cx + w * 0.05 + shake, cy - h * 0.02), w * 0.012, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // open mouth
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + shake, cy + h * 0.07), width: w * 0.06, height: h * 0.04), p);
    // exclamation marks
    final eP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx + w * 0.18, cy - h * 0.1), Offset(cx + w * 0.18, cy - h * 0.02), eP);
    canvas.drawCircle(Offset(cx + w * 0.18, cy + h * 0.01), w * 0.01, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
  }

  void _drawFriendly(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // two hands shaking
    final wave = sin(t * pi * 2) * w * 0.01;
    final hP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    // left hand
    canvas.drawLine(Offset(cx - w * 0.2, cy + h * 0.02), Offset(cx - w * 0.08, cy - h * 0.02 + wave), hP);
    // right hand
    canvas.drawLine(Offset(cx + w * 0.2, cy + h * 0.02), Offset(cx + w * 0.08, cy - h * 0.02 - wave), hP);
    // clasp
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - h * 0.01), width: w * 0.16, height: h * 0.06), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)),
    );
    // heart above
    final heartP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3));
    final heartScale = 1.0 + sin(t * pi * 2) * 0.1;
    _drawHeartShape(canvas, cx, cy - h * 0.15, w * 0.04 * heartScale, h * 0.03 * heartScale, heartP);
  }

  void _drawSick(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    // face
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, cy), w * 0.12, p);
    // X eyes
    final xP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.45))..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = -1; i <= 1; i += 2) {
      final ex = cx + i * w * 0.05;
      canvas.drawLine(Offset(ex - w * 0.02, cy - h * 0.03), Offset(ex + w * 0.02, cy + h * 0.01), xP);
      canvas.drawLine(Offset(ex + w * 0.02, cy - h * 0.03), Offset(ex - w * 0.02, cy + h * 0.01), xP);
    }
    // wavy mouth
    final mouthPath = Path();
    for (double x = cx - w * 0.06; x <= cx + w * 0.06; x += 2) {
      final y = cy + h * 0.06 + sin((x - cx) / w * 20) * h * 0.01;
      if (x == cx - w * 0.06) mouthPath.moveTo(x, y); else mouthPath.lineTo(x, y);
    }
    canvas.drawPath(mouthPath, p);
    // thermometer
    final tP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 2..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(cx + w * 0.18, cy - h * 0.1), Offset(cx + w * 0.18, cy + h * 0.08), tP);
    canvas.drawCircle(Offset(cx + w * 0.18, cy + h * 0.1), w * 0.025, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // mercury level (animated)
    final level = h * 0.04 + sin(t * pi * 2) * h * 0.02;
    canvas.drawRect(Rect.fromLTWH(cx + w * 0.17, cy + h * 0.08 - level, w * 0.02, level), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
  }

  void _drawDeep(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // water layers (gradient depth)
    for (int i = 0; i < 5; i++) {
      final layerH = h * 0.08;
      final y = cy - h * 0.15 + i * layerH;
      final alpha = 0.15 + i * 0.06;
      canvas.drawRect(Rect.fromLTWH(cx - w * 0.2, y, w * 0.4, layerH), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(alpha)));
    }
    // arrow pointing down
    final aP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    final arrowY = cy + h * 0.15 + sin(t * pi * 2) * h * 0.02;
    canvas.drawLine(Offset(cx, cy + h * 0.05), Offset(cx, arrowY), aP);
    canvas.drawLine(Offset(cx, arrowY), Offset(cx - w * 0.05, arrowY - h * 0.05), aP);
    canvas.drawLine(Offset(cx, arrowY), Offset(cx + w * 0.05, arrowY - h * 0.05), aP);
  }

  void _drawSweet(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // candy
    final rot = sin(t * pi * 2) * 0.1;
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(rot);
    // candy body
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: w * 0.16, height: h * 0.14), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // wrapper ends
    final wP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35))..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-w * 0.08, 0), Offset(-w * 0.18, -h * 0.06), wP);
    canvas.drawLine(Offset(-w * 0.08, 0), Offset(-w * 0.18, h * 0.06), wP);
    canvas.drawLine(Offset(w * 0.08, 0), Offset(w * 0.18, -h * 0.06), wP);
    canvas.drawLine(Offset(w * 0.08, 0), Offset(w * 0.18, h * 0.06), wP);
    // stripes
    canvas.drawLine(Offset(-w * 0.03, -h * 0.07), Offset(-w * 0.03, h * 0.07), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.2))..strokeWidth = 2);
    canvas.drawLine(Offset(w * 0.03, -h * 0.07), Offset(w * 0.03, h * 0.07), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.2))..strokeWidth = 2);
    canvas.restore();
    // sparkles
    for (int i = 0; i < 4; i++) {
      final angle = i * pi / 2 + t * pi;
      final r = w * 0.25;
      final sa = ((sin(t * pi * 2 + i * 1.5) + 1) / 2).clamp(0.0, 1.0);
      canvas.drawCircle(Offset(cx + cos(angle) * r, cy + sin(angle) * r), w * 0.012, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.15 + sa * 0.2)));
    }
  }

  void _drawNoisy(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // speaker
    final spP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5));
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.1, cy - h * 0.06, w * 0.08, h * 0.12), spP);
    final conePath = Path()
      ..moveTo(cx - w * 0.02, cy - h * 0.06)
      ..lineTo(cx + w * 0.08, cy - h * 0.12)
      ..lineTo(cx + w * 0.08, cy + h * 0.12)
      ..lineTo(cx - w * 0.02, cy + h * 0.06)
      ..close();
    canvas.drawPath(conePath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    // sound waves
    for (int i = 1; i <= 3; i++) {
      final waveAlpha = ((sin(t * pi * 2 - i * 0.5) + 1) / 2).clamp(0.0, 1.0);
      final waveP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15 + waveAlpha * 0.25))..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx + w * 0.08, cy), width: w * 0.1 * i * 2, height: h * 0.1 * i * 2),
        -pi * 0.35, pi * 0.7, false, waveP,
      );
    }
  }

  void _drawQuiet(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // finger over lips (shh gesture)
    final p = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    // face outline
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.22, height: h * 0.25), p);
    // nose
    canvas.drawLine(Offset(cx, cy - h * 0.03), Offset(cx + w * 0.02, cy + h * 0.02), p);
    // finger across lips
    canvas.drawLine(Offset(cx - w * 0.12, cy + h * 0.04), Offset(cx + w * 0.1, cy + h * 0.04), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 4..strokeCap = StrokeCap.round);
    // subtle "shh" curves
    final shP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25))..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 2; i++) {
      final sy = cy + h * (0.08 + i * 0.04);
      final fade = (1.0 - t).clamp(0.0, 1.0);
      canvas.drawArc(Rect.fromCenter(center: Offset(cx + w * 0.08, sy), width: w * 0.08, height: h * 0.02), 0, pi, false, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15 * fade))..style = PaintingStyle.stroke..strokeWidth = 1.5);
    }
  }

  void _drawPretty(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    // flower
    final petalP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.45));
    final breathe = sin(t * pi * 2) * w * 0.01;
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      final pr = w * 0.09 + breathe;
      canvas.drawOval(Rect.fromCenter(center: Offset(cx + cos(angle) * pr, cy + sin(angle) * pr), width: w * 0.1, height: h * 0.07), petalP);
    }
    // center
    canvas.drawCircle(Offset(cx, cy), w * 0.05, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    // stem
    canvas.drawLine(Offset(cx, cy + h * 0.08), Offset(cx, cy + h * 0.22), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35))..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    // leaf
    final leafP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.06, cy + h * 0.16), width: w * 0.1, height: h * 0.04), leafP);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 第三批插画 (41 个常用动词/形容词)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawGo(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 箭头指向右方，表示"去"
    final p = Paint()..color = _dc(illustration.accent);
    final path = Path()
      ..moveTo(cx - w * 0.3, cy - h * 0.06)
      ..lineTo(cx + w * 0.15, cy - h * 0.06)
      ..lineTo(cx + w * 0.15, cy - h * 0.15)
      ..lineTo(cx + w * 0.3, cy)
      ..lineTo(cx + w * 0.15, cy + h * 0.15)
      ..lineTo(cx + w * 0.15, cy + h * 0.06)
      ..lineTo(cx - w * 0.3, cy + h * 0.06)
      ..close();
    canvas.drawPath(path, p);
    // 运动轨迹点
    for (int i = 0; i < 3; i++) {
      final dx = cx - w * 0.35 - i * w * 0.08;
      final opacity = 0.2 + i * 0.15;
      canvas.drawCircle(Offset(dx, cy), w * 0.02, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(opacity)));
    }
  }

  void _drawCome(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 箭头指向左方（向观众走来）
    final p = Paint()..color = _dc(illustration.accent);
    final path = Path()
      ..moveTo(cx + w * 0.3, cy - h * 0.06)
      ..lineTo(cx - w * 0.15, cy - h * 0.06)
      ..lineTo(cx - w * 0.15, cy - h * 0.15)
      ..lineTo(cx - w * 0.3, cy)
      ..lineTo(cx - w * 0.15, cy + h * 0.15)
      ..lineTo(cx - w * 0.15, cy + h * 0.06)
      ..lineTo(cx + w * 0.3, cy + h * 0.06)
      ..close();
    canvas.drawPath(path, p);
    // 目标点 (星形标记)
    _drawStarShape(canvas, cx - w * 0.3, cy, w * 0.06, w * 0.03, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
  }

  void _drawGet(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.48;
    // 手掌（接收）
    final handP = Paint()..color = _dc(illustration.accent);
    // 手掌
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + h * 0.08), width: w * 0.22, height: h * 0.14), Radius.circular(w * 0.04)),
      handP,
    );
    // 手指
    for (int i = -1; i <= 1; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx + i * w * 0.07, cy - h * 0.04), width: w * 0.05, height: h * 0.1), Radius.circular(w * 0.025)),
        handP,
      );
    }
    // 落下的礼物
    final giftP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5 + sin(t * pi * 2) * 0.3));
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy - h * 0.18 + sin(t * pi * 2) * h * 0.04), width: w * 0.1, height: h * 0.08), giftP);
  }

  void _drawMake(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 齿轮（制造/创造）
    final gearP = Paint()..color = _dc(illustration.accent);
    final teeth = 8;
    final outerR = w * 0.22;
    final innerR = w * 0.17;
    final path = Path();
    for (int i = 0; i < teeth * 2; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = i * pi / teeth;
      final x = cx + cos(angle) * r;
      final y = cy + sin(angle) * r;
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, gearP);
    // 中心圆
    canvas.drawCircle(Offset(cx, cy), w * 0.08, Paint()..color = _dc(illustration.bg));
    canvas.drawCircle(Offset(cx, cy), w * 0.05, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
  }

  void _drawTake(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 手拿物品
    final handP = Paint()..color = _dc(illustration.accent);
    // 手（从上方拿起）
    final handPath = Path()
      ..moveTo(cx - w * 0.08, cy + h * 0.05)
      ..lineTo(cx - w * 0.12, cy - h * 0.15)
      ..lineTo(cx - w * 0.04, cy - h * 0.18)
      ..lineTo(cx, cy - h * 0.12)
      ..lineTo(cx + w * 0.04, cy - h * 0.18)
      ..lineTo(cx + w * 0.12, cy - h * 0.15)
      ..lineTo(cx + w * 0.08, cy + h * 0.05)
      ..close();
    canvas.drawPath(handPath, handP);
    // 被拿的物体
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - h * 0.04 + sin(t * pi * 2) * h * 0.03), width: w * 0.2, height: h * 0.12), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
  }

  void _drawGive(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 双手递出
    final handP = Paint()..color = _dc(illustration.accent);
    // 左手
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - w * 0.1, cy + h * 0.05), width: w * 0.16, height: h * 0.1), handP);
    // 右手（伸出）
    final reach = sin(t * pi * 2) * w * 0.04;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.12 + reach, cy - h * 0.02), width: w * 0.16, height: h * 0.1), handP);
    // 心形（给予爱）
    _drawHeartShape(canvas, cx + w * 0.02, cy - h * 0.1, w * 0.08, h * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
  }

  void _drawThink(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // 头部
    final headP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(cx, cy), w * 0.18, headP);
    // 眼睛（向上看）
    final eyeP = Paint()..color = _dc(illustration.bg);
    canvas.drawCircle(Offset(cx - w * 0.07, cy - h * 0.02), w * 0.03, eyeP);
    canvas.drawCircle(Offset(cx + w * 0.07, cy - h * 0.02), w * 0.03, eyeP);
    // 瞳孔向上
    canvas.drawCircle(Offset(cx - w * 0.07, cy - h * 0.035), w * 0.015, headP);
    canvas.drawCircle(Offset(cx + w * 0.07, cy - h * 0.035), w * 0.015, headP);
    // 手托腮
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - w * 0.18, cy + h * 0.08), width: w * 0.1, height: h * 0.08), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // 思考泡泡
    for (int i = 0; i < 3; i++) {
      final r = w * 0.02 * (3 - i);
      final px = cx + w * 0.16 + i * w * 0.06;
      final py = cy - h * 0.16 - i * h * 0.08;
      canvas.drawCircle(Offset(px, py), r, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3 + i * 0.15)));
    }
  }

  void _drawSay(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // 说话气泡
    final bubbleP = Paint()..color = _dc(illustration.accent);
    final bx = cx, by = cy;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(bx, by), width: w * 0.5, height: h * 0.3), Radius.circular(w * 0.1)),
      bubbleP,
    );
    // 气泡尾巴
    final tailPath = Path()
      ..moveTo(bx - w * 0.05, by + h * 0.15)
      ..lineTo(bx - w * 0.15, by + h * 0.25)
      ..lineTo(bx + w * 0.02, by + h * 0.15)
      ..close();
    canvas.drawPath(tailPath, bubbleP);
    // 文字线条
    final lineP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 2..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(bx - w * 0.15, by - h * 0.04), Offset(bx + w * 0.15, by - h * 0.04), lineP);
    canvas.drawLine(Offset(bx - w * 0.12, by + h * 0.04), Offset(bx + w * 0.12, by + h * 0.04), lineP);
  }

  void _drawSee(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 大眼睛
    final eyeP = Paint()..color = _dc(illustration.accent);
    // 眼白
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.5, height: h * 0.3), eyeP);
    // 虹膜
    canvas.drawCircle(Offset(cx, cy), w * 0.12, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.8)));
    // 瞳孔
    canvas.drawCircle(Offset(cx, cy), w * 0.06, Paint()..color = _dc(illustration.bg));
    // 高光
    canvas.drawCircle(Offset(cx + w * 0.04, cy - h * 0.04), w * 0.025, Paint()..color = Colors.white.withOpacity(0.7));
    // 睫毛
    final lashP = Paint()..color = _dc(illustration.accent)..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    for (int i = -2; i <= 2; i++) {
      final angle = i * 0.3;
      canvas.drawLine(
        Offset(cx + cos(angle - pi/2) * w * 0.24, cy + sin(angle - pi/2) * h * 0.14),
        Offset(cx + cos(angle - pi/2) * w * 0.3, cy + sin(angle - pi/2) * h * 0.19),
        lashP,
      );
    }
  }

  void _drawHear(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 耳朵
    final earP = Paint()..color = _dc(illustration.accent);
    final earPath = Path()
      ..moveTo(cx, cy + h * 0.2)
      ..cubicTo(cx - w * 0.25, cy + h * 0.15, cx - w * 0.3, cy - h * 0.1, cx - w * 0.1, cy - h * 0.2)
      ..cubicTo(cx + w * 0.05, cy - h * 0.25, cx + w * 0.15, cy - h * 0.15, cx + w * 0.05, cy - h * 0.05)
      ..cubicTo(cx + w * 0.15, cy, cx + w * 0.1, cy + h * 0.15, cx, cy + h * 0.2)
      ..close();
    canvas.drawPath(earPath, earP);
    // 内耳
    final innerP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    final innerPath = Path()
      ..moveTo(cx, cy + h * 0.12)
      ..cubicTo(cx - w * 0.12, cy + h * 0.08, cx - w * 0.15, cy - h * 0.05, cx - w * 0.05, cy - h * 0.1)
      ..cubicTo(cx + w * 0.02, cy - h * 0.12, cx + w * 0.06, cy - h * 0.06, cx + w * 0.02, cy - h * 0.02)
      ..cubicTo(cx + w * 0.06, cy, cx + w * 0.04, cy + h * 0.08, cx, cy + h * 0.12)
      ..close();
    canvas.drawPath(innerPath, innerP);
    // 声波
    for (int i = 1; i <= 3; i++) {
      final waveP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2 + 0.1 * (3 - i)))..strokeWidth = 2..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx + w * 0.15, cy - h * 0.05), width: w * 0.15 * i, height: h * 0.15 * i),
        -pi * 0.4, pi * 0.8, false, waveP,
      );
    }
  }

  void _drawWant(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 张开的手臂 + 星星（渴望）
    final handP = Paint()..color = _dc(illustration.accent);
    // 身体
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.1), width: w * 0.2, height: h * 0.25), handP);
    // 头
    canvas.drawCircle(Offset(cx, cy - h * 0.12), w * 0.1, handP);
    // 张开的手臂
    final armP = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.04..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - w * 0.08, cy), Offset(cx - w * 0.28, cy - h * 0.1), armP);
    canvas.drawLine(Offset(cx + w * 0.08, cy), Offset(cx + w * 0.28, cy - h * 0.1), armP);
    // 渴望的星星
    final sparkle = 0.5 + sin(t * pi * 2) * 0.5;
    _drawStarShape(canvas, cx, cy - h * 0.28, w * 0.08 * sparkle, w * 0.04 * sparkle, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(sparkle)));
  }

  void _drawNeed(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 感叹号（需要！）
    final exP = Paint()..color = _dc(illustration.accent);
    // 圆形背景
    canvas.drawCircle(Offset(cx, cy), w * 0.25, exP);
    // 感叹号竖线
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - h * 0.08), width: w * 0.06, height: h * 0.22), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.bg),
    );
    // 感叹号点
    canvas.drawCircle(Offset(cx, cy + h * 0.14), w * 0.04, Paint()..color = _dc(illustration.bg));
    // 脉冲动画
    final pulseR = w * 0.25 + sin(t * pi * 2) * w * 0.05;
    canvas.drawCircle(Offset(cx, cy), pulseR, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
  }

  void _drawLeave(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 门 + 离开的人影
    final doorP = Paint()..color = _dc(illustration.accent);
    // 门框
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.3, height: h * 0.5), doorP);
    // 门内（暗色）
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy + h * 0.02), width: w * 0.22, height: h * 0.42), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    // 人影（正在离开，向右偏移出框）
    final personP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7));
    final dx = sin(t * pi * 2) * w * 0.02;
    canvas.drawCircle(Offset(cx + w * 0.12 + dx, cy - h * 0.08), w * 0.05, personP);
    canvas.drawRect(Rect.fromCenter(center: Offset(cx + w * 0.12 + dx, cy + h * 0.05), width: w * 0.06, height: h * 0.14), personP);
  }

  void _drawArrive(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 旗帜 + 位置标记（到达）
    final flagP = Paint()..color = _dc(illustration.accent);
    // 旗杆
    final poleRect = Rect.fromCenter(center: Offset(cx, cy), width: w * 0.03, height: h * 0.5);
    if (isDark) {
      canvas.drawRect(poleRect.inflate(1.5), Paint()..color = Colors.white.withOpacity(0.25));
    }
    canvas.drawRect(poleRect, flagP);
    // 旗帜
    final flagPath = Path()
      ..moveTo(cx, cy - h * 0.25)
      ..lineTo(cx + w * 0.2, cy - h * 0.18)
      ..lineTo(cx, cy - h * 0.1)
      ..close();
    if (isDark) {
      canvas.drawPath(flagPath, _outlineP);
    }
    canvas.drawPath(flagPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(_dop(0.7))));
    // 底座
    final baseR = w * 0.06;
    if (isDark) {
      canvas.drawCircle(Offset(cx, cy + h * 0.25), baseR, _outlineP);
    }
    canvas.drawCircle(Offset(cx, cy + h * 0.25), baseR, flagP);
    // 到达标记星
    final sparkle = (sin(t * pi * 2) + 1) / 2;
    _drawStarShape(canvas, cx + w * 0.22, cy - h * 0.2, w * 0.05 * sparkle, w * 0.025 * sparkle, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(_dop(0.5))));
  }

  void _drawBegin(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 播放按钮（开始）
    final playP = Paint()..color = _dc(illustration.accent);
    // 圆形背景
    canvas.drawCircle(Offset(cx, cy), w * 0.25, playP);
    // 播放三角形
    final triPath = Path()
      ..moveTo(cx - w * 0.08, cy - h * 0.12)
      ..lineTo(cx - w * 0.08, cy + h * 0.12)
      ..lineTo(cx + w * 0.14, cy)
      ..close();
    canvas.drawPath(triPath, Paint()..color = _dc(illustration.bg));
    // 光环动画
    final pulseR = w * 0.25 + sin(t * pi * 2) * w * 0.04;
    canvas.drawCircle(Offset(cx, cy), pulseR, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
  }

  void _drawFinish(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 对勾（完成）
    final checkP = Paint()
      ..color = _dc(illustration.accent)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.06
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final checkPath = Path()
      ..moveTo(cx - w * 0.2, cy)
      ..lineTo(cx - w * 0.05, cy + h * 0.15)
      ..lineTo(cx + w * 0.22, cy - h * 0.15);
    canvas.drawPath(checkPath, checkP);
    // 圆圈
    canvas.drawCircle(Offset(cx, cy), w * 0.28, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    // 庆祝星星
    final sparkle = (sin(t * pi * 2) + 1) / 2;
    _drawStarShape(canvas, cx + w * 0.2, cy - h * 0.22, w * 0.06 * sparkle, w * 0.03 * sparkle, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    _drawStarShape(canvas, cx - w * 0.24, cy - h * 0.15, w * 0.04 * sparkle, w * 0.02 * sparkle, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
  }

  void _drawBuy(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 购物袋
    final bagP = Paint()..color = _dc(illustration.accent);
    // 袋身
    final bagPath = Path()
      ..moveTo(cx - w * 0.18, cy - h * 0.05)
      ..lineTo(cx - w * 0.22, cy + h * 0.2)
      ..lineTo(cx + w * 0.22, cy + h * 0.2)
      ..lineTo(cx + w * 0.18, cy - h * 0.05)
      ..close();
    canvas.drawPath(bagPath, bagP);
    // 袋口
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy - h * 0.05), width: w * 0.4, height: h * 0.04), bagP);
    // 提手
    final handleP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    final handlePath = Path()
      ..moveTo(cx - w * 0.1, cy - h * 0.07)
      ..cubicTo(cx - w * 0.1, cy - h * 0.25, cx + w * 0.1, cy - h * 0.25, cx + w * 0.1, cy - h * 0.07);
    canvas.drawPath(handlePath, handleP);
    // 购物星
    final sparkle = (sin(t * pi * 2) + 1) / 2;
    _drawStarShape(canvas, cx + w * 0.15, cy - h * 0.15, w * 0.04 * sparkle, w * 0.02 * sparkle, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
  }

  void _drawSell(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 价格标签
    final tagP = Paint()..color = _dc(illustration.accent);
    // 标签主体
    final tagPath = Path()
      ..moveTo(cx - w * 0.25, cy - h * 0.05)
      ..lineTo(cx + w * 0.15, cy - h * 0.05)
      ..lineTo(cx + w * 0.25, cy)
      ..lineTo(cx + w * 0.15, cy + h * 0.05)
      ..lineTo(cx - w * 0.25, cy + h * 0.05)
      ..close();
    canvas.drawPath(tagPath, tagP);
    // 标签孔
    canvas.drawCircle(Offset(cx - w * 0.18, cy), w * 0.025, Paint()..color = _dc(illustration.bg));
    // $ 符号
    final dollarP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx + w * 0.02, cy - h * 0.08), Offset(cx + w * 0.02, cy + h * 0.08), dollarP);
    final sPath = Path()
      ..moveTo(cx + w * 0.06, cy - h * 0.04)
      ..cubicTo(cx - w * 0.02, cy - h * 0.06, cx - w * 0.04, cy - h * 0.01, cx + w * 0.02, cy)
      ..cubicTo(cx + w * 0.08, cy + h * 0.01, cx + w * 0.1, cy + h * 0.06, cx + w * 0.02, cy + h * 0.06);
    canvas.drawPath(sPath, dollarP);
  }

  void _drawPlay(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 球（玩耍）
    final ballP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(cx, cy), w * 0.2, ballP);
    // 球花纹弧线
    final stripeP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..style = PaintingStyle.stroke..strokeWidth = 3;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.4, height: h * 0.4), -pi * 0.3, pi * 0.6, false, stripeP);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.4, height: h * 0.4), pi * 0.7, pi * 0.6, false, stripeP);
    // 弹跳动画
    final bounceY = sin(t * pi * 2) * h * 0.06;
    canvas.drawCircle(Offset(cx, cy + bounceY), w * 0.2, ballP);
    // 阴影
    final shadowScale = 1.0 - (bounceY.abs() / (h * 0.06));
    if (shadowScale > 0.3) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + h * 0.25), width: w * 0.3 * shadowScale, height: h * 0.03 * shadowScale),
        Paint()..color = Colors.black.withOpacity(0.08),
      );
    }
  }

  void _drawWin(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 奖杯
    final cupP = Paint()..color = _dc(illustration.accent);
    // 杯身
    final cupPath = Path()
      ..moveTo(cx - w * 0.15, cy - h * 0.2)
      ..lineTo(cx - w * 0.12, cy + h * 0.05)
      ..lineTo(cx + w * 0.12, cy + h * 0.05)
      ..lineTo(cx + w * 0.15, cy - h * 0.2)
      ..close();
    canvas.drawPath(cupPath, cupP);
    // 杯柄
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy + h * 0.1), width: w * 0.06, height: h * 0.1), cupP);
    // 底座
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + h * 0.18), width: w * 0.24, height: h * 0.06), Radius.circular(w * 0.03)),
      cupP,
    );
    // 把手
    final handleP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    final lH = Path()..moveTo(cx - w * 0.15, cy - h * 0.12)..cubicTo(cx - w * 0.28, cy - h * 0.1, cx - w * 0.28, cy + h * 0.02, cx - w * 0.12, cy + h * 0.02);
    final rH = Path()..moveTo(cx + w * 0.15, cy - h * 0.12)..cubicTo(cx + w * 0.28, cy - h * 0.1, cx + w * 0.28, cy + h * 0.02, cx + w * 0.12, cy + h * 0.02);
    canvas.drawPath(lH, handleP);
    canvas.drawPath(rH, handleP);
    // 皇冠星
    final sparkle = (sin(t * pi * 2) + 1) / 2;
    _drawStarShape(canvas, cx, cy - h * 0.28, w * 0.07 * sparkle, w * 0.035 * sparkle, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
  }

  void _drawLose(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 破碎的心/丢失的物品
    final heartP = Paint()..color = _dc(illustration.accent);
    _drawHeartShape(canvas, cx, cy, w * 0.2, h * 0.15, heartP);
    // 裂痕
    final crackP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    final crackPath = Path()
      ..moveTo(cx - w * 0.02, cy - h * 0.12)
      ..lineTo(cx + w * 0.01, cy - h * 0.04)
      ..lineTo(cx - w * 0.03, cy + h * 0.02)
      ..lineTo(cx + w * 0.02, cy + h * 0.08);
    canvas.drawPath(crackPath, crackP);
    // 下落碎片
    for (int i = 0; i < 3; i++) {
      final fallY = (t * 0.3 + i * 0.33) % 1.0;
      final fx = cx + (i - 1) * w * 0.12;
      canvas.drawCircle(Offset(fx, cy + h * 0.1 + fallY * h * 0.1), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4 - fallY * 0.3)));
    }
  }

  void _drawLearn(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 书本 + 灯泡（学习）
    final bookP = Paint()..color = _dc(illustration.accent);
    // 书（打开）
    final leftPage = Path()
      ..moveTo(cx, cy + h * 0.05)
      ..lineTo(cx - w * 0.25, cy - h * 0.05)
      ..lineTo(cx - w * 0.25, cy + h * 0.15)
      ..lineTo(cx, cy + h * 0.2)
      ..close();
    final rightPage = Path()
      ..moveTo(cx, cy + h * 0.05)
      ..lineTo(cx + w * 0.25, cy - h * 0.05)
      ..lineTo(cx + w * 0.25, cy + h * 0.15)
      ..lineTo(cx, cy + h * 0.2)
      ..close();
    canvas.drawPath(leftPage, bookP);
    canvas.drawPath(rightPage, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // 书脊线
    canvas.drawLine(Offset(cx, cy + h * 0.05), Offset(cx, cy + h * 0.2), Paint()..color = _dc(illustration.bg)..strokeWidth = 1.5);
    // 灯泡
    final bulbP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6 + sin(t * pi * 2) * 0.3));
    canvas.drawCircle(Offset(cx, cy - h * 0.15), w * 0.08, bulbP);
    // 灯泡底座
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy - h * 0.08), width: w * 0.06, height: h * 0.03), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
  }

  void _drawTeach(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 黑板
    final boardP = Paint()..color = _dc(illustration.accent);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.6, height: h * 0.4), Radius.circular(w * 0.03)),
      boardP,
    );
    // 黑板内
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.52, height: h * 0.32), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)),
    );
    // 粉笔字（E = mc² 风格）
    final chalkP = Paint()..color = Colors.white.withOpacity(0.8)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    // ABC
    canvas.drawLine(Offset(cx - w * 0.15, cy - h * 0.06), Offset(cx - w * 0.1, cy - h * 0.1), chalkP);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx - w * 0.05, cy - h * 0.07), width: w * 0.08, height: h * 0.06), -pi * 0.4, pi * 0.8, false, chalkP);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx + w * 0.06, cy - h * 0.07), width: w * 0.08, height: h * 0.06), pi * 0.6, pi * 0.8, false, chalkP);
    // 粉笔线条
    canvas.drawLine(Offset(cx - w * 0.15, cy + h * 0.02), Offset(cx + w * 0.15, cy + h * 0.02), chalkP);
    canvas.drawLine(Offset(cx - w * 0.1, cy + h * 0.07), Offset(cx + w * 0.1, cy + h * 0.07), chalkP);
  }

  void _drawTry(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 问号（尝试）
    final qP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(cx, cy), w * 0.25, qP);
    // 问号形状
    final markP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = w * 0.05..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final qPath = Path()
      ..moveTo(cx - w * 0.06, cy + h * 0.05)
      ..cubicTo(cx - w * 0.06, cy - h * 0.08, cx + w * 0.05, cy - h * 0.12, cx + w * 0.05, cy - h * 0.02)
      ..cubicTo(cx + w * 0.05, cy + h * 0.03, cx - w * 0.02, cy + h * 0.02, cx, cy + h * 0.06);
    canvas.drawPath(qPath, markP);
    canvas.drawCircle(Offset(cx, cy + h * 0.13), w * 0.025, Paint()..color = _dc(illustration.bg));
    // 旋转动画
    final angle = sin(t * pi * 2) * 0.1;
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);
    canvas.drawCircle(Offset(cx, cy), w * 0.25, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.1)));
    canvas.restore();
  }

  void _drawWait(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 时钟（等待）
    final clockP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(cx, cy), w * 0.25, clockP);
    // 钟面
    canvas.drawCircle(Offset(cx, cy), w * 0.22, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.2)));
    // 刻度
    for (int i = 0; i < 12; i++) {
      final angle = i * pi / 6 - pi / 2;
      final len = i % 3 == 0 ? w * 0.04 : w * 0.02;
      canvas.drawLine(
        Offset(cx + cos(angle) * w * 0.19, cy + sin(angle) * w * 0.19),
        Offset(cx + cos(angle) * (w * 0.19 + len), cy + sin(angle) * (w * 0.19 + len)),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = i % 3 == 0 ? 2.5 : 1.5..style = PaintingStyle.stroke,
      );
    }
    // 指针（走动）
    final minuteAngle = t * pi * 2;
    final hourAngle = t * pi * 2 / 12;
    final handP = Paint()..color = _dc(illustration.accent)..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy), Offset(cx + cos(hourAngle - pi/2) * w * 0.1, cy + sin(hourAngle - pi/2) * w * 0.1), handP);
    final handP2 = Paint()..color = _dc(illustration.accent)..strokeWidth = 1.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy), Offset(cx + cos(minuteAngle - pi/2) * w * 0.16, cy + sin(minuteAngle - pi/2) * w * 0.16), handP2);
    // 中心点
    canvas.drawCircle(Offset(cx, cy), w * 0.02, Paint()..color = _dc(illustration.bg));
  }

  void _drawCall(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 电话听筒
    final phoneP = Paint()..color = _dc(illustration.accent);
    // 听筒主体
    final bodyPath = Path()
      ..moveTo(cx - w * 0.2, cy - h * 0.05)
      ..cubicTo(cx - w * 0.25, cy - h * 0.12, cx - w * 0.15, cy - h * 0.15, cx - w * 0.08, cy - h * 0.1)
      ..lineTo(cx - w * 0.08, cy + h * 0.1)
      ..cubicTo(cx - w * 0.15, cy + h * 0.15, cx - w * 0.25, cy + h * 0.12, cx - w * 0.2, cy + h * 0.05)
      ..close();
    // 话筒
    final micPath = Path()
      ..moveTo(cx + w * 0.2, cy - h * 0.05)
      ..cubicTo(cx + w * 0.25, cy - h * 0.12, cx + w * 0.15, cy - h * 0.15, cx + w * 0.08, cy - h * 0.1)
      ..lineTo(cx + w * 0.08, cy + h * 0.1)
      ..cubicTo(cx + w * 0.15, cy + h * 0.15, cx + w * 0.25, cy + h * 0.12, cx + w * 0.2, cy + h * 0.05)
      ..close();
    canvas.drawPath(bodyPath, phoneP);
    canvas.drawPath(micPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // 连线
    final cordP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    final cordPath = Path()
      ..moveTo(cx - w * 0.08, cy - h * 0.1)
      ..cubicTo(cx, cy - h * 0.18, cx, cy + h * 0.18, cx + w * 0.08, cy + h * 0.1);
    canvas.drawPath(cordPath, cordP);
    // 信号波
    for (int i = 1; i <= 3; i++) {
      final waveP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 2..style = PaintingStyle.stroke;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx + w * 0.2, cy - h * 0.05), width: w * 0.12 * i, height: h * 0.12 * i),
        -pi * 0.4, pi * 0.8, false, waveP,
      );
    }
  }

  void _drawAsk(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // 问号气泡
    final bubbleP = Paint()..color = _dc(illustration.accent);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.5, height: h * 0.3), Radius.circular(w * 0.1)),
      bubbleP,
    );
    // 气泡尾巴
    final tailPath = Path()
      ..moveTo(cx + w * 0.05, cy + h * 0.15)
      ..lineTo(cx + w * 0.15, cy + h * 0.25)
      ..lineTo(cx - w * 0.02, cy + h * 0.15)
      ..close();
    canvas.drawPath(tailPath, bubbleP);
    // 问号
    final qP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = w * 0.04..strokeCap = StrokeCap.round;
    final qPath = Path()
      ..moveTo(cx - w * 0.04, cy + h * 0.02)
      ..cubicTo(cx - w * 0.04, cy - h * 0.06, cx + w * 0.04, cy - h * 0.08, cx + w * 0.04, cy - h * 0.02)
      ..cubicTo(cx + w * 0.04, cy, cx - w * 0.01, cy, cx, cy + h * 0.03);
    canvas.drawPath(qPath, qP);
    canvas.drawCircle(Offset(cx, cy + h * 0.08), w * 0.02, Paint()..color = _dc(illustration.bg));
  }

  void _drawAnswer(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // 回复气泡（和问号气泡对应）
    final bubbleP = Paint()..color = _dc(illustration.accent);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.5, height: h * 0.3), Radius.circular(w * 0.1)),
      bubbleP,
    );
    // 气泡尾巴（左边，像回复）
    final tailPath = Path()
      ..moveTo(cx - w * 0.05, cy + h * 0.15)
      ..lineTo(cx - w * 0.15, cy + h * 0.25)
      ..lineTo(cx + w * 0.02, cy + h * 0.15)
      ..close();
    canvas.drawPath(tailPath, bubbleP);
    // 对勾（答案正确）
    final checkP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = w * 0.04..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final checkPath = Path()
      ..moveTo(cx - w * 0.08, cy)
      ..lineTo(cx - w * 0.02, cy + h * 0.06)
      ..lineTo(cx + w * 0.1, cy - h * 0.06);
    canvas.drawPath(checkPath, checkP);
  }

  void _drawGrow(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 植物生长
    final stemP = Paint()..color = _dc(illustration.accent)..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    // 花盆
    final potP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    final potPath = Path()
      ..moveTo(cx - w * 0.12, cy + h * 0.1)
      ..lineTo(cx - w * 0.08, cy + h * 0.22)
      ..lineTo(cx + w * 0.08, cy + h * 0.22)
      ..lineTo(cx + w * 0.12, cy + h * 0.1)
      ..close();
    canvas.drawPath(potPath, potP);
    // 茎
    final growH = h * 0.15 + sin(t * pi * 2) * h * 0.03;
    canvas.drawLine(Offset(cx, cy + h * 0.1), Offset(cx, cy + h * 0.1 - growH), stemP);
    // 叶子
    final leafP = Paint()..color = _dc(illustration.accent);
    final leafSize = w * 0.06;
    // 左叶
    canvas.save();
    canvas.translate(cx - w * 0.02, cy + h * 0.1 - growH * 0.5);
    canvas.rotate(-0.5);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: leafSize * 2, height: leafSize), leafP);
    canvas.restore();
    // 右叶
    canvas.save();
    canvas.translate(cx + w * 0.02, cy + h * 0.1 - growH * 0.7);
    canvas.rotate(0.5);
    canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: leafSize * 2, height: leafSize), leafP);
    canvas.restore();
    // 花
    canvas.drawCircle(Offset(cx, cy + h * 0.1 - growH), w * 0.05, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
  }

  void _drawChange(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 循环箭头（变换）
    final arrowP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.04..strokeCap = StrokeCap.round;
    // 上弧
    final topArc = Rect.fromCenter(center: Offset(cx, cy), width: w * 0.4, height: h * 0.3);
    canvas.drawArc(topArc, -pi * 0.7, pi * 1.2, false, arrowP);
    // 下弧
    canvas.drawArc(topArc, pi * 0.3, pi * 1.2, false, arrowP);
    // 箭头头部
    final headP = Paint()..color = _dc(illustration.accent);
    // 右上箭头
    final a1x = cx + w * 0.18, a1y = cy - h * 0.08;
    final a1Path = Path()
      ..moveTo(a1x + w * 0.06, a1y)
      ..lineTo(a1x, a1y - h * 0.06)
      ..lineTo(a1x, a1y + h * 0.06)
      ..close();
    canvas.drawPath(a1Path, headP);
    // 左下箭头
    final a2x = cx - w * 0.18, a2y = cy + h * 0.08;
    final a2Path = Path()
      ..moveTo(a2x - w * 0.06, a2y)
      ..lineTo(a2x, a2y + h * 0.06)
      ..lineTo(a2x, a2y - h * 0.06)
      ..close();
    canvas.drawPath(a2Path, headP);
    // 中心闪烁
    final sparkle = (sin(t * pi * 2) + 1) / 2;
    _drawStarShape(canvas, cx, cy, w * 0.06 * sparkle, w * 0.03 * sparkle, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
  }

  void _drawAfraid(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // 恐惧的脸
    final faceP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(cx, cy), w * 0.2, faceP);
    // 惊恐的眼睛（睁大）
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - w * 0.08, cy - h * 0.04), width: w * 0.08, height: h * 0.06), Paint()..color = _dc(illustration.bg));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.08, cy - h * 0.04), width: w * 0.08, height: h * 0.06), Paint()..color = _dc(illustration.bg));
    // 小瞳孔
    canvas.drawCircle(Offset(cx - w * 0.08, cy - h * 0.04), w * 0.02, faceP);
    canvas.drawCircle(Offset(cx + w * 0.08, cy - h * 0.04), w * 0.02, faceP);
    // 张开的嘴（O形）
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.08), width: w * 0.1, height: h * 0.08), Paint()..color = _dc(illustration.bg));
    // 颤抖动画
    final shake = sin(t * pi * 8) * w * 0.01;
    canvas.save();
    canvas.translate(shake, 0);
    canvas.drawCircle(Offset(cx, cy), w * 0.2, Paint()..color = Colors.transparent);
    canvas.restore();
  }

  void _drawBrave(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 盾牌 + 剑（勇敢）
    final shieldP = Paint()..color = _dc(illustration.accent);
    // 盾牌
    final shieldPath = Path()
      ..moveTo(cx - w * 0.18, cy - h * 0.2)
      ..lineTo(cx + w * 0.18, cy - h * 0.2)
      ..lineTo(cx + w * 0.18, cy + h * 0.05)
      ..quadraticBezierTo(cx + w * 0.18, cy + h * 0.2, cx, cy + h * 0.25)
      ..quadraticBezierTo(cx - w * 0.18, cy + h * 0.2, cx - w * 0.18, cy + h * 0.05)
      ..close();
    canvas.drawPath(shieldPath, shieldP);
    // 盾牌内星
    _drawStarShape(canvas, cx, cy - h * 0.02, w * 0.1, w * 0.05, 5, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    // 剑
    final swordP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8));
    canvas.save();
    canvas.translate(cx + w * 0.12, cy - h * 0.1);
    canvas.rotate(pi * 0.25);
    canvas.drawRect(Rect.fromCenter(center: Offset(0, -h * 0.08), width: w * 0.03, height: h * 0.22), swordP);
    // 剑柄
    canvas.drawRect(Rect.fromCenter(center: Offset(0, h * 0.04), width: w * 0.08, height: h * 0.02), swordP);
    canvas.drawRect(Rect.fromCenter(center: Offset(0, h * 0.07), width: w * 0.025, height: h * 0.05), swordP);
    canvas.restore();
  }

  void _drawCareful(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 放大镜（仔细查看）
    final glassP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.03;
    // 镜片
    canvas.drawCircle(Offset(cx - w * 0.05, cy - h * 0.05), w * 0.16, glassP);
    // 镜柄
    final handleP = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.03..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx + w * 0.08, cy + h * 0.08), Offset(cx + w * 0.22, cy + h * 0.22), handleP);
    // 镜片内细节（放大效果）
    canvas.drawCircle(Offset(cx - w * 0.05, cy - h * 0.05), w * 0.14, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.1)));
    // 放大的文字
    final textP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawLine(Offset(cx - w * 0.1, cy - h * 0.08), Offset(cx + w * 0.0, cy - h * 0.08), textP);
    canvas.drawLine(Offset(cx - w * 0.08, cy - h * 0.03), Offset(cx + w * 0.02, cy - h * 0.03), textP);
    canvas.drawLine(Offset(cx - w * 0.06, cy + h * 0.02), Offset(cx - w * 0.01, cy + h * 0.02), textP);
  }

  void _drawDangerous(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 警告三角形
    final warnP = Paint()..color = _dc(illustration.accent);
    // 三角形外框
    final triPath = Path()
      ..moveTo(cx, cy - h * 0.25)
      ..lineTo(cx + w * 0.25, cy + h * 0.18)
      ..lineTo(cx - w * 0.25, cy + h * 0.18)
      ..close();
    canvas.drawPath(triPath, warnP);
    // 内部（空心）
    canvas.drawPath(
      Path()
        ..moveTo(cx, cy - h * 0.18)
        ..lineTo(cx + w * 0.18, cy + h * 0.13)
        ..lineTo(cx - w * 0.18, cy + h * 0.13)
        ..close(),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)),
    );
    // 感叹号
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - h * 0.02), width: w * 0.04, height: h * 0.12), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.accent),
    );
    canvas.drawCircle(Offset(cx, cy + h * 0.1), w * 0.025, Paint()..color = _dc(illustration.accent));
    // 警告脉冲
    final pulseR = w * 0.3 + sin(t * pi * 2) * w * 0.03;
    canvas.drawCircle(Offset(cx, cy), pulseR, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.08)));
  }

  void _drawDifferent(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 两个不同形状对比
    final p1 = Paint()..color = _dc(illustration.accent);
    final p2 = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    // 左边：圆形
    canvas.drawCircle(Offset(cx - w * 0.15, cy - h * 0.05), w * 0.12, p1);
    // 右边：方形
    canvas.drawRect(Rect.fromCenter(center: Offset(cx + w * 0.15, cy - h * 0.05), width: w * 0.22, height: h * 0.18), p2);
    // 不等号
    final neqP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.03..strokeCap = StrokeCap.round;
    // ≠ 符号
    canvas.drawLine(Offset(cx - w * 0.12, cy + h * 0.15), Offset(cx + w * 0.12, cy + h * 0.15), neqP);
    canvas.drawLine(Offset(cx - w * 0.08, cy + h * 0.11), Offset(cx + w * 0.08, cy + h * 0.19), Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.025..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
  }

  void _drawDifficult(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 迷宫（困难）
    final mazeP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.025..strokeCap = StrokeCap.round;
    // 迷宫墙
    final mazePath = Path()
      ..moveTo(cx - w * 0.2, cy - h * 0.2)
      ..lineTo(cx + w * 0.1, cy - h * 0.2)
      ..lineTo(cx + w * 0.1, cy - h * 0.1)
      ..lineTo(cx - w * 0.1, cy - h * 0.1)
      ..lineTo(cx - w * 0.1, cy)
      ..lineTo(cx + w * 0.15, cy)
      ..lineTo(cx + w * 0.15, cy + h * 0.1)
      ..lineTo(cx - w * 0.05, cy + h * 0.1)
      ..lineTo(cx - w * 0.05, cy + h * 0.2)
      ..lineTo(cx + w * 0.2, cy + h * 0.2);
    canvas.drawPath(mazePath, mazeP);
    // 困惑的人
    final personP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    canvas.drawCircle(Offset(cx - w * 0.2, cy - h * 0.2), w * 0.04, personP);
    // 问号
    final qP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4 + sin(t * pi * 2) * 0.3));
    canvas.drawCircle(Offset(cx - w * 0.12, cy - h * 0.25), w * 0.03, qP);
  }

  void _drawEasy(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 羽毛（轻而易举）
    final featherP = Paint()..color = _dc(illustration.accent);
    // 羽毛主杆
    canvas.drawLine(
      Offset(cx - w * 0.2, cy + h * 0.15),
      Offset(cx + w * 0.2, cy - h * 0.15),
      Paint()..color = _dc(illustration.accent)..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round,
    );
    // 羽毛左边毛
    for (int i = 0; i < 6; i++) {
      final t2 = i / 5;
      final px = cx - w * 0.2 + t2 * w * 0.35;
      final py = cy + h * 0.15 - t2 * h * 0.26;
      final curve = sin(t2 * pi) * w * 0.12;
      final leafPath = Path()
        ..moveTo(px, py)
        ..quadraticBezierTo(px - curve * 0.6, py - h * 0.03, px - curve, py - h * 0.01)
        ..quadraticBezierTo(px - curve * 0.6, py + h * 0.02, px, py);
      canvas.drawPath(leafPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3 + t2 * 0.3)));
    }
    // 右边毛
    for (int i = 0; i < 6; i++) {
      final t2 = i / 5;
      final px = cx - w * 0.2 + t2 * w * 0.35;
      final py = cy + h * 0.15 - t2 * h * 0.26;
      final curve = sin(t2 * pi) * w * 0.12;
      final leafPath = Path()
        ..moveTo(px, py)
        ..quadraticBezierTo(px + curve * 0.6, py - h * 0.03, px + curve, py - h * 0.01)
        ..quadraticBezierTo(px + curve * 0.6, py + h * 0.02, px, py);
      canvas.drawPath(leafPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3 + t2 * 0.3)));
    }
    // 飘浮动画
    final floatY = sin(t * pi * 2) * h * 0.02;
    canvas.save();
    canvas.translate(0, floatY);
    canvas.restore();
  }

  void _drawExcited(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // 兴奋的脸
    final faceP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(cx, cy), w * 0.2, faceP);
    // 星星眼睛
    _drawStarShape(canvas, cx - w * 0.08, cy - h * 0.03, w * 0.05, w * 0.025, 5, Paint()..color = _dc(illustration.bg));
    _drawStarShape(canvas, cx + w * 0.08, cy - h * 0.03, w * 0.05, w * 0.025, 5, Paint()..color = _dc(illustration.bg));
    // 大笑嘴
    final mouthPath = Path()
      ..moveTo(cx - w * 0.1, cy + h * 0.06)
      ..quadraticBezierTo(cx, cy + h * 0.16, cx + w * 0.1, cy + h * 0.06)
      ..close();
    canvas.drawPath(mouthPath, Paint()..color = _dc(illustration.bg));
    // 兴奋的火花
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3 + t * pi * 2;
      final r = w * 0.28 + sin(t * pi * 4 + i) * w * 0.03;
      final sx = cx + cos(angle) * r;
      final sy = cy + sin(angle) * r;
      _drawStarShape(canvas, sx, sy, w * 0.03, w * 0.015, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4 + sin(t * pi * 2 + i) * 0.3)));
    }
  }

  void _drawFamous(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 明星（著名的）
    final starP = Paint()..color = _dc(illustration.accent);
    // 大星星
    _drawStarShape(canvas, cx, cy, w * 0.25, w * 0.12, 5, starP);
    // 内星
    _drawStarShape(canvas, cx, cy, w * 0.15, w * 0.075, 5, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    // 光芒
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final rayP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 2..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(cx + cos(angle) * w * 0.28, cy + sin(angle) * w * 0.28),
        Offset(cx + cos(angle) * w * 0.38, cy + sin(angle) * w * 0.38),
        rayP,
      );
    }
    // 闪烁动画
    final sparkle = (sin(t * pi * 2) + 1) / 2;
    for (int i = 0; i < 4; i++) {
      final angle = i * pi / 2 + pi / 4;
      _drawStarShape(canvas, cx + cos(angle) * w * 0.35, cy + sin(angle) * w * 0.35, w * 0.03 * sparkle, w * 0.015 * sparkle, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5 * sparkle)));
    }
  }

  void _drawFree(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // 飞翔的鸟（自由）
    final birdP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.02..strokeCap = StrokeCap.round;
    // 主鸟
    final wingY = sin(t * pi * 2) * h * 0.05;
    final birdPath = Path()
      ..moveTo(cx - w * 0.2, cy + wingY * 0.5)
      ..quadraticBezierTo(cx - w * 0.05, cy - h * 0.08 + wingY, cx, cy)
      ..quadraticBezierTo(cx + w * 0.05, cy - h * 0.08 + wingY, cx + w * 0.2, cy + wingY * 0.5);
    canvas.drawPath(birdPath, birdP);
    // 鸟身体
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.06, height: h * 0.03), Paint()..color = _dc(illustration.accent));
    // 第二只鸟（远处）
    final bird2P = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    final b2Path = Path()
      ..moveTo(cx - w * 0.3, cy - h * 0.12 + wingY * 0.3)
      ..quadraticBezierTo(cx - w * 0.22, cy - h * 0.17 + wingY * 0.3, cx - w * 0.18, cy - h * 0.12 + wingY * 0.3)
      ..quadraticBezierTo(cx - w * 0.22, cy - h * 0.17 + wingY * 0.3, cx - w * 0.14, cy - h * 0.12 + wingY * 0.3);
    canvas.drawPath(b2Path, bird2P);
    // 第三只
    final b3Path = Path()
      ..moveTo(cx + w * 0.15, cy - h * 0.15 + wingY * 0.2)
      ..quadraticBezierTo(cx + w * 0.2, cy - h * 0.19 + wingY * 0.2, cx + w * 0.23, cy - h * 0.15 + wingY * 0.2)
      ..quadraticBezierTo(cx + w * 0.27, cy - h * 0.19 + wingY * 0.2, cx + w * 0.3, cy - h * 0.15 + wingY * 0.2);
    canvas.drawPath(b3Path, bird2P);
  }

  void _drawGlad(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // 开心微笑的脸
    final faceP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(cx, cy), w * 0.2, faceP);
    // 眼睛（弯弯的笑眼）
    final eyeP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    final leftEye = Path()..moveTo(cx - w * 0.12, cy - h * 0.02)..quadraticBezierTo(cx - w * 0.08, cy - h * 0.06, cx - w * 0.04, cy - h * 0.02);
    final rightEye = Path()..moveTo(cx + w * 0.04, cy - h * 0.02)..quadraticBezierTo(cx + w * 0.08, cy - h * 0.06, cx + w * 0.12, cy - h * 0.02);
    canvas.drawPath(leftEye, eyeP);
    canvas.drawPath(rightEye, eyeP);
    // 微笑
    final smilePath = Path()
      ..moveTo(cx - w * 0.1, cy + h * 0.04)
      ..quadraticBezierTo(cx, cy + h * 0.14, cx + w * 0.1, cy + h * 0.04);
    canvas.drawPath(smilePath, Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    // 腮红
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - w * 0.14, cy + h * 0.04), width: w * 0.06, height: h * 0.03), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.14, cy + h * 0.04), width: w * 0.06, height: h * 0.03), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 绘图工具方法
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawRoundedRectAt(Canvas canvas, double x, double y, double w, double h, Paint paint) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, y, w, h),
      Radius.circular(w * 0.15),
    );
    canvas.drawRRect(rrect, paint);
  }

  void _drawLine(Canvas canvas, double x1, double y1, double x2, double y2, Paint paint) {
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
  }

  void _drawHeartAt(Canvas canvas, double cx, double cy, double hw, double hh, Paint paint) {
    final path = Path();
    path.moveTo(cx, cy + hh * 0.6);
    path.cubicTo(cx - hw * 1.2, cy - hh * 0.2, cx - hw * 0.5, cy - hh, cx, cy - hh * 0.3);
    path.cubicTo(cx + hw * 0.5, cy - hh, cx + hw * 1.2, cy - hh * 0.2, cx, cy + hh * 0.6);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawGearShape(Canvas canvas, double cx, double cy, double r, int teeth, Paint paint) {
    final path = Path();
    for (int i = 0; i < teeth; i++) {
      final a1 = i * 2 * pi / teeth;
      final a2 = a1 + pi / teeth * 0.3;
      final a3 = a1 + pi / teeth * 0.7;
      final a4 = a1 + pi / teeth;
      final innerR = r * 0.75;
      if (i == 0) path.moveTo(cx + cos(a1) * innerR, cy + sin(a1) * innerR);
      else path.lineTo(cx + cos(a1) * innerR, cy + sin(a1) * innerR);
      path.lineTo(cx + cos(a2) * r, cy + sin(a2) * r);
      path.lineTo(cx + cos(a3) * r, cy + sin(a3) * r);
      path.lineTo(cx + cos(a4) * innerR, cy + sin(a4) * innerR);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawText(Canvas canvas, String text, double cx, double cy, double fontSize, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize, color: color, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, cy - tp.height / 2));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 第四批：常用动词/形容词 (act ~ disappear)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawAct(Canvas canvas, Size size) {
    // 舞台聚光灯 + 人物剪影
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 聚光灯光束
    final lightPath = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w * 0.25, h * 0.85)
      ..lineTo(w * 0.75, h * 0.85)
      ..close();
    canvas.drawPath(lightPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    // 人物（站姿）
    canvas.drawCircle(Offset(w * 0.5, h * 0.32), w * 0.07, p);
    _drawRoundedRectAt(canvas, w * 0.42, h * 0.4, w * 0.16, h * 0.22, p);
    // 手臂展开
    _drawLine(canvas, w * 0.42, h * 0.45, w * 0.25, h * 0.38, p..strokeWidth = w * 0.03);
    _drawLine(canvas, w * 0.58, h * 0.45, w * 0.75, h * 0.38, p..strokeWidth = w * 0.03);
    // 腿
    _drawLine(canvas, w * 0.46, h * 0.62, w * 0.38, h * 0.8, p..strokeWidth = w * 0.03);
    _drawLine(canvas, w * 0.54, h * 0.62, w * 0.62, h * 0.8, p..strokeWidth = w * 0.03);
    // 舞台地板
    _drawLine(canvas, w * 0.15, h * 0.85, w * 0.85, h * 0.85, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = 2);
  }

  void _drawAdd(Canvas canvas, Size size) {
    // 加号 + 堆叠方块
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 下方方块
    _drawRoundedRectAt(canvas, w * 0.25, h * 0.5, w * 0.22, h * 0.22, p);
    // 加号
    final plusP = Paint()..color = Colors.white..strokeWidth = w * 0.04..strokeCap = StrokeCap.round;
    final cx = w * 0.65, cy = h * 0.38;
    _drawLine(canvas, cx - w * 0.08, cy, cx + w * 0.08, cy, plusP);
    _drawLine(canvas, cx, cy - h * 0.08, cx, cy + h * 0.08, plusP);
    // 上方方块（虚影）
    _drawRoundedRectAt(canvas, w * 0.55, h * 0.22, w * 0.2, h * 0.2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // 箭头
    final arrowP = Paint()..color = _dc(illustration.bg)..strokeWidth = w * 0.025..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.47, h * 0.55, w * 0.55, h * 0.38, arrowP);
  }

  void _drawAgree(Canvas canvas, Size size) {
    // 两只手握手 + 对勾
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.04..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    // 握手
    final handPath = Path()
      ..moveTo(w * 0.2, h * 0.5)
      ..lineTo(w * 0.35, h * 0.42)
      ..lineTo(w * 0.5, h * 0.48)
      ..lineTo(w * 0.65, h * 0.42)
      ..lineTo(w * 0.8, h * 0.5);
    canvas.drawPath(handPath, p);
    // 手臂
    _drawLine(canvas, w * 0.2, h * 0.5, w * 0.2, h * 0.3, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.04..strokeCap = StrokeCap.round);
    _drawLine(canvas, w * 0.8, h * 0.5, w * 0.8, h * 0.3, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.04..strokeCap = StrokeCap.round);
    // 对勾
    final checkP = Paint()..color = Colors.green..strokeWidth = w * 0.04..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final checkPath = Path()
      ..moveTo(w * 0.35, h * 0.72)
      ..lineTo(w * 0.48, h * 0.82)
      ..lineTo(w * 0.7, h * 0.62);
    canvas.drawPath(checkPath, checkP);
  }

  void _drawAlone(Canvas canvas, Size size) {
    // 单个小人站在空旷空间
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 大片空白中的小人
    canvas.drawCircle(Offset(w * 0.5, h * 0.3), w * 0.06, p);
    _drawRoundedRectAt(canvas, w * 0.44, h * 0.37, w * 0.12, h * 0.18, p);
    _drawLine(canvas, w * 0.47, h * 0.55, w * 0.42, h * 0.72, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.025..strokeCap = StrokeCap.round);
    _drawLine(canvas, w * 0.53, h * 0.55, w * 0.58, h * 0.72, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.025..strokeCap = StrokeCap.round);
    // 地面线
    _drawLine(canvas, w * 0.15, h * 0.78, w * 0.85, h * 0.78, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..strokeWidth = 1);
    // 虚线圈（孤独感）
    final dashP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.15))..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.28, dashP);
  }

  void _drawAmazing(Canvas canvas, Size size) {
    // 星星爆发 + 惊叹
    final w = size.width, h = size.height;
    // 中心大星
    _drawStarShape(canvas, w * 0.5, h * 0.45, w * 0.18, w * 0.08, 5, Paint()..color = _dc(illustration.accent));
    // 周围小星
    _drawStarShape(canvas, w * 0.22, h * 0.25, w * 0.06, w * 0.025, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    _drawStarShape(canvas, w * 0.78, h * 0.3, w * 0.07, w * 0.03, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    _drawStarShape(canvas, w * 0.3, h * 0.7, w * 0.05, w * 0.02, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    _drawStarShape(canvas, w * 0.72, h * 0.68, w * 0.06, w * 0.025, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // 闪光线
    final sparkP = Paint()..color = Colors.white.withOpacity(0.6)..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      final r1 = w * 0.22, r2 = w * 0.3;
      _drawLine(canvas, w * 0.5 + cos(angle) * r1, h * 0.45 + sin(angle) * r1, w * 0.5 + cos(angle) * r2, h * 0.45 + sin(angle) * r2, sparkP);
    }
  }

  void _drawAppear(Canvas canvas, Size size) {
    // 魔法帽 + 逐渐出现的星星
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 帽子
    final hatPath = Path()
      ..moveTo(w * 0.3, h * 0.65)
      ..lineTo(w * 0.5, h * 0.2)
      ..lineTo(w * 0.7, h * 0.65)
      ..close();
    canvas.drawPath(hatPath, p);
    // 帽檐
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.66), width: w * 0.5, height: h * 0.08), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    // 出现的星星（渐隐）
    _drawStarShape(canvas, w * 0.35, h * 0.75, w * 0.06, w * 0.025, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    _drawStarShape(canvas, w * 0.55, h * 0.82, w * 0.04, w * 0.015, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    _drawStarShape(canvas, w * 0.65, h * 0.72, w * 0.05, w * 0.02, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // 问号
    _drawText(canvas, '?', w * 0.5, h * 0.42, w * 0.1, Colors.white.withOpacity(0.7));
  }

  void _drawAwake(Canvas canvas, Size size) {
    // 睁开的眼睛 + 太阳
    final w = size.width, h = size.height;
    // 太阳
    canvas.drawCircle(Offset(w * 0.72, h * 0.25), w * 0.1, Paint()..color = _dc(illustration.accent));
    // 阳光
    final rayP = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.02..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      _drawLine(canvas, w * 0.72 + cos(angle) * w * 0.13, h * 0.25 + sin(angle) * w * 0.13, w * 0.72 + cos(angle) * w * 0.18, h * 0.25 + sin(angle) * w * 0.18, rayP);
    }
    // 大眼睛（睁开）
    final eyeP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.03;
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.4, h * 0.5), width: w * 0.3, height: h * 0.18), eyeP);
    // 瞳孔
    canvas.drawCircle(Offset(w * 0.4, h * 0.5), w * 0.05, Paint()..color = _dc(illustration.accent));
    // 睫毛
    final lashP = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.015..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.27, h * 0.44, w * 0.22, h * 0.38, lashP);
    _drawLine(canvas, w * 0.35, h * 0.42, w * 0.33, h * 0.35, lashP);
    _drawLine(canvas, w * 0.45, h * 0.42, w * 0.47, h * 0.35, lashP);
    _drawLine(canvas, w * 0.53, h * 0.44, w * 0.58, h * 0.38, lashP);
  }

  void _drawBad(Canvas canvas, Size size) {
    // 生气的脸 + 眉毛
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 脸
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.25, p);
    // 眼睛
    canvas.drawCircle(Offset(w * 0.4, h * 0.4), w * 0.03, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.6, h * 0.4), w * 0.03, Paint()..color = Colors.white);
    // 生气眉毛
    final browP = Paint()..color = Colors.white..strokeWidth = w * 0.025..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.33, h * 0.33, w * 0.45, h * 0.36, browP);
    _drawLine(canvas, w * 0.67, h * 0.33, w * 0.55, h * 0.36, browP);
    // 皱嘴
    final mouthP = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = w * 0.02..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.5, h * 0.58), width: w * 0.15, height: h * 0.08), pi * 0.1, pi * 0.8, false, mouthP);
  }

  void _drawBelieve(Canvas canvas, Size size) {
    // 心形 + 星星 = 信仰
    final w = size.width, h = size.height;
    // 心形
    _drawHeartAt(canvas, w * 0.35, h * 0.4, w * 0.2, h * 0.22, Paint()..color = _dc(illustration.accent));
    // 星星
    _drawStarShape(canvas, w * 0.68, h * 0.35, w * 0.1, w * 0.04, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // 连接线（信念的桥梁）
    final bridgeP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = w * 0.015..style = PaintingStyle.stroke;
    final bridgePath = Path()
      ..moveTo(w * 0.45, h * 0.35)
      ..quadraticBezierTo(w * 0.55, h * 0.2, w * 0.6, h * 0.33);
    canvas.drawPath(bridgePath, bridgeP);
    // 光环
    final haloP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15))..style = PaintingStyle.stroke..strokeWidth = w * 0.015;
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.32, haloP);
    // 文字"相信"
    _drawText(canvas, '✦', w * 0.5, h * 0.72, w * 0.06, illustration.accent.withOpacity(_minOp(0.5)));
  }

  void _drawBest(Canvas canvas, Size size) {
    // 金牌 + 皇冠
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 奖牌圆
    canvas.drawCircle(Offset(w * 0.5, h * 0.52), w * 0.2, p);
    // 1号
    _drawText(canvas, '1', w * 0.5, h * 0.52, w * 0.18, Colors.white);
    // 绶带
    final ribbonP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6))..strokeWidth = w * 0.04..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.35, h * 0.38, w * 0.3, h * 0.15, ribbonP);
    _drawLine(canvas, w * 0.65, h * 0.38, w * 0.7, h * 0.15, ribbonP);
    // 皇冠
    _drawStarShape(canvas, w * 0.5, h * 0.15, w * 0.08, w * 0.03, 5, Paint()..color = Colors.amber);
  }

  void _drawBetter(Canvas canvas, Size size) {
    // 向上的箭头 + 对比
    final w = size.width, h = size.height;
    // 低的方块
    _drawRoundedRectAt(canvas, w * 0.15, h * 0.55, w * 0.2, h * 0.25, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    // 高的方块
    _drawRoundedRectAt(canvas, w * 0.5, h * 0.35, w * 0.2, h * 0.45, Paint()..color = _dc(illustration.accent));
    // 上升箭头
    final arrowP = Paint()..color = Colors.white..strokeWidth = w * 0.03..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final arrowPath = Path()
      ..moveTo(w * 0.38, h * 0.48)
      ..lineTo(w * 0.5, h * 0.3)
      ..lineTo(w * 0.62, h * 0.48);
    canvas.drawPath(arrowPath, arrowP);
    _drawLine(canvas, w * 0.5, h * 0.3, w * 0.5, h * 0.2, arrowP);
  }

  void _drawBlack(Canvas canvas, Size size) {
    // 黑色月亮 + 暗色调
    final w = size.width, h = size.height;
    // 深色背景圆
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.28, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    // 月牙
    final moonP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.2, moonP);
    canvas.drawCircle(Offset(w * 0.58, h * 0.42), w * 0.17, Paint()..color = Color.lerp(illustration.accent, Colors.black, 0.7)!);
    // 小星星
    _drawStarShape(canvas, w * 0.25, h * 0.25, w * 0.03, w * 0.012, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    _drawStarShape(canvas, w * 0.75, h * 0.2, w * 0.04, w * 0.016, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    _drawStarShape(canvas, w * 0.7, h * 0.7, w * 0.03, w * 0.012, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
  }

  void _drawBlue(Canvas canvas, Size size) {
    // 水滴 + 波浪
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 大水滴
    final dropPath = Path();
    dropPath.moveTo(w * 0.5, h * 0.15);
    dropPath.quadraticBezierTo(w * 0.3, h * 0.45, w * 0.5, h * 0.65);
    dropPath.quadraticBezierTo(w * 0.7, h * 0.45, w * 0.5, h * 0.15);
    canvas.drawPath(dropPath, p);
    // 高光
    canvas.drawCircle(Offset(w * 0.44, h * 0.42), w * 0.04, Paint()..color = Colors.white.withOpacity(0.4));
    // 波浪底
    final waveP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..style = PaintingStyle.stroke..strokeWidth = w * 0.02..strokeCap = StrokeCap.round;
    final wavePath = Path();
    wavePath.moveTo(w * 0.1, h * 0.82);
    for (double x = 0; x <= 1; x += 0.05) {
      wavePath.lineTo(w * x, h * (0.82 + sin(x * pi * 3) * 0.03));
    }
    canvas.drawPath(wavePath, waveP);
  }

  void _drawBored(Canvas canvas, Size size) {
    // 无聊的脸（托腮）
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 脸
    canvas.drawCircle(Offset(w * 0.5, h * 0.38), w * 0.18, p);
    // 无聊的眼睛（半闭）
    final eyeP = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = w * 0.02;
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.42, h * 0.36), width: w * 0.08, height: h * 0.03), 0, pi, false, eyeP);
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.58, h * 0.36), width: w * 0.08, height: h * 0.03), 0, pi, false, eyeP);
    // 嘴（直的）
    _drawLine(canvas, w * 0.44, h * 0.46, w * 0.56, h * 0.46, Paint()..color = Colors.white..strokeWidth = w * 0.015..strokeCap = StrokeCap.round);
    // 手托腮
    final handP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = w * 0.03..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.32, h * 0.5, w * 0.25, h * 0.65, handP);
    _drawLine(canvas, w * 0.68, h * 0.5, w * 0.75, h * 0.65, handP);
    // 省略号 ...
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(w * (0.4 + i * 0.1), h * 0.72), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    }
  }

  void _drawBoring(Canvas canvas, Size size) {
    _drawBored(canvas, size); // 同 bored
  }

  void _drawBorrow(Canvas canvas, Size size) {
    // 伸出手（借）
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.035..strokeCap = StrokeCap.round;
    // 伸出的手
    _drawLine(canvas, w * 0.2, h * 0.55, w * 0.5, h * 0.45, p);
    // 手掌
    canvas.drawCircle(Offset(w * 0.52, h * 0.44), w * 0.05, Paint()..color = _dc(illustration.accent));
    // 箭头指向手
    final arrowP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = w * 0.02..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.75, h * 0.35, w * 0.58, h * 0.42, arrowP);
    // 箭头头
    final headP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = w * 0.02..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.62, h * 0.37, w * 0.58, h * 0.42, headP);
    _drawLine(canvas, w * 0.62, h * 0.45, w * 0.58, h * 0.42, headP);
    // 物品（书）
    _drawRoundedRectAt(canvas, w * 0.7, h * 0.25, w * 0.15, h * 0.12, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
  }

  void _drawBreak(Canvas canvas, Size size) {
    // 破碎的碎片
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 碎片
    final shardPath1 = Path()
      ..moveTo(w * 0.3, h * 0.3)
      ..lineTo(w * 0.45, h * 0.35)
      ..lineTo(w * 0.38, h * 0.5)
      ..close();
    canvas.drawPath(shardPath1, p);
    final shardPath2 = Path()
      ..moveTo(w * 0.55, h * 0.28)
      ..lineTo(w * 0.72, h * 0.35)
      ..lineTo(w * 0.65, h * 0.52)
      ..close();
    canvas.drawPath(shardPath2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    final shardPath3 = Path()
      ..moveTo(w * 0.42, h * 0.52)
      ..lineTo(w * 0.58, h * 0.5)
      ..lineTo(w * 0.52, h * 0.7)
      ..close();
    canvas.drawPath(shardPath3, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // 裂缝线
    final crackP = Paint()..color = Colors.white..strokeWidth = w * 0.015..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.35, h * 0.32, w * 0.45, h * 0.45, crackP);
    _drawLine(canvas, w * 0.45, h * 0.45, w * 0.6, h * 0.4, crackP);
    _drawLine(canvas, w * 0.45, h * 0.45, w * 0.5, h * 0.6, crackP);
    // 碰撞点
    canvas.drawCircle(Offset(w * 0.45, h * 0.45), w * 0.04, Paint()..color = Colors.white.withOpacity(0.5));
  }

  void _drawBrilliant(Canvas canvas, Size size) {
    // 灯泡 + 闪光
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 灯泡体
    canvas.drawCircle(Offset(w * 0.5, h * 0.38), w * 0.16, p);
    // 灯泡底座
    _drawRoundedRectAt(canvas, w * 0.43, h * 0.52, w * 0.14, h * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    _drawRoundedRectAt(canvas, w * 0.45, h * 0.58, w * 0.1, h * 0.04, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // 灯丝
    final filP = Paint()..color = Colors.white..strokeWidth = w * 0.015..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final filPath = Path()
      ..moveTo(w * 0.46, h * 0.44)
      ..lineTo(w * 0.5, h * 0.35)
      ..lineTo(w * 0.54, h * 0.44);
    canvas.drawPath(filPath, filP);
    // 光芒
    final rayP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = w * 0.02..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      _drawLine(canvas, w * 0.5 + cos(angle) * w * 0.22, h * 0.38 + sin(angle) * w * 0.22, w * 0.5 + cos(angle) * w * 0.28, h * 0.38 + sin(angle) * w * 0.28, rayP);
    }
  }

  void _drawBroken(Canvas canvas, Size size) {
    _drawBreak(canvas, size); // 同 break
  }

  void _drawBrown(Canvas canvas, Size size) {
    // 咖啡杯 / 巧克力
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 杯体
    _drawRoundedRectAt(canvas, w * 0.3, h * 0.3, w * 0.3, h * 0.35, p);
    // 杯把手
    final handleP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.03;
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.63, h * 0.45), width: w * 0.12, height: h * 0.15), -pi * 0.4, pi * 0.8, false, handleP);
    // 蒸汽
    final steamP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..style = PaintingStyle.stroke..strokeWidth = w * 0.015..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final sx = w * (0.37 + i * 0.1);
      final steamPath = Path()
        ..moveTo(sx, h * 0.28)
        ..quadraticBezierTo(sx + w * 0.03, h * 0.22, sx, h * 0.16)
        ..quadraticBezierTo(sx - w * 0.03, h * 0.1, sx, h * 0.05);
      canvas.drawPath(steamPath, steamP);
    }
  }

  void _drawBuild(Canvas canvas, Size size) {
    // 砖块 + 锤子
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 砖墙
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 4; col++) {
        final x = w * (0.15 + col * 0.18 + (row.isEven ? 0.09 : 0));
        final y = h * (0.45 + row * 0.13);
        _drawRoundedRectAt(canvas, x, y, w * 0.16, h * 0.1, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5 + col * 0.1)));
      }
    }
    // 锤子
    final hammerP = Paint()..color = _dc(illustration.bg);
    // 锤柄
    _drawLine(canvas, w * 0.35, h * 0.2, w * 0.65, h * 0.55, Paint()..color = _dc(illustration.bg)..strokeWidth = w * 0.03..strokeCap = StrokeCap.round);
    // 锤头
    final headPath = Path()
      ..moveTo(w * 0.3, h * 0.22)
      ..lineTo(w * 0.42, h * 0.12)
      ..lineTo(w * 0.5, h * 0.18)
      ..lineTo(w * 0.38, h * 0.28)
      ..close();
    canvas.drawPath(headPath, hammerP);
  }

  void _drawBurn(Canvas canvas, Size size) {
    // 火焰
    final w = size.width, h = size.height;
    // 外焰（大）
    final outerPath = Path()
      ..moveTo(w * 0.5, h * 0.1)
      ..quadraticBezierTo(w * 0.75, h * 0.4, w * 0.65, h * 0.65)
      ..quadraticBezierTo(w * 0.5, h * 0.8, w * 0.35, h * 0.65)
      ..quadraticBezierTo(w * 0.25, h * 0.4, w * 0.5, h * 0.1);
    canvas.drawPath(outerPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // 内焰（黄）
    final innerPath = Path()
      ..moveTo(w * 0.5, h * 0.25)
      ..quadraticBezierTo(w * 0.62, h * 0.45, w * 0.57, h * 0.58)
      ..quadraticBezierTo(w * 0.5, h * 0.68, w * 0.43, h * 0.58)
      ..quadraticBezierTo(w * 0.38, h * 0.45, w * 0.5, h * 0.25);
    canvas.drawPath(innerPath, Paint()..color = Colors.yellow.withOpacity(0.8));
    // 内芯（白）
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.04, Paint()..color = Colors.white.withOpacity(0.7));
  }

  void _drawBusy(Canvas canvas, Size size) {
    // 旋转的齿轮（忙碌）
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 大齿轮
    _drawGearShape(canvas, w * 0.4, h * 0.42, w * 0.18, 8, p);
    // 小齿轮
    _drawGearShape(canvas, w * 0.68, h * 0.55, w * 0.1, 6, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // 中心圆
    canvas.drawCircle(Offset(w * 0.4, h * 0.42), w * 0.06, Paint()..color = Colors.white.withOpacity(0.3));
    canvas.drawCircle(Offset(w * 0.68, h * 0.55), w * 0.03, Paint()..color = Colors.white.withOpacity(0.3));
    // 旋转标记
    final spinP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..style = PaintingStyle.stroke..strokeWidth = w * 0.015..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.4, h * 0.42), width: w * 0.35, height: w * 0.35), -pi * 0.3, pi * 0.5, false, spinP);
  }

  void _drawCarry(Canvas canvas, Size size) {
    // 搬东西的人
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 箱子
    _drawRoundedRectAt(canvas, w * 0.55, h * 0.28, w * 0.28, h * 0.22, p);
    // 箱子条纹
    _drawLine(canvas, w * 0.55, h * 0.39, w * 0.83, h * 0.39, Paint()..color = Colors.white.withOpacity(0.3)..strokeWidth = w * 0.015);
    // 人
    canvas.drawCircle(Offset(w * 0.32, h * 0.48), w * 0.06, p);
    _drawRoundedRectAt(canvas, w * 0.26, h * 0.55, w * 0.12, h * 0.18, p);
    // 手臂托箱子
    _drawLine(canvas, w * 0.38, h * 0.58, w * 0.55, h * 0.45, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.03..strokeCap = StrokeCap.round);
    // 腿
    _drawLine(canvas, w * 0.3, h * 0.73, w * 0.25, h * 0.88, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.025..strokeCap = StrokeCap.round);
    _drawLine(canvas, w * 0.36, h * 0.73, w * 0.4, h * 0.88, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.025..strokeCap = StrokeCap.round);
  }

  void _drawChat(Canvas canvas, Size size) {
    // 聊天气泡
    final w = size.width, h = size.height;
    // 大气泡
    final bubble1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, h * 0.18, w * 0.5, h * 0.28),
      Radius.circular(w * 0.06),
    );
    canvas.drawRRect(bubble1, Paint()..color = _dc(illustration.accent));
    // 小气泡尾巴
    final tail1 = Path()
      ..moveTo(w * 0.25, h * 0.46)
      ..lineTo(w * 0.18, h * 0.56)
      ..lineTo(w * 0.32, h * 0.46)
      ..close();
    canvas.drawPath(tail1, Paint()..color = _dc(illustration.accent));
    // 小气泡（回复）
    final bubble2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.35, h * 0.55, w * 0.38, h * 0.2),
      Radius.circular(w * 0.05),
    );
    canvas.drawRRect(bubble2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // 气泡尾巴
    final tail2 = Path()
      ..moveTo(w * 0.55, h * 0.75)
      ..lineTo(w * 0.62, h * 0.82)
      ..lineTo(w * 0.5, h * 0.75)
      ..close();
    canvas.drawPath(tail2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // 文字点
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(w * (0.25 + i * 0.1), h * 0.32), w * 0.02, Paint()..color = Colors.white);
    }
  }

  void _drawCheap(Canvas canvas, Size size) {
    // 低价标签
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 价格标签
    final tagPath = Path()
      ..moveTo(w * 0.2, h * 0.3)
      ..lineTo(w * 0.75, h * 0.3)
      ..lineTo(w * 0.75, h * 0.7)
      ..lineTo(w * 0.5, h * 0.7)
      ..lineTo(w * 0.2, h * 0.5)
      ..close();
    canvas.drawPath(tagPath, p);
    // 标签洞
    canvas.drawCircle(Offset(w * 0.32, h * 0.4), w * 0.04, Paint()..color = Colors.white.withOpacity(0.3));
    // 价格
    _drawText(canvas, '\$', w * 0.52, h * 0.5, w * 0.14, Colors.white);
    // 绿色向下箭头（便宜）
    final arrowP = Paint()..color = Colors.greenAccent..strokeWidth = w * 0.025..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.55, h * 0.15, w * 0.55, h * 0.28, arrowP);
    _drawLine(canvas, w * 0.48, h * 0.22, w * 0.55, h * 0.28, arrowP);
    _drawLine(canvas, w * 0.62, h * 0.22, w * 0.55, h * 0.28, arrowP);
  }

  void _drawChoose(Canvas canvas, Size size) {
    // 分岔路 + 选择标记
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.04..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    // 主路
    _drawLine(canvas, w * 0.5, h * 0.85, w * 0.5, h * 0.5, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.04..strokeCap = StrokeCap.round);
    // 分岔左
    final leftPath = Path()
      ..moveTo(w * 0.5, h * 0.5)
      ..quadraticBezierTo(w * 0.4, h * 0.35, w * 0.25, h * 0.22);
    canvas.drawPath(leftPath, p);
    // 分岔右
    final rightPath = Path()
      ..moveTo(w * 0.5, h * 0.5)
      ..quadraticBezierTo(w * 0.6, h * 0.35, w * 0.75, h * 0.22);
    canvas.drawPath(rightPath, p);
    // 勾选（右路）
    final checkP = Paint()..color = Colors.greenAccent..strokeWidth = w * 0.035..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final checkPath = Path()
      ..moveTo(w * 0.68, h * 0.22)
      ..lineTo(w * 0.75, h * 0.15)
      ..lineTo(w * 0.85, h * 0.28);
    canvas.drawPath(checkPath, checkP);
  }

  void _drawClap(Canvas canvas, Size size) {
    // 鼓掌双手
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 左手掌
    final leftHand = Path()
      ..moveTo(w * 0.3, h * 0.6)
      ..lineTo(w * 0.25, h * 0.35)
      ..lineTo(w * 0.35, h * 0.3)
      ..lineTo(w * 0.42, h * 0.35)
      ..lineTo(w * 0.45, h * 0.55)
      ..close();
    canvas.drawPath(leftHand, p);
    // 右手掌
    final rightHand = Path()
      ..moveTo(w * 0.7, h * 0.6)
      ..lineTo(w * 0.75, h * 0.35)
      ..lineTo(w * 0.65, h * 0.3)
      ..lineTo(w * 0.58, h * 0.35)
      ..lineTo(w * 0.55, h * 0.55)
      ..close();
    canvas.drawPath(rightHand, p);
    // 碰撞效果
    _drawStarShape(canvas, w * 0.5, h * 0.35, w * 0.06, w * 0.025, 5, Paint()..color = Colors.yellow.withOpacity(0.7));
    // 音效线
    final effectP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = w * 0.015..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.35, h * 0.22, w * 0.3, h * 0.15, effectP);
    _drawLine(canvas, w * 0.65, h * 0.22, w * 0.7, h * 0.15, effectP);
  }

  void _drawClever(Canvas canvas, Size size) {
    // 灯泡（聪明）
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 灯泡
    canvas.drawCircle(Offset(w * 0.5, h * 0.35), w * 0.15, p);
    _drawRoundedRectAt(canvas, w * 0.44, h * 0.48, w * 0.12, h * 0.05, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // 灯丝
    final filP = Paint()..color = Colors.white..strokeWidth = w * 0.012..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final filPath = Path()
      ..moveTo(w * 0.47, h * 0.4)
      ..lineTo(w * 0.5, h * 0.33)
      ..lineTo(w * 0.53, h * 0.4);
    canvas.drawPath(filPath, filP);
    // 大脑图案（灯泡内）
    final brainP = Paint()..color = Colors.white.withOpacity(0.4)..strokeWidth = w * 0.01..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.47, h * 0.35), width: w * 0.06, height: h * 0.06), 0, pi * 1.5, false, brainP);
    // 光芒
    final rayP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25))..strokeWidth = w * 0.015..strokeCap = StrokeCap.round;
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3 + pi / 6;
      _drawLine(canvas, w * 0.5 + cos(angle) * w * 0.2, h * 0.35 + sin(angle) * w * 0.2, w * 0.5 + cos(angle) * w * 0.25, h * 0.35 + sin(angle) * w * 0.25, rayP);
    }
  }

  void _drawClosed(Canvas canvas, Size size) {
    // 关闭的门
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 门框
    _drawRoundedRectAt(canvas, w * 0.25, h * 0.15, w * 0.5, h * 0.7, p);
    // 门
    _drawRoundedRectAt(canvas, w * 0.28, h * 0.18, w * 0.44, h * 0.67, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // 门缝
    _drawLine(canvas, w * 0.5, h * 0.2, w * 0.5, h * 0.83, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = w * 0.01);
    // 门把手
    canvas.drawCircle(Offset(w * 0.6, h * 0.52), w * 0.025, Paint()..color = Colors.white);
    // 锁
    _drawRoundedRectAt(canvas, w * 0.57, h * 0.6, w * 0.05, h * 0.06, Paint()..color = Colors.white.withOpacity(0.6));
    // X标记（关闭）
    final xP = Paint()..color = _dc(illustration.bg)..strokeWidth = w * 0.03..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.75, h * 0.1, w * 0.9, h * 0.22, xP);
    _drawLine(canvas, w * 0.9, h * 0.1, w * 0.75, h * 0.22, xP);
  }

  void _drawCloudy(Canvas canvas, Size size) {
    // 云朵
    final w = size.width, h = size.height;
    // 大云
    canvas.drawCircle(Offset(w * 0.4, h * 0.42), w * 0.14, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(w * 0.55, h * 0.38), w * 0.16, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(w * 0.3, h * 0.48), w * 0.1, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(w * 0.65, h * 0.45), w * 0.12, Paint()..color = _dc(illustration.accent));
    // 底部填充
    _drawRoundedRectAt(canvas, w * 0.2, h * 0.43, w * 0.55, h * 0.12, Paint()..color = _dc(illustration.accent));
    // 小云（远景）
    canvas.drawCircle(Offset(w * 0.2, h * 0.25), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    canvas.drawCircle(Offset(w * 0.28, h * 0.23), w * 0.07, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    // 阴影
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.48, h * 0.6), width: w * 0.5, height: h * 0.04), Paint()..color = Colors.black.withOpacity(0.05));
  }

  void _drawComplete(Canvas canvas, Size size) {
    // 完成的圆环 + 对勾
    final w = size.width, h = size.height;
    // 圆环（进度100%）
    final ringP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..style = PaintingStyle.stroke..strokeWidth = w * 0.04..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.25, ringP);
    // 完成弧
    final doneP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.04..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.5, h * 0.45), width: w * 0.5, height: w * 0.5), -pi * 0.5, pi * 2, false, doneP);
    // 大对勾
    final checkP = Paint()..color = Colors.white..strokeWidth = w * 0.04..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final checkPath = Path()
      ..moveTo(w * 0.35, h * 0.45)
      ..lineTo(w * 0.47, h * 0.55)
      ..lineTo(w * 0.68, h * 0.33);
    canvas.drawPath(checkPath, checkP);
  }

  void _drawCool(Canvas canvas, Size size) {
    // 太阳镜（酷）
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 镜框
    final frameP = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.02..style = PaintingStyle.stroke;
    _drawLine(canvas, w * 0.15, h * 0.4, w * 0.3, h * 0.4, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.02..strokeCap = StrokeCap.round);
    _drawLine(canvas, w * 0.7, h * 0.4, w * 0.85, h * 0.4, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.02..strokeCap = StrokeCap.round);
    _drawLine(canvas, w * 0.45, h * 0.4, w * 0.55, h * 0.4, Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.015..strokeCap = StrokeCap.round);
    // 左镜片
    _drawRoundedRectAt(canvas, w * 0.15, h * 0.3, w * 0.25, h * 0.18, p);
    // 右镜片
    _drawRoundedRectAt(canvas, w * 0.6, h * 0.3, w * 0.25, h * 0.18, p);
    // 镜片反光
    _drawLine(canvas, w * 0.2, h * 0.33, w * 0.3, h * 0.38, Paint()..color = Colors.white.withOpacity(0.3)..strokeWidth = w * 0.015..strokeCap = StrokeCap.round);
    _drawLine(canvas, w * 0.65, h * 0.33, w * 0.75, h * 0.38, Paint()..color = Colors.white.withOpacity(0.3)..strokeWidth = w * 0.015..strokeCap = StrokeCap.round);
    // 微笑
    final smileP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.02..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.5, h * 0.62), width: w * 0.2, height: h * 0.1), pi * 0.1, pi * 0.8, false, smileP);
  }

  void _drawCorrect(Canvas canvas, Size size) {
    // 绿色大对勾
    final w = size.width, h = size.height;
    // 圆形背景
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.28, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    // 对勾
    final checkP = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.06..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final checkPath = Path()
      ..moveTo(w * 0.28, h * 0.45)
      ..lineTo(w * 0.44, h * 0.6)
      ..lineTo(w * 0.72, h * 0.3);
    canvas.drawPath(checkPath, checkP);
    // 光环
    final haloP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.1))..style = PaintingStyle.stroke..strokeWidth = w * 0.02;
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.35, haloP);
  }

  void _drawCount(Canvas canvas, Size size) {
    // 数字 + 手指
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 数字123
    _drawText(canvas, '1', w * 0.25, h * 0.3, w * 0.12, illustration.accent);
    _drawText(canvas, '2', w * 0.5, h * 0.35, w * 0.12, illustration.accent.withOpacity(_minOp(0.7)));
    _drawText(canvas, '3', w * 0.75, h * 0.3, w * 0.12, illustration.accent.withOpacity(_minOp(0.5)));
    // 手（数数手势）
    final handP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = w * 0.03..strokeCap = StrokeCap.round;
    // 手掌
    _drawRoundedRectAt(canvas, w * 0.25, h * 0.55, w * 0.18, h * 0.15, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // 手指
    for (int i = 0; i < 5; i++) {
      final fx = w * (0.26 + i * 0.04);
      final fh = h * (0.1 + (i == 2 ? 0.06 : 0) + (i == 3 ? 0.03 : 0));
      _drawRoundedRectAt(canvas, fx, h * 0.5 - fh, w * 0.03, fh, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    }
  }

  void _drawCurly(Canvas canvas, Size size) {
    // 卷发
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 头
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.15, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // 卷发螺旋
    final curlP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.025..strokeCap = StrokeCap.round;
    for (int i = 0; i < 7; i++) {
      final angle = i * pi / 3.5;
      final r = w * 0.15;
      final cx = w * 0.5 + cos(angle) * r;
      final cy = h * 0.5 + sin(angle) * r;
      final curlPath = Path();
      for (double t = 0; t < pi * 2; t += 0.1) {
        final cr = w * 0.02 + t * w * 0.005;
        final px = cx + cos(t) * cr;
        final py = cy + sin(t) * cr;
        if (t == 0) curlPath.moveTo(px, py);
        else curlPath.lineTo(px, py);
      }
      canvas.drawPath(curlPath, curlP);
    }
  }

  void _drawDecide(Canvas canvas, Size size) {
    // 思考 + 决定（灯泡亮起）
    final w = size.width, h = size.height;
    // 思考气泡
    final thinkP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..style = PaintingStyle.stroke..strokeWidth = w * 0.015;
    canvas.drawCircle(Offset(w * 0.5, h * 0.35), w * 0.2, thinkP);
    // 小点连到头
    canvas.drawCircle(Offset(w * 0.35, h * 0.55), w * 0.02, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    canvas.drawCircle(Offset(w * 0.3, h * 0.6), w * 0.025, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25)));
    canvas.drawCircle(Offset(w * 0.25, h * 0.65), w * 0.03, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
    // 灯泡亮起（决定）
    canvas.drawCircle(Offset(w * 0.5, h * 0.35), w * 0.1, Paint()..color = _dc(illustration.accent));
    // 对勾
    final checkP = Paint()..color = Colors.white..strokeWidth = w * 0.025..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final checkPath = Path()
      ..moveTo(w * 0.44, h * 0.35)
      ..lineTo(w * 0.49, h * 0.4)
      ..lineTo(w * 0.58, h * 0.3);
    canvas.drawPath(checkPath, checkP);
  }

  void _drawDelicious(Canvas canvas, Size size) {
    // 美食（蛋糕/冰淇淋）
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent);
    // 蛋糕底
    _drawRoundedRectAt(canvas, w * 0.2, h * 0.55, w * 0.6, h * 0.2, p);
    // 蛋糕层
    _drawRoundedRectAt(canvas, w * 0.25, h * 0.42, w * 0.5, h * 0.15, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // 糖霜
    final frostP = Paint()..color = Colors.white.withOpacity(0.6)..style = PaintingStyle.stroke..strokeWidth = w * 0.015..strokeCap = StrokeCap.round;
    final frostPath = Path();
    frostPath.moveTo(w * 0.25, h * 0.42);
    for (double x = 0.25; x <= 0.75; x += 0.03) {
      frostPath.lineTo(w * x, h * (0.42 + sin(x * pi * 8) * 0.015));
    }
    canvas.drawPath(frostPath, frostP);
    // 蜡烛
    _drawRoundedRectAt(canvas, w * 0.48, h * 0.25, w * 0.04, h * 0.18, Paint()..color = Colors.redAccent);
    // 火焰
    final flamePath = Path()
      ..moveTo(w * 0.5, h * 0.2)
      ..quadraticBezierTo(w * 0.54, h * 0.25, w * 0.5, h * 0.28)
      ..quadraticBezierTo(w * 0.46, h * 0.25, w * 0.5, h * 0.2);
    canvas.drawPath(flamePath, Paint()..color = Colors.yellow);
    // 樱桃
    canvas.drawCircle(Offset(w * 0.6, h * 0.4), w * 0.03, Paint()..color = Colors.redAccent);
  }

  void _drawDesign(Canvas canvas, Size size) {
    // 铅笔 + 草图
    final w = size.width, h = size.height;
    // 铅笔
    final pencilP = Paint()..color = _dc(illustration.accent);
    final pencilPath = Path()
      ..moveTo(w * 0.25, h * 0.75)
      ..lineTo(w * 0.7, h * 0.2)
      ..lineTo(w * 0.75, h * 0.22)
      ..lineTo(w * 0.3, h * 0.77)
      ..close();
    canvas.drawPath(pencilPath, pencilP);
    // 笔尖
    final tipPath = Path()
      ..moveTo(w * 0.25, h * 0.75)
      ..lineTo(w * 0.22, h * 0.82)
      ..lineTo(w * 0.3, h * 0.77)
      ..close();
    canvas.drawPath(tipPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // 草图线
    final sketchP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25))..style = PaintingStyle.stroke..strokeWidth = w * 0.01..strokeCap = StrokeCap.round;
    // 画圆
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.55, h * 0.55), width: w * 0.2, height: h * 0.15), sketchP);
    // 画方
    canvas.drawRect(Rect.fromCenter(center: Offset(w * 0.4, h * 0.4), width: w * 0.15, height: h * 0.12), sketchP);
    // 画三角
    final triPath = Path()
      ..moveTo(w * 0.7, h * 0.5)
      ..lineTo(w * 0.6, h * 0.65)
      ..lineTo(w * 0.8, h * 0.65)
      ..close();
    canvas.drawPath(triPath, sketchP);
  }

  void _drawDisappear(Canvas canvas, Size size) {
    // 渐隐的人/物
    final w = size.width, h = size.height;
    // 完全显示
    canvas.drawCircle(Offset(w * 0.35, h * 0.4), w * 0.08, Paint()..color = _dc(illustration.accent));
    _drawRoundedRectAt(canvas, w * 0.28, h * 0.48, w * 0.14, h * 0.2, Paint()..color = _dc(illustration.accent));
    // 半透明
    canvas.drawCircle(Offset(w * 0.55, h * 0.4), w * 0.08, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    _drawRoundedRectAt(canvas, w * 0.48, h * 0.48, w * 0.14, h * 0.2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // 几乎消失
    canvas.drawCircle(Offset(w * 0.75, h * 0.4), w * 0.08, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.12)));
    _drawRoundedRectAt(canvas, w * 0.68, h * 0.48, w * 0.14, h * 0.2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.12)));
    // 消散粒子
    final partP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15));
    canvas.drawCircle(Offset(w * 0.82, h * 0.35), w * 0.015, partP);
    canvas.drawCircle(Offset(w * 0.85, h * 0.42), w * 0.01, partP);
    canvas.drawCircle(Offset(w * 0.88, h * 0.38), w * 0.008, partP);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Batch 5: do–hold (40 words)
  // ═══════════════════════════════════════════════════════════════════════════

  void _drawDo(Canvas canvas, Size size) {
    // 勾号 ✓ 表示"做"
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.06..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(w * 0.25, h * 0.5)
      ..lineTo(w * 0.42, h * 0.68)
      ..lineTo(w * 0.75, h * 0.32);
    canvas.drawPath(path, p);
    // circle behind
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.3, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
  }

  void _drawDouble(Canvas canvas, Size size) {
    // 双层/两个重叠矩形
    final w = size.width, h = size.height;
    _drawRoundedRectAt(canvas, w * 0.22, h * 0.3, w * 0.32, h * 0.4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    _drawRoundedRectAt(canvas, w * 0.38, h * 0.25, w * 0.32, h * 0.4, Paint()..color = _dc(illustration.accent));
    // "x2" text
    _drawText(canvas, '×2', w * 0.5, h * 0.78, w * 0.1, illustration.accent.withOpacity(_minOp(0.6)));
  }

  void _drawDrop(Canvas canvas, Size size) {
    // 水滴
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final r = w * 0.15;
    final path = Path()
      ..moveTo(cx, cy - r * 1.5)
      ..cubicTo(cx + r, cy - r * 0.5, cx + r, cy + r, cx, cy + r * 1.2)
      ..cubicTo(cx - r, cy + r, cx - r, cy - r * 0.5, cx, cy - r * 1.5);
    canvas.drawPath(path, Paint()..color = _dc(illustration.accent));
    // splash
    canvas.drawCircle(Offset(w * 0.35, h * 0.78), w * 0.04, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    canvas.drawCircle(Offset(w * 0.62, h * 0.75), w * 0.03, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25)));
  }

  void _drawEarly(Canvas canvas, Size size) {
    // 日出 + 时钟
    final w = size.width, h = size.height;
    // horizon
    canvas.drawRect(Rect.fromLTWH(0, h * 0.6, w, h * 0.4), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    // sun rising
    canvas.drawCircle(Offset(w * 0.5, h * 0.55), w * 0.12, Paint()..color = _dc(illustration.accent));
    // rays
    for (int i = 0; i < 7; i++) {
      final a = -pi * 0.8 + i * pi * 0.8 / 6;
      final r1 = w * 0.14, r2 = w * 0.22;
      _drawLine(canvas, w * 0.5 + cos(a) * r1, h * 0.55 + sin(a) * r1, w * 0.5 + cos(a) * r2, h * 0.55 + sin(a) * r2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 2);
    }
  }

  void _drawEmpty(Canvas canvas, Size size) {
    // 空杯子/空容器
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(w * 0.3, h * 0.25)
      ..lineTo(w * 0.35, h * 0.75)
      ..lineTo(w * 0.65, h * 0.75)
      ..lineTo(w * 0.7, h * 0.25)
      ..close();
    canvas.drawPath(path, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3);
    // drip lines inside
    _drawLine(canvas, w * 0.42, h * 0.4, w * 0.42, h * 0.65, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 2);
    _drawLine(canvas, w * 0.55, h * 0.45, w * 0.55, h * 0.6, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15))..strokeWidth = 2);
  }

  void _drawEnormous(Canvas canvas, Size size) {
    // 巨大的东西 vs 小参照
    final w = size.width, h = size.height;
    // small circle
    canvas.drawCircle(Offset(w * 0.25, h * 0.7), w * 0.04, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // enormous circle
    canvas.drawCircle(Offset(w * 0.55, h * 0.45), w * 0.25, Paint()..color = _dc(illustration.accent));
    // arrow
    _drawLine(canvas, w * 0.3, h * 0.65, w * 0.42, h * 0.52, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = 2);
  }

  void _drawEnter(Canvas canvas, Size size) {
    // 进入箭头 → 门口
    final w = size.width, h = size.height;
    // door frame
    _drawRoundedRectAt(canvas, w * 0.35, h * 0.2, w * 0.3, h * 0.55, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25)));
    // door opening
    canvas.drawRect(Rect.fromLTWH(w * 0.4, h * 0.35, w * 0.2, h * 0.4), Paint()..color = _dc(illustration.bg));
    // arrow pointing in
    final ap = Paint()..color = _dc(illustration.accent)..strokeWidth = 3..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(w * 0.5, h * 0.88)
      ..lineTo(w * 0.5, h * 0.6)
      ..moveTo(w * 0.42, h * 0.68)
      ..lineTo(w * 0.5, h * 0.58)
      ..lineTo(w * 0.58, h * 0.68);
    canvas.drawPath(path, ap);
  }

  void _drawExcellent(Canvas canvas, Size size) {
    // A+ 星星
    final w = size.width, h = size.height;
    _drawStarShape(canvas, w * 0.5, h * 0.4, w * 0.22, w * 0.1, 5, Paint()..color = _dc(illustration.accent));
    _drawText(canvas, 'A+', w * 0.5, h * 0.42, w * 0.1, Colors.white);
    // sparkle dots
    canvas.drawCircle(Offset(w * 0.25, h * 0.3), w * 0.025, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    canvas.drawCircle(Offset(w * 0.78, h * 0.28), w * 0.02, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    canvas.drawCircle(Offset(w * 0.72, h * 0.65), w * 0.018, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
  }

  void _drawExciting(Canvas canvas, Size size) {
    // 烟花/爆炸效果
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // center burst
    for (int i = 0; i < 12; i++) {
      final a = i * pi / 6;
      final r1 = w * 0.06, r2 = w * 0.2 + (i % 3) * w * 0.04;
      _drawLine(canvas, cx + cos(a) * r1, cy + sin(a) * r1, cx + cos(a) * r2, cy + sin(a) * r2,
          Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5 + (i % 3) * 0.15))..strokeWidth = 2..strokeCap = StrokeCap.round);
    }
    canvas.drawCircle(Offset(cx, cy), w * 0.05, Paint()..color = _dc(illustration.accent));
  }

  void _drawExpensive(Canvas canvas, Size size) {
    // 金币/价格标签
    final w = size.width, h = size.height;
    // coin
    canvas.drawCircle(Offset(w * 0.4, h * 0.4), w * 0.16, Paint()..color = const Color(0xFFFFD700));
    canvas.drawCircle(Offset(w * 0.4, h * 0.4), w * 0.12, Paint()..color = const Color(0xFFFFC107));
    _drawText(canvas, '\$', w * 0.4, h * 0.42, w * 0.1, const Color(0xFF795548));
    // dollar sign stacked
    canvas.drawCircle(Offset(w * 0.62, h * 0.55), w * 0.12, Paint()..color = const Color(0xFFFFD700).withOpacity(0.5));
    _drawText(canvas, '\$', w * 0.62, h * 0.56, w * 0.08, const Color(0xFF795548).withOpacity(0.5));
  }

  void _drawExplain(Canvas canvas, Size size) {
    // 说话泡泡 + 灯泡
    final w = size.width, h = size.height;
    // speech bubble
    final bubble = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.15, h * 0.2, w * 0.55, h * 0.35), Radius.circular(w * 0.06));
    canvas.drawRRect(bubble, Paint()..color = _dc(illustration.accent));
    // tail
    final tail = Path()..moveTo(w * 0.35, h * 0.55)..lineTo(w * 0.3, h * 0.65)..lineTo(w * 0.45, h * 0.55)..close();
    canvas.drawPath(tail, Paint()..color = _dc(illustration.accent));
    // lines inside bubble
    _drawLine(canvas, w * 0.25, h * 0.32, w * 0.6, h * 0.32, Paint()..color = Colors.white.withOpacity(0.7)..strokeWidth = 2);
    _drawLine(canvas, w * 0.25, h * 0.4, w * 0.52, h * 0.4, Paint()..color = Colors.white.withOpacity(0.5)..strokeWidth = 2);
    // lightbulb
    canvas.drawCircle(Offset(w * 0.78, h * 0.35), w * 0.08, Paint()..color = const Color(0xFFFFF9C4));
    canvas.drawRect(Rect.fromLTWH(w * 0.755, h * 0.43, w * 0.05, h * 0.04), Paint()..color = const Color(0xFF9E9E9E));
  }

  void _drawExplore(Canvas canvas, Size size) {
    // 放大镜 + 指南针
    final w = size.width, h = size.height;
    // magnifying glass
    canvas.drawCircle(Offset(w * 0.4, h * 0.4), w * 0.15, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 4);
    _drawLine(canvas, w * 0.5, h * 0.52, w * 0.65, h * 0.68, Paint()..color = _dc(illustration.accent)..strokeWidth = 4..strokeCap = StrokeCap.round);
    // sparkles inside
    canvas.drawCircle(Offset(w * 0.35, h * 0.35), w * 0.02, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    canvas.drawCircle(Offset(w * 0.45, h * 0.38), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    // compass marks
    canvas.drawCircle(Offset(w * 0.75, h * 0.3), w * 0.08, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
    _drawText(canvas, 'N', w * 0.75, h * 0.24, w * 0.06, illustration.accent);
  }

  void _drawFair(Canvas canvas, Size size) {
    // 天平/平衡
    final w = size.width, h = size.height;
    // base
    _drawLine(canvas, w * 0.5, h * 0.3, w * 0.5, h * 0.7, Paint()..color = _dc(illustration.accent)..strokeWidth = 3);
    // beam
    _drawLine(canvas, w * 0.2, h * 0.35, w * 0.8, h * 0.35, Paint()..color = _dc(illustration.accent)..strokeWidth = 3);
    // left pan
    _drawLine(canvas, w * 0.2, h * 0.35, w * 0.2, h * 0.5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = 2);
    canvas.drawCircle(Offset(w * 0.2, h * 0.52), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // right pan
    _drawLine(canvas, w * 0.8, h * 0.35, w * 0.8, h * 0.5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = 2);
    canvas.drawCircle(Offset(w * 0.8, h * 0.52), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // fulcrum
    final tri = Path()..moveTo(w * 0.5, h * 0.7)..lineTo(w * 0.43, h * 0.78)..lineTo(w * 0.57, h * 0.78)..close();
    canvas.drawPath(tri, Paint()..color = _dc(illustration.accent));
  }

  void _drawFantastic(Canvas canvas, Size size) {
    // 魔杖 + 星星
    final w = size.width, h = size.height;
    // wand
    _drawLine(canvas, w * 0.2, h * 0.75, w * 0.6, h * 0.25, Paint()..color = _dc(illustration.accent)..strokeWidth = 3..strokeCap = StrokeCap.round);
    // star at tip
    _drawStarShape(canvas, w * 0.6, h * 0.25, w * 0.1, w * 0.04, 5, Paint()..color = _dc(illustration.accent));
    // trailing sparkles
    for (int i = 0; i < 5; i++) {
      final frac = i / 5;
      final sx = w * (0.35 + frac * 0.2) + sin(i * 1.5) * w * 0.05;
      final sy = h * (0.55 - frac * 0.25) + cos(i * 2) * h * 0.04;
      canvas.drawCircle(Offset(sx, sy), w * 0.015 * (1 - frac), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3 + 0.3 * (1 - frac))));
    }
  }

  void _drawFar(Canvas canvas, Size size) {
    // 远山 + 路径
    final w = size.width, h = size.height;
    // ground
    canvas.drawRect(Rect.fromLTWH(0, h * 0.65, w, h * 0.35), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    // near mountain
    final m1 = Path()..moveTo(w * 0.1, h * 0.65)..lineTo(w * 0.35, h * 0.3)..lineTo(w * 0.6, h * 0.65)..close();
    canvas.drawPath(m1, Paint()..color = _dc(illustration.accent));
    // far mountain (smaller, faded)
    final m2 = Path()..moveTo(w * 0.45, h * 0.65)..lineTo(w * 0.65, h * 0.42)..lineTo(w * 0.85, h * 0.65)..close();
    canvas.drawPath(m2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // path going far
    _drawLine(canvas, w * 0.5, h * 0.65, w * 0.65, h * 0.55, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  void _drawFat(Canvas canvas, Size size) {
    // 胖胖的圆形
    final w = size.width, h = size.height;
    // big round body
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.5), width: w * 0.55, height: h * 0.5), Paint()..color = _dc(illustration.accent));
    // head
    canvas.drawCircle(Offset(w * 0.5, h * 0.22), w * 0.1, Paint()..color = _dc(illustration.accent));
    // arms
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.22, h * 0.48), width: w * 0.12, height: h * 0.08), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.78, h * 0.48), width: w * 0.12, height: h * 0.08), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    // smile
    _drawFace(canvas, w * 0.5, h * 0.22, w * 0.08, illustration.accent);
  }

  void _drawFeed(Canvas canvas, Size size) {
    // 碗 + 食物
    final w = size.width, h = size.height;
    // bowl
    final bowl = Path()
      ..moveTo(w * 0.2, h * 0.45)
      ..quadraticBezierTo(w * 0.5, h * 0.75, w * 0.8, h * 0.45)
      ..close();
    canvas.drawPath(bowl, Paint()..color = _dc(illustration.accent));
    // food on top
    canvas.drawCircle(Offset(w * 0.4, h * 0.4), w * 0.05, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    canvas.drawCircle(Offset(w * 0.55, h * 0.38), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    canvas.drawCircle(Offset(w * 0.48, h * 0.33), w * 0.04, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // spoon
    _drawLine(canvas, w * 0.7, h * 0.3, w * 0.78, h * 0.55, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 3..strokeCap = StrokeCap.round);
  }

  void _drawFetch(Canvas canvas, Size size) {
    // 狗追球
    final w = size.width, h = size.height;
    // ball
    canvas.drawCircle(Offset(w * 0.7, h * 0.35), w * 0.08, Paint()..color = _dc(illustration.accent));
    // dog body
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.35, h * 0.55), width: w * 0.25, height: h * 0.18), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // dog head
    canvas.drawCircle(Offset(w * 0.52, h * 0.45), w * 0.08, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    // ear
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.55, h * 0.38), width: w * 0.06, height: h * 0.08), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // tail wagging
    final tail = Path()..moveTo(w * 0.22, h * 0.5)..quadraticBezierTo(w * 0.15, h * 0.35, w * 0.18, h * 0.3);
    canvas.drawPath(tail, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round);
    // motion lines
    _drawLine(canvas, w * 0.58, h * 0.48, w * 0.62, h * 0.48, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 2);
    _drawLine(canvas, w * 0.56, h * 0.52, w * 0.61, h * 0.52, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 2);
  }

  void _drawFine(Canvas canvas, Size size) {
    // 微笑 + 阳光
    final w = size.width, h = size.height;
    // sun
    canvas.drawCircle(Offset(w * 0.5, h * 0.35), w * 0.15, Paint()..color = _dc(illustration.accent));
    // rays
    for (int i = 0; i < 8; i++) {
      final a = i * pi / 4;
      _drawLine(canvas, w * 0.5 + cos(a) * w * 0.17, h * 0.35 + sin(a) * w * 0.17,
          w * 0.5 + cos(a) * w * 0.24, h * 0.35 + sin(a) * w * 0.24, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 2);
    }
    // smile
    _drawFace(canvas, w * 0.5, h * 0.35, w * 0.12, illustration.accent);
    // thumbs up small
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.35, h * 0.68, w * 0.3, h * 0.12), Radius.circular(w * 0.03)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
  }

  void _drawFirst(Canvas canvas, Size size) {
    // 奖杯 #1
    final w = size.width, h = size.height;
    // cup
    final cup = Path()
      ..moveTo(w * 0.32, h * 0.25)
      ..lineTo(w * 0.36, h * 0.55)
      ..quadraticBezierTo(w * 0.5, h * 0.62, w * 0.64, h * 0.55)
      ..lineTo(w * 0.68, h * 0.25)
      ..close();
    canvas.drawPath(cup, Paint()..color = _dc(illustration.accent));
    // handles
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.28, h * 0.38), width: w * 0.12, height: h * 0.16), -pi * 0.4, pi * 0.8, false, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.72, h * 0.38), width: w * 0.12, height: h * 0.16), pi * 0.6, pi * 0.8, false, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3);
    // base
    _drawRoundedRectAt(canvas, w * 0.38, h * 0.62, w * 0.24, h * 0.06, Paint()..color = _dc(illustration.accent));
    _drawRoundedRectAt(canvas, w * 0.42, h * 0.68, w * 0.16, h * 0.06, Paint()..color = _dc(illustration.accent));
    // #1
    _drawText(canvas, '1', w * 0.5, h * 0.4, w * 0.12, Colors.white);
  }

  void _drawFix(Canvas canvas, Size size) {
    // 扳手/工具
    final w = size.width, h = size.height;
    // wrench shape
    final p = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.05..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(w * 0.3, h * 0.7)
      ..lineTo(w * 0.65, h * 0.35);
    canvas.drawPath(path, p);
    // wrench head
    canvas.drawCircle(Offset(w * 0.65, h * 0.33), w * 0.08, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.04);
    canvas.drawCircle(Offset(w * 0.65, h * 0.33), w * 0.04, Paint()..color = _dc(illustration.accent));
    // gear
    _drawGearShape(canvas, w * 0.3, h * 0.72, w * 0.1, 8, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // bolt
    canvas.drawCircle(Offset(w * 0.78, h * 0.6), w * 0.04, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
  }

  void _drawFoggy(Canvas canvas, Size size) {
    // 雾气层
    final w = size.width, h = size.height;
    for (int i = 0; i < 5; i++) {
      final y = h * (0.25 + i * 0.12);
      final opacity = 0.15 + (i % 3) * 0.1;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * (0.05 + i * 0.03), y, w * (0.9 - i * 0.06), h * 0.06),
          Radius.circular(w * 0.03),
        ),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(opacity)),
      );
    }
    // faint sun behind
    canvas.drawCircle(Offset(w * 0.7, h * 0.2), w * 0.08, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
  }

  void _drawFollow(Canvas canvas, Size size) {
    // 排队/跟随
    final w = size.width, h = size.height;
    for (int i = 0; i < 4; i++) {
      final x = w * (0.2 + i * 0.17);
      final y = h * (0.45 + sin(i * 0.5) * h * 0.03);
      final scale = 1.0 - i * 0.12;
      // head
      canvas.drawCircle(Offset(x, y - h * 0.08 * scale), w * 0.05 * scale, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.9 - i * 0.15)));
      // body
      _drawRoundedRectAt(canvas, x - w * 0.04 * scale, y, w * 0.08 * scale, h * 0.14 * scale, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8 - i * 0.15)));
    }
    // arrows between
    for (int i = 0; i < 3; i++) {
      final ax = w * (0.3 + i * 0.17);
      _drawLine(canvas, ax, h * 0.42, ax + w * 0.06, h * 0.42, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25))..strokeWidth = 2..strokeCap = StrokeCap.round);
    }
  }

  void _drawForget(Canvas canvas, Size size) {
    // 泡泡消失 + 空脑袋
    final w = size.width, h = size.height;
    // head outline
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.2, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3);
    // fading thought bubbles
    canvas.drawCircle(Offset(w * 0.35, h * 0.28), w * 0.03, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    canvas.drawCircle(Offset(w * 0.42, h * 0.2), w * 0.02, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.1)));
    canvas.drawCircle(Offset(w * 0.5, h * 0.14), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.06)));
    // question mark fading
    _drawText(canvas, '?', w * 0.5, h * 0.45, w * 0.12, illustration.accent.withOpacity(_minOp(0.3)));
  }

  void _drawFrightened(Canvas canvas, Size size) {
    // 害怕的脸
    final w = size.width, h = size.height;
    // face
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.2, Paint()..color = _dc(illustration.accent));
    // wide eyes
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.42, h * 0.4), width: w * 0.06, height: w * 0.07), Paint()..color = Colors.white);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.58, h * 0.4), width: w * 0.06, height: w * 0.07), Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.42, h * 0.41), w * 0.02, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(w * 0.58, h * 0.41), w * 0.02, Paint()..color = Colors.black);
    // open mouth O
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.55), width: w * 0.06, height: w * 0.05), Paint()..color = Colors.white);
    // sweat drop
    final drop = Path()
      ..moveTo(w * 0.68, h * 0.3)
      ..quadraticBezierTo(w * 0.72, h * 0.38, w * 0.68, h * 0.42)
      ..quadraticBezierTo(w * 0.64, h * 0.38, w * 0.68, h * 0.3);
    canvas.drawPath(drop, Paint()..color = const Color(0xFF64B5F6));
    // shaking lines
    _drawLine(canvas, w * 0.22, h * 0.35, w * 0.18, h * 0.32, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 2);
    _drawLine(canvas, w * 0.78, h * 0.35, w * 0.82, h * 0.32, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 2);
  }

  void _drawFull(Canvas canvas, Size size) {
    // 满杯/满溢
    final w = size.width, h = size.height;
    // cup
    final cup = Path()
      ..moveTo(w * 0.3, h * 0.3)
      ..lineTo(w * 0.35, h * 0.75)
      ..lineTo(w * 0.65, h * 0.75)
      ..lineTo(w * 0.7, h * 0.3)
      ..close();
    canvas.drawPath(cup, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3);
    // fill to brim
    final fill = Path()
      ..moveTo(w * 0.32, h * 0.35)
      ..lineTo(w * 0.36, h * 0.73)
      ..lineTo(w * 0.64, h * 0.73)
      ..lineTo(w * 0.68, h * 0.35)
      ..close();
    canvas.drawPath(fill, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // overflow drops
    canvas.drawCircle(Offset(w * 0.5, h * 0.28), w * 0.02, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    canvas.drawCircle(Offset(w * 0.44, h * 0.25), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
  }

  void _drawFun(Canvas canvas, Size size) {
    // 笑脸 + 派对
    final w = size.width, h = size.height;
    canvas.drawCircle(Offset(w * 0.5, h * 0.42), w * 0.2, Paint()..color = _dc(illustration.accent));
    _drawFace(canvas, w * 0.5, h * 0.42, w * 0.18, illustration.accent);
    // confetti
    final colors = [Colors.red, Colors.blue, Colors.yellow, Colors.green, Colors.orange];
    final rng = Random(42);
    for (int i = 0; i < 12; i++) {
      final cx = rng.nextDouble() * w;
      final cy = rng.nextDouble() * h * 0.3;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(rng.nextDouble() * pi);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: w * 0.02, height: w * 0.05), Paint()..color = colors[i % colors.length].withOpacity(0.6));
      canvas.restore();
    }
  }

  void _drawFunny(Canvas canvas, Size size) {
    // 搞笑脸 + 哈哈
    final w = size.width, h = size.height;
    canvas.drawCircle(Offset(w * 0.5, h * 0.4), w * 0.2, Paint()..color = _dc(illustration.accent));
    // squinting happy eyes (arcs)
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.42, h * 0.36), width: w * 0.07, height: w * 0.05), pi * 0.1, pi * 0.8, false, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.58, h * 0.36), width: w * 0.07, height: w * 0.05), pi * 0.1, pi * 0.8, false, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    // big grin
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.5, h * 0.46), width: w * 0.12, height: w * 0.08), 0, pi, false, Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5);
    // HA HA text
    _drawText(canvas, 'Ha!', w * 0.75, h * 0.25, w * 0.08, illustration.accent.withOpacity(_minOp(0.5)));
    _drawText(canvas, 'Ha!', w * 0.22, h * 0.65, w * 0.06, illustration.accent.withOpacity(_minOp(0.4)));
  }

  void _drawFurry(Canvas canvas, Size size) {
    // 毛茸茸的动物
    final w = size.width, h = size.height;
    // body with wavy fur edge
    final cx = w * 0.5, cy = h * 0.5;
    final r = w * 0.2;
    final path = Path();
    for (int i = 0; i <= 36; i++) {
      final a = i * pi * 2 / 36;
      final furR = r + sin(a * 8) * r * 0.12;
      final x = cx + cos(a) * furR;
      final y = cy + sin(a) * furR;
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = _dc(illustration.accent));
    // eyes
    canvas.drawCircle(Offset(w * 0.43, h * 0.45), w * 0.025, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.57, h * 0.45), w * 0.025, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.43, h * 0.45), w * 0.012, Paint()..color = Colors.black);
    canvas.drawCircle(Offset(w * 0.57, h * 0.45), w * 0.012, Paint()..color = Colors.black);
    // ears
    canvas.drawCircle(Offset(w * 0.35, h * 0.32), w * 0.06, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(w * 0.65, h * 0.32), w * 0.06, Paint()..color = _dc(illustration.accent));
  }

  void _drawGood(Canvas canvas, Size size) {
    // 大拇指 + 对勾
    final w = size.width, h = size.height;
    // thumbs up shape
    final thumb = Paint()..color = _dc(illustration.accent);
    // palm
    _drawRoundedRectAt(canvas, w * 0.3, h * 0.45, w * 0.15, h * 0.25, thumb);
    // thumb up
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.38, h * 0.25, w * 0.08, h * 0.22), Radius.circular(w * 0.04)), thumb);
    // fingers
    for (int i = 0; i < 4; i++) {
      final fx = w * (0.48 + i * 0.05);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(fx, h * 0.43, w * 0.035, h * 0.12 - i * h * 0.01), Radius.circular(w * 0.015)), thumb);
    }
    // checkmark
    final p = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    final check = Path()..moveTo(w * 0.28, h * 0.75)..lineTo(w * 0.38, h * 0.85)..lineTo(w * 0.55, h * 0.68);
    canvas.drawPath(check, p);
  }

  void _drawGray(Canvas canvas, Size size) {
    // 灰色云
    final w = size.width, h = size.height;
    // cloud shape from overlapping circles
    final gray = _dc(illustration.accent);
    canvas.drawCircle(Offset(w * 0.38, h * 0.45), w * 0.13, Paint()..color = gray);
    canvas.drawCircle(Offset(w * 0.55, h * 0.4), w * 0.15, Paint()..color = gray);
    canvas.drawCircle(Offset(w * 0.68, h * 0.47), w * 0.11, Paint()..color = gray);
    // fill bottom
    canvas.drawRect(Rect.fromLTWH(w * 0.25, h * 0.45, w * 0.48, h * 0.1), Paint()..color = gray);
    // rain drops
    for (int i = 0; i < 4; i++) {
      final rx = w * (0.32 + i * 0.1);
      _drawLine(canvas, rx, h * 0.6, rx, h * 0.72, Paint()..color = gray.withOpacity(0.4)..strokeWidth = 2..strokeCap = StrokeCap.round);
    }
  }

  void _drawGuess(Canvas canvas, Size size) {
    // 问号 + 思考
    final w = size.width, h = size.height;
    // big question mark
    _drawText(canvas, '?', w * 0.5, h * 0.4, w * 0.25, illustration.accent);
    // thought bubbles
    canvas.drawCircle(Offset(w * 0.65, h * 0.25), w * 0.03, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
    canvas.drawCircle(Offset(w * 0.72, h * 0.18), w * 0.02, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    // question marks around
    _drawText(canvas, '?', w * 0.25, h * 0.25, w * 0.07, illustration.accent.withOpacity(_minOp(0.3)));
    _drawText(canvas, '?', w * 0.78, h * 0.55, w * 0.06, illustration.accent.withOpacity(_minOp(0.25)));
  }

  void _drawHalf(Canvas canvas, Size size) {
    // 半圆/对半分
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45, r = w * 0.22;
    // left half filled
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 2), pi * 0.5, pi, true, Paint()..color = _dc(illustration.accent));
    // right half outline
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 2), -pi * 0.5, pi, true, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    // dividing line
    _drawLine(canvas, cx, cy - r, cx, cy + r, Paint()..color = _dc(illustration.accent)..strokeWidth = 3);
    // 1/2 label
    _drawText(canvas, '1/2', cx, cy, w * 0.08, Colors.white);
  }

  void _drawHappen(Canvas canvas, Size size) {
    // 惊叹号 + 礼花
    final w = size.width, h = size.height;
    // exclamation mark
    _drawRoundedRectAt(canvas, w * 0.44, h * 0.2, w * 0.12, h * 0.35, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(w * 0.5, h * 0.65), w * 0.04, Paint()..color = _dc(illustration.accent));
    // sparkles
    _drawStarShape(canvas, w * 0.25, h * 0.3, w * 0.06, w * 0.025, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    _drawStarShape(canvas, w * 0.78, h * 0.25, w * 0.05, w * 0.02, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    _drawStarShape(canvas, w * 0.72, h * 0.6, w * 0.04, w * 0.015, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    // ring
    canvas.drawCircle(Offset(w * 0.3, h * 0.6), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  void _drawHard(Canvas canvas, Size size) {
    // 岩石/坚固
    final w = size.width, h = size.height;
    // rock shape
    final rock = Path()
      ..moveTo(w * 0.2, h * 0.65)
      ..lineTo(w * 0.25, h * 0.35)
      ..lineTo(w * 0.4, h * 0.25)
      ..lineTo(w * 0.6, h * 0.2)
      ..lineTo(w * 0.75, h * 0.3)
      ..lineTo(w * 0.8, h * 0.55)
      ..lineTo(w * 0.78, h * 0.65)
      ..close();
    canvas.drawPath(rock, Paint()..color = _dc(illustration.accent));
    // crack lines
    _drawLine(canvas, w * 0.45, h * 0.28, w * 0.5, h * 0.42, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 1.5);
    _drawLine(canvas, w * 0.5, h * 0.42, w * 0.48, h * 0.55, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 1.5);
    // impact lines
    _drawLine(canvas, w * 0.3, h * 0.2, w * 0.25, h * 0.15, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 2);
    _drawLine(canvas, w * 0.7, h * 0.18, w * 0.75, h * 0.13, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 2);
  }

  void _drawHate(Canvas canvas, Size size) {
    // 破碎的心
    final w = size.width, h = size.height;
    // broken heart
    final cx = w * 0.5, cy = h * 0.45;
    final hw = w * 0.2, hh = h * 0.18;
    // left half
    final left = Path()
      ..moveTo(cx - 2, cy + hh * 0.6)
      ..cubicTo(cx - hw * 1.2, cy - hh * 0.2, cx - hw * 0.5, cy - hh, cx - 2, cy - hh * 0.35)
      ..lineTo(cx - 2, cy + hh * 0.6)
      ..close();
    canvas.drawPath(left, Paint()..color = _dc(illustration.accent));
    // right half (slightly shifted)
    final right = Path()
      ..moveTo(cx + 4, cy + hh * 0.65)
      ..cubicTo(cx + hw * 1.2, cy - hh * 0.2, cx + hw * 0.5, cy - hh, cx + 4, cy - hh * 0.3)
      ..lineTo(cx + 4, cy + hh * 0.65)
      ..close();
    canvas.drawPath(right, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // crack line
    _drawLine(canvas, cx - 2, cy - hh * 0.35, cx + 2, cy - hh * 0.1, Paint()..color = _dc(illustration.bg)..strokeWidth = 2);
    _drawLine(canvas, cx + 2, cy - hh * 0.1, cx - 1, cy + hh * 0.15, Paint()..color = _dc(illustration.bg)..strokeWidth = 2);
    _drawLine(canvas, cx - 1, cy + hh * 0.15, cx + 3, cy + hh * 0.4, Paint()..color = _dc(illustration.bg)..strokeWidth = 2);
  }

  void _drawHave(Canvas canvas, Size size) {
    // 双手捧着/拥有
    final w = size.width, h = size.height;
    // cupped hands
    final left = Path()
      ..moveTo(w * 0.25, h * 0.65)
      ..quadraticBezierTo(w * 0.2, h * 0.45, w * 0.35, h * 0.4)
      ..quadraticBezierTo(w * 0.45, h * 0.38, w * 0.5, h * 0.42);
    canvas.drawPath(left, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round);
    final right = Path()
      ..moveTo(w * 0.75, h * 0.65)
      ..quadraticBezierTo(w * 0.8, h * 0.45, w * 0.65, h * 0.4)
      ..quadraticBezierTo(w * 0.55, h * 0.38, w * 0.5, h * 0.42);
    canvas.drawPath(right, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round);
    // heart in hands
    _drawHeartShape(canvas, w * 0.5, h * 0.38, w * 0.1, h * 0.1, Paint()..color = _dc(illustration.accent));
  }

  void _drawHeavy(Canvas canvas, Size size) {
    // 重物/杠铃
    final w = size.width, h = size.height;
    // bar
    _drawLine(canvas, w * 0.15, h * 0.45, w * 0.85, h * 0.45, Paint()..color = _dc(illustration.accent)..strokeWidth = 3);
    // left weights
    _drawRoundedRectAt(canvas, w * 0.12, h * 0.3, w * 0.08, h * 0.3, Paint()..color = _dc(illustration.accent));
    _drawRoundedRectAt(canvas, w * 0.2, h * 0.33, w * 0.06, h * 0.24, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // right weights
    _drawRoundedRectAt(canvas, w * 0.8, h * 0.3, w * 0.08, h * 0.3, Paint()..color = _dc(illustration.accent));
    _drawRoundedRectAt(canvas, w * 0.74, h * 0.33, w * 0.06, h * 0.24, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // weight label
    _drawText(canvas, 'KG', w * 0.5, h * 0.7, w * 0.08, illustration.accent.withOpacity(_minOp(0.4)));
    // ground shake lines
    _drawLine(canvas, w * 0.35, h * 0.82, w * 0.42, h * 0.82, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 2);
    _drawLine(canvas, w * 0.55, h * 0.84, w * 0.65, h * 0.84, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15))..strokeWidth = 2);
  }

  void _drawHide(Canvas canvas, Size size) {
    // 躲在物体后面
    final w = size.width, h = size.height;
    // wall/obstacle
    _drawRoundedRectAt(canvas, w * 0.4, h * 0.25, w * 0.25, h * 0.5, Paint()..color = _dc(illustration.accent));
    // eyes peeking from behind
    canvas.drawCircle(Offset(w * 0.33, h * 0.4), w * 0.03, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.33, h * 0.4), w * 0.015, Paint()..color = Colors.black);
    // partial head
    canvas.drawCircle(Offset(w * 0.32, h * 0.42), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // shadow
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.52, h * 0.82), width: w * 0.3, height: h * 0.04), Paint()..color = Colors.black.withOpacity(0.06));
  }

  void _drawHigh(Canvas canvas, Size size) {
    // 高塔/向上箭头
    final w = size.width, h = size.height;
    // arrow going up
    final ap = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round;
    final arrow = Path()
      ..moveTo(w * 0.5, h * 0.8)
      ..lineTo(w * 0.5, h * 0.2)
      ..moveTo(w * 0.35, h * 0.35)
      ..lineTo(w * 0.5, h * 0.18)
      ..lineTo(w * 0.65, h * 0.35);
    canvas.drawPath(arrow, ap);
    // height marks
    for (int i = 0; i < 4; i++) {
      final y = h * (0.75 - i * 0.15);
      _drawLine(canvas, w * 0.62, y, w * 0.68, y, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5);
    }
    // cloud at top
    canvas.drawCircle(Offset(w * 0.35, h * 0.15), w * 0.05, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    canvas.drawCircle(Offset(w * 0.4, h * 0.13), w * 0.04, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.12)));
  }

  void _drawHold(Canvas canvas, Size size) {
    // 双手握住
    final w = size.width, h = size.height;
    // object being held (cylinder)
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.38, h * 0.25, w * 0.24, h * 0.35), Radius.circular(w * 0.04)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // left hand
    final lh = Path()
      ..moveTo(w * 0.33, h * 0.7)
      ..quadraticBezierTo(w * 0.28, h * 0.55, w * 0.35, h * 0.42)
      ..lineTo(w * 0.38, h * 0.42)
      ..quadraticBezierTo(w * 0.32, h * 0.55, w * 0.36, h * 0.7)
      ..close();
    canvas.drawPath(lh, Paint()..color = _dc(illustration.accent));
    // right hand
    final rh = Path()
      ..moveTo(w * 0.67, h * 0.7)
      ..quadraticBezierTo(w * 0.72, h * 0.55, w * 0.65, h * 0.42)
      ..lineTo(w * 0.62, h * 0.42)
      ..quadraticBezierTo(w * 0.68, h * 0.55, w * 0.64, h * 0.7)
      ..close();
    canvas.drawPath(rh, Paint()..color = _dc(illustration.accent));
    // grip lines
    _drawLine(canvas, w * 0.4, h * 0.38, w * 0.6, h * 0.38, Paint()..color = Colors.white.withOpacity(0.3)..strokeWidth = 1.5);
    _drawLine(canvas, w * 0.4, h * 0.44, w * 0.6, h * 0.44, Paint()..color = Colors.white.withOpacity(0.2)..strokeWidth = 1.5);
  }


  void _drawGoToBed(Canvas canvas, Size size) {
    // 上床睡觉：bed with pillow + moon
    final w = size.width, h = size.height;
    // bed frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.15, h * 0.5, w * 0.7, h * 0.2), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
    // mattress
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.18, h * 0.45, w * 0.64, h * 0.12), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)),
    );
    // pillow
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.2, h * 0.42, w * 0.2, h * 0.1), Radius.circular(w * 0.04)),
      Paint()..color = Colors.white.withOpacity(0.8),
    );
    // blanket
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.42, h * 0.45, w * 0.38, h * 0.12), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)),
    );
    // bed legs
    canvas.drawRect(Rect.fromLTWH(w * 0.18, h * 0.7, w * 0.04, h * 0.1), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    canvas.drawRect(Rect.fromLTWH(w * 0.78, h * 0.7, w * 0.04, h * 0.1), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // moon
    final moonPaint = Paint()..color = Colors.amber.shade300;
    canvas.drawCircle(Offset(w * 0.75, h * 0.18), w * 0.09, moonPaint);
    canvas.drawCircle(Offset(w * 0.8, h * 0.16), w * 0.08, Paint()..color = _dc(illustration.bg));
    // stars
    final starPaint = Paint()..color = Colors.amber.shade200;
    canvas.drawCircle(Offset(w * 0.3, h * 0.12), w * 0.015, starPaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.08), w * 0.01, starPaint);
    canvas.drawCircle(Offset(w * 0.6, h * 0.2), w * 0.012, starPaint);
  }

  void _drawGoToSleep(Canvas canvas, Size size) {
    // 入睡：closed eyes + zzz
    final w = size.width, h = size.height;
    // face circle
    canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.28, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
    // closed eyes - two arcs
    final eyeL = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    final eyeR = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.38, h * 0.45), width: w * 0.12, height: w * 0.06), 0, pi, false, eyeL);
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.62, h * 0.45), width: w * 0.12, height: w * 0.06), 0, pi, false, eyeR);
    // small smile
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.5, h * 0.58), width: w * 0.1, height: w * 0.05), 0.2, pi - 0.4, false, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 2.5);
    // blush
    canvas.drawCircle(Offset(w * 0.32, h * 0.54), w * 0.035, Paint()..color = Colors.pink.withOpacity(0.2));
    canvas.drawCircle(Offset(w * 0.68, h * 0.54), w * 0.035, Paint()..color = Colors.pink.withOpacity(0.2));
    // zzz
    _drawText(canvas, 'z', w * 0.68, h * 0.18, w * 0.06, illustration.accent);
    _drawText(canvas, 'Z', w * 0.74, h * 0.1, w * 0.09, illustration.accent);
    _drawText(canvas, 'Z', w * 0.82, h * 0.02, w * 0.12, illustration.accent);
  }

  void _drawGold(Canvas canvas, Size size) {
    // 金色/黄金：gold bar shape, shiny
    final w = size.width, h = size.height;
    final barPaint = Paint()..color = Colors.amber.shade600;
    final barHighlight = Paint()..color = Colors.amber.shade300;
    // main bar body - trapezoid shape
    final bar = Path()
      ..moveTo(w * 0.2, h * 0.6)
      ..lineTo(w * 0.3, h * 0.35)
      ..lineTo(w * 0.7, h * 0.35)
      ..lineTo(w * 0.8, h * 0.6)
      ..close();
    canvas.drawPath(bar, barPaint);
    // top face
    final topFace = Path()
      ..moveTo(w * 0.3, h * 0.35)
      ..lineTo(w * 0.5, h * 0.25)
      ..lineTo(w * 0.9, h * 0.25)
      ..lineTo(w * 0.7, h * 0.35)
      ..close();
    canvas.drawPath(topFace, barHighlight);
    // right face
    final rightFace = Path()
      ..moveTo(w * 0.7, h * 0.35)
      ..lineTo(w * 0.9, h * 0.25)
      ..lineTo(w * 0.9, h * 0.5)
      ..lineTo(w * 0.8, h * 0.6)
      ..close();
    canvas.drawPath(rightFace, Paint()..color = Colors.amber.shade800);
    // shine line
    _drawLine(canvas, w * 0.35, h * 0.42, w * 0.45, h * 0.42, Paint()..color = Colors.white.withOpacity(0.5)..strokeWidth = 2..strokeCap = StrokeCap.round);
    _drawLine(canvas, w * 0.38, h * 0.48, w * 0.44, h * 0.48, Paint()..color = Colors.white.withOpacity(0.3)..strokeWidth = 1.5..strokeCap = StrokeCap.round);
    // sparkle
    _drawStarShape(canvas, w * 0.78, h * 0.15, w * 0.05, w * 0.02, 4, Paint()..color = Colors.amber.shade200);
  }

  void _drawHaveGot(Canvas canvas, Size size) {
    // 拥有：two hands holding a gift box
    final w = size.width, h = size.height;
    // gift box
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.3, h * 0.3, w * 0.4, h * 0.3), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)),
    );
    // ribbon vertical
    canvas.drawRect(Rect.fromLTWH(w * 0.47, h * 0.3, w * 0.06, h * 0.3), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    // ribbon horizontal
    canvas.drawRect(Rect.fromLTWH(w * 0.3, h * 0.42, w * 0.4, h * 0.06), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    // bow on top
    final bowPaint = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6));
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.45, h * 0.26), width: w * 0.1, height: w * 0.07), bowPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.55, h * 0.26), width: w * 0.1, height: w * 0.07), bowPaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.28), w * 0.025, Paint()..color = _dc(illustration.accent));
    // left hand
    final lh = Path()
      ..moveTo(w * 0.2, h * 0.85)
      ..quadraticBezierTo(w * 0.15, h * 0.65, w * 0.28, h * 0.55)
      ..lineTo(w * 0.32, h * 0.6)
      ..quadraticBezierTo(w * 0.22, h * 0.68, w * 0.25, h * 0.85)
      ..close();
    canvas.drawPath(lh, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // right hand
    final rh = Path()
      ..moveTo(w * 0.8, h * 0.85)
      ..quadraticBezierTo(w * 0.85, h * 0.65, w * 0.72, h * 0.55)
      ..lineTo(w * 0.68, h * 0.6)
      ..quadraticBezierTo(w * 0.78, h * 0.68, w * 0.75, h * 0.85)
      ..close();
    canvas.drawPath(rh, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
  }

  void _drawHer(Canvas canvas, Size size) {
    // 她的：female silhouette with hair
    final w = size.width, h = size.height;
    _drawStickFigure(canvas, w * 0.5, h * 0.55, w * 0.35, illustration.accent,
      headR: w * 0.1, bodyEndY: h * 0.78, leftArmAngle: 0.3, rightArmAngle: -0.3, armLen: w * 0.15,
      leftLegAngle: 0.35, rightLegAngle: -0.35, legLen: w * 0.18, bodyTopY: h * 0.32,
    );
    // hair - long flowing
    final hairPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7))..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    // left hair
    final lh = Path()
      ..moveTo(w * 0.38, h * 0.2)
      ..quadraticBezierTo(w * 0.3, h * 0.25, w * 0.28, h * 0.45);
    canvas.drawPath(lh, hairPaint);
    // right hair
    final rh = Path()
      ..moveTo(w * 0.62, h * 0.2)
      ..quadraticBezierTo(w * 0.7, h * 0.25, w * 0.72, h * 0.45);
    canvas.drawPath(rh, hairPaint);
    // hair volume top
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.5, h * 0.18), width: w * 0.28, height: w * 0.12), pi, pi, false, hairPaint);
    // bow/ribbon in hair
    final bowPaint = Paint()..color = Colors.pinkAccent.withOpacity(0.6);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.62, h * 0.14), width: w * 0.06, height: w * 0.04), bowPaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.68, h * 0.14), width: w * 0.06, height: w * 0.04), bowPaint);
  }

  void _drawHis(Canvas canvas, Size size) {
    // 他的：male silhouette
    final w = size.width, h = size.height;
    _drawStickFigure(canvas, w * 0.5, h * 0.5, w * 0.38, illustration.accent,
      headR: w * 0.1, bodyEndY: h * 0.75, leftArmAngle: 0.4, rightArmAngle: -0.4, armLen: w * 0.17,
      leftLegAngle: 0.3, rightLegAngle: -0.3, legLen: w * 0.2, bodyTopY: h * 0.28,
    );
    // short hair - just a cap-like arc
    final hairPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..style = PaintingStyle.stroke..strokeWidth = 3.5..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.5, h * 0.14), width: w * 0.26, height: w * 0.14), pi + 0.3, pi - 0.6, false, hairPaint);
    // small tie
    final tiePath = Path()
      ..moveTo(w * 0.5, h * 0.32)
      ..lineTo(w * 0.46, h * 0.38)
      ..lineTo(w * 0.5, h * 0.45)
      ..lineTo(w * 0.54, h * 0.38)
      ..close();
    canvas.drawPath(tiePath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
  }

  void _drawHope(Canvas canvas, Size size) {
    // 希望：sunrise with light rays
    final w = size.width, h = size.height;
    // horizon line
    _drawLine(canvas, w * 0.05, h * 0.65, w * 0.95, h * 0.65, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 2);
    // sun circle (rising)
    canvas.drawCircle(Offset(w * 0.5, h * 0.55), w * 0.15, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // glow around sun
    canvas.drawCircle(Offset(w * 0.5, h * 0.55), w * 0.2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    canvas.drawCircle(Offset(w * 0.5, h * 0.55), w * 0.25, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.08)));
    // rays
    final rayPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = -pi / 2 + (i - 3.5) * 0.3;
      final r1 = w * 0.2;
      final r2 = w * 0.32;
      final cx = w * 0.5, cy = h * 0.55;
      canvas.drawLine(
        Offset(cx + cos(angle) * r1, cy + sin(angle) * r1),
        Offset(cx + cos(angle) * r2, cy + sin(angle) * r2),
        rayPaint,
      );
    }
    // ground below horizon
    canvas.drawRect(Rect.fromLTWH(0, h * 0.65, w, h * 0.35), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
  }

  void _drawHorrible(Canvas canvas, Size size) {
    // 可怕的：monster face with sharp teeth
    final w = size.width, h = size.height;
    // monster head
    final headPath = Path()
      ..moveTo(w * 0.15, h * 0.5)
      ..quadraticBezierTo(w * 0.1, h * 0.15, w * 0.35, h * 0.1)
      ..lineTo(w * 0.4, h * 0.05)
      ..lineTo(w * 0.5, h * 0.12)
      ..lineTo(w * 0.6, h * 0.05)
      ..lineTo(w * 0.65, h * 0.1)
      ..quadraticBezierTo(w * 0.9, h * 0.15, w * 0.85, h * 0.5)
      ..quadraticBezierTo(w * 0.8, h * 0.85, w * 0.5, h * 0.9)
      ..quadraticBezierTo(w * 0.2, h * 0.85, w * 0.15, h * 0.5)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // angry eyes
    _drawFace(canvas, w * 0.5, h * 0.45, w * 0.3, illustration.accent, hasAngryBrows: true, smileFactor: -1);
    // sharp teeth
    final teethPaint = Paint()..color = Colors.white;
    for (int i = 0; i < 5; i++) {
      final tx = w * (0.32 + i * 0.09);
      final toothPath = Path()
        ..moveTo(tx - w * 0.03, h * 0.62)
        ..lineTo(tx, h * 0.72 + (i.isEven ? w * 0.03 : 0))
        ..lineTo(tx + w * 0.03, h * 0.62)
        ..close();
      canvas.drawPath(toothPath, teethPaint);
    }
    // horns
    final hornPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8));
    final hornL = Path()
      ..moveTo(w * 0.3, h * 0.15)
      ..lineTo(w * 0.2, h * 0.02)
      ..lineTo(w * 0.35, h * 0.12)
      ..close();
    canvas.drawPath(hornL, hornPaint);
    final hornR = Path()
      ..moveTo(w * 0.7, h * 0.15)
      ..lineTo(w * 0.8, h * 0.02)
      ..lineTo(w * 0.65, h * 0.12)
      ..close();
    canvas.drawPath(hornR, hornPaint);
  }

  void _drawHuge(Canvas canvas, Size size) {
    // 巨大的：elephant silhouette
    final w = size.width, h = size.height;
    final elephantPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    // body
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.45, h * 0.5), width: w * 0.55, height: h * 0.35), elephantPaint);
    // head
    canvas.drawCircle(Offset(w * 0.72, h * 0.38), w * 0.15, elephantPaint);
    // ear
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.82, h * 0.3), width: w * 0.14, height: w * 0.18), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // trunk
    final trunk = Path()
      ..moveTo(w * 0.82, h * 0.42)
      ..quadraticBezierTo(w * 0.9, h * 0.55, w * 0.85, h * 0.7)
      ..quadraticBezierTo(w * 0.83, h * 0.72, w * 0.81, h * 0.68)
      ..quadraticBezierTo(w * 0.85, h * 0.55, w * 0.78, h * 0.44)
      ..close();
    canvas.drawPath(trunk, elephantPaint);
    // legs
    for (int i = 0; i < 4; i++) {
      final lx = w * (0.25 + i * 0.13);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(lx, h * 0.62, w * 0.07, h * 0.22), Radius.circular(w * 0.02)),
        elephantPaint,
      );
    }
    // eye
    canvas.drawCircle(Offset(w * 0.75, h * 0.35), w * 0.02, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.755, h * 0.35), w * 0.01, Paint()..color = Colors.black);
    // tusk
    final tusk = Path()
      ..moveTo(w * 0.78, h * 0.46)
      ..quadraticBezierTo(w * 0.82, h * 0.56, w * 0.76, h * 0.6)
      ..lineTo(w * 0.76, h * 0.48)
      ..close();
    canvas.drawPath(tusk, Paint()..color = Colors.white.withOpacity(0.8));
  }

  void _drawHurry(Canvas canvas, Size size) {
    // 匆忙：running figure with speed lines
    final w = size.width, h = size.height;
    _drawStickFigure(canvas, w * 0.55, h * 0.5, w * 0.3, illustration.accent,
      headR: w * 0.08, bodyEndY: h * 0.62,
      leftArmAngle: -0.8, rightArmAngle: 0.6, armLen: w * 0.14,
      leftLegAngle: 0.7, rightLegAngle: -0.5, legLen: w * 0.18, bodyTopY: h * 0.3,
    );
    // speed lines
    final speedPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.1, h * 0.35, w * 0.3, h * 0.35, speedPaint);
    _drawLine(canvas, w * 0.08, h * 0.45, w * 0.28, h * 0.45, speedPaint..strokeWidth = 2);
    _drawLine(canvas, w * 0.12, h * 0.55, w * 0.32, h * 0.55, speedPaint..strokeWidth = 1.5);
    // motion blur circles
    canvas.drawCircle(Offset(w * 0.15, h * 0.42), w * 0.02, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.1)));
    canvas.drawCircle(Offset(w * 0.1, h * 0.5), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.08)));
    // dust particles
    final dustPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2));
    canvas.drawCircle(Offset(w * 0.35, h * 0.78), w * 0.02, dustPaint);
    canvas.drawCircle(Offset(w * 0.3, h * 0.82), w * 0.015, dustPaint);
    canvas.drawCircle(Offset(w * 0.4, h * 0.85), w * 0.01, dustPaint);
  }

  void _drawIll(Canvas canvas, Size size) {
    // 生病的：sick face with thermometer
    final w = size.width, h = size.height;
    // face
    canvas.drawCircle(Offset(w * 0.45, h * 0.45), w * 0.22, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25)));
    _drawFace(canvas, w * 0.45, h * 0.45, w * 0.2, illustration.accent, smileFactor: -0.5, hasTears: true);
    // thermometer in mouth area
    final thermoPaint = Paint()..color = Colors.grey.shade400..style = PaintingStyle.stroke..strokeWidth = 2.5;
    // tube
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.62, h * 0.2, w * 0.04, h * 0.35), Radius.circular(w * 0.02)),
      thermoPaint,
    );
    // bulb at bottom
    canvas.drawCircle(Offset(w * 0.64, h * 0.57), w * 0.035, Paint()..color = Colors.red.shade400);
    // mercury column
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.63, h * 0.32, w * 0.02, h * 0.23), Radius.circular(w * 0.01)),
      Paint()..color = Colors.red.shade400,
    );
    // fever marks (on forehead)
    _drawLine(canvas, w * 0.3, h * 0.18, w * 0.25, h * 0.1, Paint()..color = Colors.red.withOpacity(0.3)..strokeWidth = 2..strokeCap = StrokeCap.round);
    _drawLine(canvas, w * 0.38, h * 0.15, w * 0.36, h * 0.06, Paint()..color = Colors.red.withOpacity(0.3)..strokeWidth = 2..strokeCap = StrokeCap.round);
    _drawLine(canvas, w * 0.46, h * 0.14, w * 0.46, h * 0.05, Paint()..color = Colors.red.withOpacity(0.3)..strokeWidth = 2..strokeCap = StrokeCap.round);
    // pills
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.1, h * 0.75, w * 0.12, h * 0.06), Radius.circular(w * 0.03)),
      Paint()..color = Colors.blue.withOpacity(0.4),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.78, h * 0.78, w * 0.1, h * 0.05), Radius.circular(w * 0.025)),
      Paint()..color = Colors.orange.withOpacity(0.4),
    );
  }

  void _drawImportant(Canvas canvas, Size size) {
    // 重要的：star with exclamation mark
    final w = size.width, h = size.height;
    // large star
    _drawStarShape(canvas, w * 0.5, h * 0.45, w * 0.3, w * 0.13, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // inner glow
    _drawStarShape(canvas, w * 0.5, h * 0.45, w * 0.2, w * 0.09, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
    // exclamation mark
    final exclPaint = Paint()..color = Colors.white;
    // vertical line
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.47, h * 0.25, w * 0.06, h * 0.22), Radius.circular(w * 0.03)),
      exclPaint,
    );
    // dot
    canvas.drawCircle(Offset(w * 0.5, h * 0.55), w * 0.035, exclPaint);
    // small sparkles around star
    final sparklePaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4));
    _drawStarShape(canvas, w * 0.2, h * 0.2, w * 0.04, w * 0.015, 4, sparklePaint);
    _drawStarShape(canvas, w * 0.82, h * 0.25, w * 0.035, w * 0.012, 4, sparklePaint);
    _drawStarShape(canvas, w * 0.15, h * 0.7, w * 0.03, w * 0.01, 4, sparklePaint);
    _drawStarShape(canvas, w * 0.85, h * 0.72, w * 0.03, w * 0.01, 4, sparklePaint);
  }

  void _drawImprove(Canvas canvas, Size size) {
    // 改善：upward trending arrow
    final w = size.width, h = size.height;
    // chart background - subtle grid
    final gridPaint = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.08))..strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      final y = h * (0.3 + i * 0.15);
      _drawLine(canvas, w * 0.1, y, w * 0.9, y, gridPaint);
    }
    // upward trend line
    final trendPaint = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3.5..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final trendPath = Path()
      ..moveTo(w * 0.15, h * 0.75)
      ..lineTo(w * 0.35, h * 0.6)
      ..lineTo(w * 0.5, h * 0.55)
      ..lineTo(w * 0.65, h * 0.38)
      ..lineTo(w * 0.85, h * 0.2);
    canvas.drawPath(trendPath, trendPaint);
    // arrowhead
    final arrowHead = Path()
      ..moveTo(w * 0.75, h * 0.2)
      ..lineTo(w * 0.87, h * 0.18)
      ..lineTo(w * 0.83, h * 0.3)
      ..close();
    canvas.drawPath(arrowHead, Paint()..color = _dc(illustration.accent));
    // data points
    final dotPaint = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(w * 0.15, h * 0.75), w * 0.025, dotPaint);
    canvas.drawCircle(Offset(w * 0.35, h * 0.6), w * 0.025, dotPaint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.55), w * 0.025, dotPaint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.38), w * 0.025, dotPaint);
    canvas.drawCircle(Offset(w * 0.85, h * 0.2), w * 0.025, dotPaint);
    // highlight glow at end
    canvas.drawCircle(Offset(w * 0.85, h * 0.2), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
  }

  void _drawInterested(Canvas canvas, Size size) {
    // ear with a question mark
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // ear shape
    final ear = Path()
      ..moveTo(w * 0.5, h * 0.2)
      ..quadraticBezierTo(w * 0.7, h * 0.2, w * 0.72, h * 0.45)
      ..quadraticBezierTo(w * 0.73, h * 0.65, w * 0.6, h * 0.72)
      ..quadraticBezierTo(w * 0.5, h * 0.76, w * 0.45, h * 0.7)
      ..quadraticBezierTo(w * 0.38, h * 0.6, w * 0.42, h * 0.45)
      ..quadraticBezierTo(w * 0.44, h * 0.3, w * 0.5, h * 0.2)
      ..close();
    canvas.drawPath(ear, paint);
    // inner ear
    canvas.drawCircle(Offset(w * 0.53, h * 0.48), w * 0.08, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    // question mark
    final qm = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.3, h * 0.45), radius: w * 0.08), -pi * 0.3, pi * 1.6, false, qm);
    canvas.drawCircle(Offset(w * 0.3, h * 0.62), w * 0.015, Paint()..color = _dc(illustration.accent));
  }

  void _drawInteresting(Canvas canvas, Size size) {
    // lightbulb (idea)
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // bulb
    canvas.drawCircle(Offset(w * 0.5, h * 0.35), w * 0.18, paint);
    // base of bulb
    final base = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.42, h * 0.5, w * 0.16, h * 0.08), Radius.circular(3));
    canvas.drawRRect(base, paint);
    final base2 = RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.44, h * 0.57, w * 0.12, h * 0.06), Radius.circular(3));
    canvas.drawRRect(base2, paint);
    // filament inside
    final filament = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.46, h * 0.7), Offset(w * 0.46, h * 0.65), filament);
    canvas.drawLine(Offset(w * 0.54, h * 0.7), Offset(w * 0.54, h * 0.65), filament);
    // rays
    final ray = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 6; i++) {
      final angle = -pi / 2 + i * pi / 5 - pi * 0.4;
      final r1 = w * 0.22;
      final r2 = w * 0.28;
      canvas.drawLine(Offset(w * 0.5 + cos(angle) * r1, h * 0.35 + sin(angle) * r1), Offset(w * 0.5 + cos(angle) * r2, h * 0.35 + sin(angle) * r2), ray);
    }
  }

  void _drawInvent(Canvas canvas, Size size) {
    // gears and a lightbulb
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // gear 1
    _drawGear(canvas, w * 0.35, h * 0.5, w * 0.12, 8, paint);
    // gear 2 smaller
    _drawGear(canvas, w * 0.58, h * 0.42, w * 0.08, 6, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // small lightbulb on top
    canvas.drawCircle(Offset(w * 0.5, h * 0.22), w * 0.08, paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.46, h * 0.29, w * 0.08, h * 0.04), Radius.circular(2)), paint);
    // rays from bulb
    final ray = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final angle = -pi / 2 + i * pi / 3 - pi / 3;
      canvas.drawLine(Offset(w * 0.5 + cos(angle) * w * 0.1, h * 0.22 + sin(angle) * w * 0.1), Offset(w * 0.5 + cos(angle) * w * 0.14, h * 0.22 + sin(angle) * w * 0.14), ray);
    }
  }

  void _drawInvite(Canvas canvas, Size size) {
    // envelope with a heart
    final w = size.width, h = size.height;
    final envPaint = Paint()..color = _dc(illustration.accent);
    // envelope body
    final env = Path()
      ..moveTo(w * 0.2, h * 0.35)
      ..lineTo(w * 0.8, h * 0.35)
      ..lineTo(w * 0.8, h * 0.7)
      ..lineTo(w * 0.2, h * 0.7)
      ..close();
    canvas.drawPath(env, envPaint);
    // envelope flap
    final flap = Path()
      ..moveTo(w * 0.2, h * 0.35)
      ..lineTo(w * 0.5, h * 0.55)
      ..lineTo(w * 0.8, h * 0.35)
      ..close();
    canvas.drawPath(flap, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // heart on envelope
    _drawHeartShape(canvas, w * 0.5, h * 0.52, w * 0.07, h * 0.06, Paint()..color = Colors.white.withOpacity(0.9));
  }

  void _drawIts(Canvas canvas, Size size) {
    // paw print
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // main pad
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.55), width: w * 0.22, height: h * 0.2), paint);
    // toe pads
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.37, h * 0.38), width: w * 0.1, height: h * 0.1), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.33), width: w * 0.1, height: h * 0.1), paint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.63, h * 0.38), width: w * 0.1, height: h * 0.1), paint);
    // small pad at bottom
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.68), width: w * 0.12, height: h * 0.08), paint);
  }

  void _drawKeep(Canvas canvas, Size size) {
    // box with a lid
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // box body
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.25, h * 0.42, w * 0.5, h * 0.3), Radius.circular(w * 0.03)), paint);
    // lid
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.22, h * 0.34, w * 0.56, h * 0.12), Radius.circular(w * 0.03)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    // lock
    canvas.drawCircle(Offset(w * 0.5, h * 0.56), w * 0.04, Paint()..color = Colors.white.withOpacity(0.8));
    canvas.drawCircle(Offset(w * 0.5, h * 0.56), w * 0.025, Paint()..color = _dc(illustration.accent));
    // keyhole
    canvas.drawCircle(Offset(w * 0.5, h * 0.565), w * 0.01, Paint()..color = Colors.white.withOpacity(0.8));
  }

  void _drawKind(Canvas canvas, Size size) {
    // two hearts (kindness)
    final w = size.width, h = size.height;
    _drawHeartShape(canvas, w * 0.38, h * 0.42, w * 0.13, h * 0.11, Paint()..color = _dc(illustration.accent));
    _drawHeartShape(canvas, w * 0.6, h * 0.48, w * 0.1, h * 0.08, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // small sparkles
    final spark = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.25, h * 0.28), Offset(w * 0.25, h * 0.22), spark);
    canvas.drawLine(Offset(w * 0.22, h * 0.25), Offset(w * 0.28, h * 0.25), spark);
    canvas.drawLine(Offset(w * 0.75, h * 0.32), Offset(w * 0.75, h * 0.27), spark);
    canvas.drawLine(Offset(w * 0.72, h * 0.3), Offset(w * 0.78, h * 0.3), spark);
  }

  void _drawLarge(Canvas canvas, Size size) {
    // big circle with arrows expanding outward
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.18, paint);
    // expansion arrows
    final arrow = Paint()..color = Colors.white.withOpacity(0.7)..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    // top arrow
    _drawArrowLine(canvas, w * 0.5, h * 0.25, w * 0.5, h * 0.15, arrow);
    // bottom arrow
    _drawArrowLine(canvas, w * 0.5, h * 0.7, w * 0.5, h * 0.8, arrow);
    // left arrow
    _drawArrowLine(canvas, w * 0.28, h * 0.48, w * 0.18, h * 0.48, arrow);
    // right arrow
    _drawArrowLine(canvas, w * 0.72, h * 0.48, w * 0.82, h * 0.48, arrow);
  }

  void _drawLast(Canvas canvas, Size size) {
    // finish flag (checkered)
    final w = size.width, h = size.height;
    // pole
    canvas.drawRect(Rect.fromLTWH(w * 0.35, h * 0.2, w * 0.04, h * 0.6), Paint()..color = _dc(illustration.accent));
    // flag
    final flagW = w * 0.35;
    final flagH = h * 0.22;
    final flagX = w * 0.39;
    final flagY = h * 0.2;
    final cellW = flagW / 4;
    final cellH = flagH / 3;
    for (int r = 0; r < 3; r++) {
      for (int c = 0; c < 4; c++) {
        final isDark = (r + c) % 2 == 0;
        canvas.drawRect(Rect.fromLTWH(flagX + c * cellW, flagY + r * cellH, cellW, cellH), Paint()..color = isDark ? illustration.accent : Colors.white.withOpacity(0.85));
      }
    }
    // medal at bottom
    canvas.drawCircle(Offset(w * 0.5, h * 0.82), w * 0.06, Paint()..color = _dc(illustration.accent));
    _drawStarShape(canvas, w * 0.5, h * 0.82, w * 0.04, w * 0.02, 5, Paint()..color = Colors.white.withOpacity(0.8));
  }

  void _drawLate(Canvas canvas, Size size) {
    // clock with hands pointing to late hour
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // clock face
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.22, paint);
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.19, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    // hour marks
    for (int i = 0; i < 12; i++) {
      final angle = i * pi / 6 - pi / 2;
      final r1 = w * 0.16;
      final r2 = w * 0.19;
      canvas.drawLine(Offset(w * 0.5 + cos(angle) * r1, h * 0.45 + sin(angle) * r1), Offset(w * 0.5 + cos(angle) * r2, h * 0.45 + sin(angle) * r2), Paint()..color = Colors.white.withOpacity(0.7)..strokeWidth = 2..strokeCap = StrokeCap.round);
    }
    // hour hand pointing to 11 (late!)
    final hAngle = -pi / 2 + 11 * pi / 6;
    canvas.drawLine(Offset(w * 0.5, h * 0.45), Offset(w * 0.5 + cos(hAngle) * w * 0.1, h * 0.45 + sin(hAngle) * w * 0.1), Paint()..color = Colors.white..strokeWidth = 3..strokeCap = StrokeCap.round);
    // minute hand pointing to 12
    canvas.drawLine(Offset(w * 0.5, h * 0.45), Offset(w * 0.5, h * 0.45 - w * 0.14), Paint()..color = Colors.white.withOpacity(0.8)..strokeWidth = 2..strokeCap = StrokeCap.round);
    // center dot
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.02, Paint()..color = Colors.white);
  }

  void _drawLazy(Canvas canvas, Size size) {
    // reclining figure (lazy)
    final w = size.width, h = size.height;
    final color = _dc(illustration.accent);
    // head
    canvas.drawCircle(Offset(w * 0.3, h * 0.38), w * 0.07, Paint()..color = color);
    // body line (horizontal-ish)
    final body = Paint()..color = color..strokeWidth = 3..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final bodyPath = Path()
      ..moveTo(w * 0.37, h * 0.42)
      ..quadraticBezierTo(w * 0.55, h * 0.4, w * 0.72, h * 0.48);
    canvas.drawPath(bodyPath, body);
    // legs
    canvas.drawLine(Offset(w * 0.68, h * 0.48), Offset(w * 0.6, h * 0.6), body);
    canvas.drawLine(Offset(w * 0.72, h * 0.48), Offset(w * 0.75, h * 0.6), body);
    // arm waving lazily
    canvas.drawLine(Offset(w * 0.45, h * 0.42), Offset(w * 0.42, h * 0.3), body);
    // Zzz
    final zz = Paint()..color = color.withOpacity(0.5)..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.78, h * 0.25, w * 0.83, h * 0.25, zz);
    _drawLine(canvas, w * 0.83, h * 0.25, w * 0.78, h * 0.3, zz);
    _drawLine(canvas, w * 0.78, h * 0.3, w * 0.83, h * 0.3, zz);
    // pillow
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.28, h * 0.44), width: w * 0.12, height: h * 0.06), Paint()..color = color.withOpacity(0.3));
  }

  void _drawLeft(Canvas canvas, Size size) {
    // left arrow
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent)..strokeWidth = 4..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    // arrow shaft
    canvas.drawLine(Offset(w * 0.75, h * 0.5), Offset(w * 0.25, h * 0.5), paint);
    // arrowhead
    final arrowHead = Paint()..color = _dc(illustration.accent);
    final head = Path()
      ..moveTo(w * 0.25, h * 0.5)
      ..lineTo(w * 0.35, h * 0.38)
      ..lineTo(w * 0.35, h * 0.62)
      ..close();
    canvas.drawPath(head, arrowHead);
    // L label
    final tp = _textPainter('L', fontSize: w * 0.12, color: illustration.accent.withOpacity(_minOp(0.3)));
    tp.paint(canvas, Offset(w * 0.55, h * 0.58));
  }

  void _drawLet(Canvas canvas, Size size) {
    // open gate / door
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // gate posts
    canvas.drawRect(Rect.fromLTWH(w * 0.25, h * 0.2, w * 0.05, h * 0.6), paint);
    canvas.drawRect(Rect.fromLTWH(w * 0.7, h * 0.2, w * 0.05, h * 0.6), paint);
    // gate top bar
    canvas.drawRect(Rect.fromLTWH(w * 0.25, h * 0.2, w * 0.5, h * 0.05), paint);
    // gate door (swinging open)
    canvas.save();
    canvas.translate(w * 0.3, h * 0.25);
    canvas.rotate(-0.3);
    final door = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w * 0.35, h * 0.52), Radius.circular(w * 0.02));
    canvas.drawRRect(door, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // door handle
    canvas.drawCircle(Offset(w * 0.28, h * 0.28), w * 0.02, Paint()..color = Colors.white.withOpacity(0.8));
    canvas.restore();
    // sparkles
    final spark = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.78, h * 0.35), Offset(w * 0.78, h * 0.28), spark);
    canvas.drawLine(Offset(w * 0.75, h * 0.32), Offset(w * 0.81, h * 0.32), spark);
  }

  void _drawLets(Canvas canvas, Size size) {
    // two figures walking together
    final w = size.width, h = size.height;
    final color = _dc(illustration.accent);
    // figure 1
    _drawStickFigure(canvas, w * 0.35, h * 0.25, w * 0.28, color, headR: w * 0.06, bodyEndY: h * 0.52, leftArmAngle: -0.5, rightArmAngle: 0.5, armLen: w * 0.1, leftLegAngle: 0.4, rightLegAngle: -0.4, legLen: w * 0.12, bodyTopY: h * 0.35);
    // figure 2
    _drawStickFigure(canvas, w * 0.65, h * 0.25, w * 0.28, color.withOpacity(0.7), headR: w * 0.06, bodyEndY: h * 0.52, leftArmAngle: -0.3, rightArmAngle: 0.7, armLen: w * 0.1, leftLegAngle: 0.3, rightLegAngle: -0.5, legLen: w * 0.12, bodyTopY: h * 0.35);
    // connecting hand gesture (holding hands)
    _drawLine(canvas, w * 0.45, h * 0.45, w * 0.55, h * 0.45, Paint()..color = color.withOpacity(0.5)..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  void _drawLie(Canvas canvas, Size size) {
    // figure lying down
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // pillow
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.3, h * 0.48), width: w * 0.18, height: h * 0.1), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    // head
    canvas.drawCircle(Offset(w * 0.28, h * 0.44), w * 0.07, paint);
    // body (horizontal)
    final body = Paint()..color = paint.color..strokeWidth = 3.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.35, h * 0.48), Offset(w * 0.75, h * 0.48), body);
    // arms resting
    canvas.drawLine(Offset(w * 0.45, h * 0.48), Offset(w * 0.43, h * 0.38), body);
    canvas.drawLine(Offset(w * 0.55, h * 0.48), Offset(w * 0.57, h * 0.38), body);
    // legs
    canvas.drawLine(Offset(w * 0.7, h * 0.48), Offset(w * 0.78, h * 0.55), body);
    canvas.drawLine(Offset(w * 0.72, h * 0.48), Offset(w * 0.82, h * 0.52), body);
    // blanket
    final blanket = Path()
      ..moveTo(w * 0.4, h * 0.44)
      ..quadraticBezierTo(w * 0.6, h * 0.42, w * 0.78, h * 0.46)
      ..lineTo(w * 0.78, h * 0.56)
      ..quadraticBezierTo(w * 0.55, h * 0.58, w * 0.4, h * 0.52)
      ..close();
    canvas.drawPath(blanket, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    // Zzz
    final zz = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.82, h * 0.3, w * 0.86, h * 0.3, zz);
    _drawLine(canvas, w * 0.86, h * 0.3, w * 0.82, h * 0.34, zz);
    _drawLine(canvas, w * 0.82, h * 0.34, w * 0.86, h * 0.34, zz);
  }

  void _drawLift(Canvas canvas, Size size) {
    // arms lifting a weight up
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // figure body
    canvas.drawCircle(Offset(w * 0.5, h * 0.22), w * 0.07, paint);
    final body = Paint()..color = paint.color..strokeWidth = 3..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.5, h * 0.29), Offset(w * 0.5, h * 0.55), body);
    // legs
    canvas.drawLine(Offset(w * 0.5, h * 0.55), Offset(w * 0.4, h * 0.72), body);
    canvas.drawLine(Offset(w * 0.5, h * 0.55), Offset(w * 0.6, h * 0.72), body);
    // arms lifting up (V shape)
    canvas.drawLine(Offset(w * 0.5, h * 0.36), Offset(w * 0.35, h * 0.18), body);
    canvas.drawLine(Offset(w * 0.5, h * 0.36), Offset(w * 0.65, h * 0.18), body);
    // barbell
    canvas.drawLine(Offset(w * 0.3, h * 0.15), Offset(w * 0.7, h * 0.15), Paint()..color = _dc(illustration.accent)..strokeWidth = 3..strokeCap = StrokeCap.round);
    // weights
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.25, h * 0.1, w * 0.08, h * 0.12), Radius.circular(3)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.67, h * 0.1, w * 0.08, h * 0.12), Radius.circular(3)), paint);
  }

  void _drawLittle(Canvas canvas, Size size) {
    // tiny cute circle next to a big one
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // big circle
    canvas.drawCircle(Offset(w * 0.38, h * 0.45), w * 0.18, paint);
    // small circle
    canvas.drawCircle(Offset(w * 0.68, h * 0.55), w * 0.08, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // cute face on small one
    canvas.drawCircle(Offset(w * 0.65, h * 0.53), w * 0.01, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.71, h * 0.53), w * 0.01, Paint()..color = Colors.white);
    // smile
    final smile = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.68, h * 0.56), radius: w * 0.025), 0.2, pi - 0.4, false, smile);
    // comparison arrow
    final arr = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.56, h * 0.5, w * 0.6, h * 0.5, arr);
  }

  void _drawLong(Canvas canvas, Size size) {
    // long horizontal snake-like line
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.04..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final snake = Path()
      ..moveTo(w * 0.1, h * 0.4)
      ..quadraticBezierTo(w * 0.25, h * 0.25, w * 0.4, h * 0.4)
      ..quadraticBezierTo(w * 0.55, h * 0.55, w * 0.7, h * 0.4)
      ..quadraticBezierTo(w * 0.8, h * 0.32, w * 0.9, h * 0.38);
    canvas.drawPath(snake, paint);
    // snake head
    canvas.drawCircle(Offset(w * 0.9, h * 0.38), w * 0.035, Paint()..color = _dc(illustration.accent));
    // eye
    canvas.drawCircle(Offset(w * 0.91, h * 0.365), w * 0.01, Paint()..color = Colors.white);
    // tail
    canvas.drawLine(Offset(w * 0.1, h * 0.4), Offset(w * 0.06, h * 0.36), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 2..strokeCap = StrokeCap.round);
    // length indicator arrows
    final arr = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawArrowLine(canvas, w * 0.15, h * 0.7, w * 0.85, h * 0.7, arr);
    _drawArrowLine(canvas, w * 0.85, h * 0.7, w * 0.15, h * 0.7, arr);
  }

  void _drawLookAfter(Canvas canvas, Size size) {
    // umbrella sheltering something
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // umbrella canopy
    final canopy = Path()
      ..moveTo(w * 0.2, h * 0.45)
      ..quadraticBezierTo(w * 0.5, h * 0.1, w * 0.8, h * 0.45)
      ..close();
    canvas.drawPath(canopy, paint);
    // umbrella handle
    canvas.drawLine(Offset(w * 0.5, h * 0.45), Offset(w * 0.5, h * 0.75), Paint()..color = paint.color..strokeWidth = 3..strokeCap = StrokeCap.round);
    // hook
    final hook = Paint()..color = paint.color..strokeWidth = 3..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.47, h * 0.75), radius: w * 0.04), pi * 0.5, pi, false, hook);
    // small heart under umbrella (being sheltered)
    _drawHeartShape(canvas, w * 0.5, h * 0.55, w * 0.06, h * 0.05, Paint()..color = Colors.white.withOpacity(0.8));
    // raindrops on sides
    final drop = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.15, h * 0.35, w * 0.13, h * 0.45, drop);
    _drawLine(canvas, w * 0.85, h * 0.35, w * 0.87, h * 0.45, drop);
    _drawLine(canvas, w * 0.1, h * 0.5, w * 0.08, h * 0.6, drop);
    _drawLine(canvas, w * 0.9, h * 0.5, w * 0.92, h * 0.6, drop);
  }

  void _drawLookAt(Canvas canvas, Size size) {
    // eye with a focus point
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // eye shape
    final eye = Path()
      ..moveTo(w * 0.2, h * 0.45)
      ..quadraticBezierTo(w * 0.5, h * 0.2, w * 0.8, h * 0.45)
      ..quadraticBezierTo(w * 0.5, h * 0.7, w * 0.2, h * 0.45)
      ..close();
    canvas.drawPath(eye, paint);
    // white of eye
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.13, Paint()..color = Colors.white);
    // iris
    canvas.drawCircle(Offset(w * 0.52, h * 0.45), w * 0.08, Paint()..color = _dc(illustration.accent));
    // pupil
    canvas.drawCircle(Offset(w * 0.53, h * 0.45), w * 0.035, Paint()..color = Colors.black87);
    // highlight
    canvas.drawCircle(Offset(w * 0.55, h * 0.43), w * 0.015, Paint()..color = Colors.white.withOpacity(0.8));
    // focus lines
    final focus = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.65, h * 0.35), Offset(w * 0.72, h * 0.28), focus);
    canvas.drawLine(Offset(w * 0.65, h * 0.45), Offset(w * 0.75, h * 0.45), focus);
    canvas.drawLine(Offset(w * 0.65, h * 0.55), Offset(w * 0.72, h * 0.62), focus);
  }

  void _drawLookFor(Canvas canvas, Size size) {
    // magnifying glass
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // glass circle
    canvas.drawCircle(Offset(w * 0.42, h * 0.4), w * 0.18, paint);
    canvas.drawCircle(Offset(w * 0.42, h * 0.4), w * 0.15, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    // handle
    canvas.drawLine(Offset(w * 0.55, h * 0.53), Offset(w * 0.75, h * 0.73), Paint()..color = paint.color..strokeWidth = 4..strokeCap = StrokeCap.round);
    // sparkle on glass
    final spark = Paint()..color = Colors.white.withOpacity(0.5)..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.35, h * 0.32), Offset(w * 0.33, h * 0.28), spark);
    canvas.drawLine(Offset(w * 0.38, h * 0.3), Offset(w * 0.36, h * 0.26), spark);
    // question mark inside glass
    final qm = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.42, h * 0.4), radius: w * 0.06), -pi * 0.3, pi * 1.5, false, qm);
    canvas.drawCircle(Offset(w * 0.42, h * 0.48), w * 0.012, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
  }

  void _drawLookLike(Canvas canvas, Size size) {
    // two similar shapes side by side
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // shape 1
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.18, h * 0.3, w * 0.22, h * 0.3), Radius.circular(w * 0.04)), paint);
    // shape 2
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.58, h * 0.3, w * 0.22, h * 0.3), Radius.circular(w * 0.04)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // equals sign
    final eq = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 3..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.45, h * 0.4, w * 0.53, h * 0.4, eq);
    _drawLine(canvas, w * 0.45, h * 0.48, w * 0.53, h * 0.48, eq);
    // cute faces on both
    _drawFace(canvas, w * 0.29, h * 0.45, w * 0.04, illustration.accent, smileFactor: 0.8);
    _drawFace(canvas, w * 0.69, h * 0.45, w * 0.04, illustration.accent.withOpacity(_minOp(0.7)), smileFactor: 0.8);
  }

  void _drawLoud(Canvas canvas, Size size) {
    // megaphone / speaker with sound waves
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // speaker body
    final body = Path()
      ..moveTo(w * 0.25, h * 0.4)
      ..lineTo(w * 0.4, h * 0.4)
      ..lineTo(w * 0.55, h * 0.25)
      ..lineTo(w * 0.55, h * 0.65)
      ..lineTo(w * 0.4, h * 0.5)
      ..lineTo(w * 0.25, h * 0.5)
      ..close();
    canvas.drawPath(body, paint);
    // handle
    canvas.drawRect(Rect.fromLTWH(w * 0.22, h * 0.38, w * 0.06, h * 0.14), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // sound waves
    final wave = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35))..strokeWidth = 2.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    for (int i = 1; i <= 3; i++) {
      canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.55, h * 0.45), radius: w * 0.08 * i), -pi * 0.3, pi * 0.6, false, wave);
    }
  }

  void _drawLovely(Canvas canvas, Size size) {
    // heart with flowers around it
    final w = size.width, h = size.height;
    // heart
    _drawHeartShape(canvas, w * 0.5, h * 0.42, w * 0.16, h * 0.14, Paint()..color = _dc(illustration.accent));
    // flowers around
    final flowerColor = illustration.accent.withOpacity(_minOp(0.5));
    _drawFlower(canvas, w * 0.2, h * 0.28, w * 0.04, flowerColor);
    _drawFlower(canvas, w * 0.8, h * 0.3, w * 0.035, flowerColor);
    _drawFlower(canvas, w * 0.25, h * 0.65, w * 0.03, flowerColor);
    _drawFlower(canvas, w * 0.78, h * 0.62, w * 0.035, flowerColor);
    // leaves
    final leaf = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25));
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.18, h * 0.55), width: w * 0.06, height: h * 0.03), leaf);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.82, h * 0.52), width: w * 0.06, height: h * 0.03), leaf);
    // sparkles
    final spark = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.5, h * 0.18), Offset(w * 0.5, h * 0.13), spark);
    canvas.drawLine(Offset(w * 0.47, h * 0.15), Offset(w * 0.53, h * 0.15), spark);
  }

  void _drawLow(Canvas canvas, Size size) {
    // downward arrow near the bottom
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // arrow shaft going down
    final line = Paint()..color = paint.color..strokeWidth = 4..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.5, h * 0.2), Offset(w * 0.5, h * 0.7), line);
    // arrowhead at bottom
    final head = Path()
      ..moveTo(w * 0.5, h * 0.72)
      ..lineTo(w * 0.4, h * 0.62)
      ..lineTo(w * 0.6, h * 0.62)
      ..close();
    canvas.drawPath(head, paint);
    // ground line
    canvas.drawLine(Offset(w * 0.2, h * 0.8), Offset(w * 0.8, h * 0.8), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 2..strokeCap = StrokeCap.round);
    // height indicators
    _drawLine(canvas, w * 0.18, h * 0.2, w * 0.22, h * 0.2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 1.5);
    _drawLine(canvas, w * 0.18, h * 0.5, w * 0.22, h * 0.5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 1.5);
  }

  void _drawLucky(Canvas canvas, Size size) {
    // four-leaf clover
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    final cx = w * 0.5, cy = h * 0.42;
    final r = w * 0.12;
    // four leaves
    canvas.drawCircle(Offset(cx - r * 0.6, cy - r * 0.6), r, paint);
    canvas.drawCircle(Offset(cx + r * 0.6, cy - r * 0.6), r, paint);
    canvas.drawCircle(Offset(cx - r * 0.6, cy + r * 0.6), r, paint);
    canvas.drawCircle(Offset(cx + r * 0.6, cy + r * 0.6), r, paint);
    // stem
    canvas.drawLine(Offset(cx, cy + r * 0.8), Offset(cx, h * 0.75), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = 3..strokeCap = StrokeCap.round);
    // sparkle (lucky!)
    _drawStarShape(canvas, w * 0.78, h * 0.25, w * 0.03, w * 0.015, 4, Paint()..color = Colors.white.withOpacity(0.5));
    _drawStarShape(canvas, w * 0.22, h * 0.3, w * 0.025, w * 0.012, 4, Paint()..color = Colors.white.withOpacity(0.4));
  }

  void _drawMakeSure(Canvas canvas, Size size) {
    // checkmark with a shield
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // shield shape
    final shield = Path()
      ..moveTo(w * 0.5, h * 0.15)
      ..lineTo(w * 0.78, h * 0.25)
      ..quadraticBezierTo(w * 0.78, h * 0.55, w * 0.5, h * 0.75)
      ..quadraticBezierTo(w * 0.22, h * 0.55, w * 0.22, h * 0.25)
      ..close();
    canvas.drawPath(shield, paint);
    // inner shield
    final inner = Path()
      ..moveTo(w * 0.5, h * 0.22)
      ..lineTo(w * 0.72, h * 0.3)
      ..quadraticBezierTo(w * 0.72, h * 0.52, w * 0.5, h * 0.68)
      ..quadraticBezierTo(w * 0.28, h * 0.52, w * 0.28, h * 0.3)
      ..close();
    canvas.drawPath(inner, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    // checkmark
    final check = Paint()..color = Colors.white..strokeWidth = 4..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    final checkPath = Path()
      ..moveTo(w * 0.38, h * 0.45)
      ..lineTo(w * 0.47, h * 0.55)
      ..lineTo(w * 0.64, h * 0.35);
    canvas.drawPath(checkPath, check);
  }

  void _drawMarried(Canvas canvas, Size size) {
    // two rings intertwined
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // ring 1
    canvas.drawCircle(Offset(w * 0.4, h * 0.45), w * 0.14, paint);
    canvas.drawCircle(Offset(w * 0.4, h * 0.45), w * 0.11, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    // ring 2
    canvas.drawCircle(Offset(w * 0.6, h * 0.45), w * 0.14, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    canvas.drawCircle(Offset(w * 0.6, h * 0.45), w * 0.11, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    // diamonds on rings
    _drawStarShape(canvas, w * 0.4, h * 0.31, w * 0.025, w * 0.012, 4, Paint()..color = Colors.white.withOpacity(0.9));
    _drawStarShape(canvas, w * 0.6, h * 0.31, w * 0.025, w * 0.012, 4, Paint()..color = Colors.white.withOpacity(0.7));
    // hearts between
    _drawHeartShape(canvas, w * 0.5, h * 0.62, w * 0.04, h * 0.035, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
  }

  void _drawMean(Canvas canvas, Size size) {
    // frowning face
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // face circle
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.2, paint);
    // eyes (angry)
    canvas.drawCircle(Offset(w * 0.42, h * 0.4), w * 0.025, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.58, h * 0.4), w * 0.025, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.42, h * 0.4), w * 0.012, Paint()..color = Colors.black87);
    canvas.drawCircle(Offset(w * 0.58, h * 0.4), w * 0.012, Paint()..color = Colors.black87);
    // angry brows
    final brow = Paint()..color = Colors.white..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.36, h * 0.34), Offset(w * 0.46, h * 0.36), brow);
    canvas.drawLine(Offset(w * 0.64, h * 0.34), Offset(w * 0.54, h * 0.36), brow);
    // frown
    final frown = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.5, h * 0.56), radius: w * 0.07), pi * 0.2, pi * 0.6, false, frown);
  }

  void _drawMetal(Canvas canvas, Size size) {
    // nut/bolt
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // hexagonal nut
    final nutPath = Path();
    final nutR = w * 0.14;
    final nutCx = w * 0.5, nutCy = h * 0.45;
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3 - pi / 6;
      final px = nutCx + cos(angle) * nutR;
      final py = nutCy + sin(angle) * nutR;
      if (i == 0) nutPath.moveTo(px, py); else nutPath.lineTo(px, py);
    }
    nutPath.close();
    canvas.drawPath(nutPath, paint);
    // hole in center
    canvas.drawCircle(Offset(nutCx, nutCy), w * 0.06, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    // bolt below
    canvas.drawRect(Rect.fromLTWH(w * 0.46, h * 0.58, w * 0.08, h * 0.15), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // bolt head
    final boltR = w * 0.06;
    final boltPath = Path();
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3 - pi / 6;
      final px = w * 0.5 + cos(angle) * boltR;
      final py = h * 0.58 + sin(angle) * boltR;
      if (i == 0) boltPath.moveTo(px, py); else boltPath.lineTo(px, py);
    }
    boltPath.close();
    canvas.drawPath(boltPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // metallic shine
    canvas.drawLine(Offset(w * 0.38, h * 0.38), Offset(w * 0.45, h * 0.35), Paint()..color = Colors.white.withOpacity(0.4)..strokeWidth = 2..strokeCap = StrokeCap.round);
  }

  void _drawMiddle(Canvas canvas, Size size) {
    // dot in the center of a circle
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // outer circle
    canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.22, paint);
    // inner circle (dashed feel)
    canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.15, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
    // cross-hairs
    final cross = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.5, h * 0.22), Offset(w * 0.5, h * 0.74), cross);
    canvas.drawLine(Offset(w * 0.24, h * 0.48), Offset(w * 0.76, h * 0.48), cross);
    // center dot
    canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.05, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.02, Paint()..color = Colors.white.withOpacity(0.8));
  }

  void _drawMind(Canvas canvas, Size size) {
    // brain shape
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // left hemisphere
    final leftBrain = Path()
      ..moveTo(w * 0.5, h * 0.25)
      ..quadraticBezierTo(w * 0.25, h * 0.22, w * 0.22, h * 0.42)
      ..quadraticBezierTo(w * 0.2, h * 0.58, w * 0.3, h * 0.65)
      ..quadraticBezierTo(w * 0.4, h * 0.7, w * 0.5, h * 0.65)
      ..close();
    canvas.drawPath(leftBrain, paint);
    // right hemisphere
    final rightBrain = Path()
      ..moveTo(w * 0.5, h * 0.25)
      ..quadraticBezierTo(w * 0.75, h * 0.22, w * 0.78, h * 0.42)
      ..quadraticBezierTo(w * 0.8, h * 0.58, w * 0.7, h * 0.65)
      ..quadraticBezierTo(w * 0.6, h * 0.7, w * 0.5, h * 0.65)
      ..close();
    canvas.drawPath(rightBrain, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // center line
    canvas.drawLine(Offset(w * 0.5, h * 0.25), Offset(w * 0.5, h * 0.65), Paint()..color = Colors.white.withOpacity(0.5)..strokeWidth = 1.5..strokeCap = StrokeCap.round);
    // brain folds (squiggles)
    final fold = Paint()..color = Colors.white.withOpacity(0.35)..strokeWidth = 1.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.35, h * 0.4), radius: w * 0.06), 0.5, pi, false, fold);
    canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.65, h * 0.4), radius: w * 0.06), 0.5, pi, false, fold);
  }

  void _drawMissing(Canvas canvas, Size size) {
    // puzzle with one piece missing
    final w = size.width, h = size.height;
    final cellW = w * 0.25;
    final cellH = h * 0.25;
    final startX = w * 0.2;
    final startY = h * 0.2;
    // draw 3 of 4 puzzle pieces
    final positions = [[0, 0], [1, 0], [0, 1]];
    for (final pos in positions) {
      final x = startX + pos[0] * cellW;
      final y = startY + pos[1] * cellH;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x + 2, y + 2, cellW - 4, cellH - 4), Radius.circular(w * 0.02)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    }
    // missing piece outline (dashed feel)
    final missingX = startX + cellW;
    final missingY = startY + cellH;
    final outline = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 2..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(missingX + 2, missingY + 2, cellW - 4, cellH - 4), Radius.circular(w * 0.02)), outline);
    // question mark in missing spot
    final tp = _textPainter('?', fontSize: w * 0.12, color: illustration.accent.withOpacity(_minOp(0.25)));
    tp.paint(canvas, Offset(missingX + cellW * 0.3, missingY + cellH * 0.15));
    // puzzle tab nubs on existing pieces
    final nub = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawCircle(Offset(startX + cellW, startY + cellH * 0.5), w * 0.03, nub);
    canvas.drawCircle(Offset(startX + cellW * 0.5, startY + cellH), w * 0.03, nub);
  }

  void _drawMix(Canvas canvas, Size size) {
    // two colors swirling together
    final w = size.width, h = size.height;
    // swirl 1
    final swirl1 = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = w * 0.04..strokeCap = StrokeCap.round;
    final s1 = Path()
      ..moveTo(w * 0.25, h * 0.35)
      ..quadraticBezierTo(w * 0.45, h * 0.2, w * 0.55, h * 0.4)
      ..quadraticBezierTo(w * 0.65, h * 0.6, w * 0.45, h * 0.65)
      ..quadraticBezierTo(w * 0.3, h * 0.68, w * 0.35, h * 0.55);
    canvas.drawPath(s1, swirl1);
    // swirl 2
    final swirl2 = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = w * 0.04..strokeCap = StrokeCap.round;
    final s2 = Path()
      ..moveTo(w * 0.7, h * 0.3)
      ..quadraticBezierTo(w * 0.55, h * 0.25, w * 0.5, h * 0.45)
      ..quadraticBezierTo(w * 0.45, h * 0.65, w * 0.6, h * 0.68)
      ..quadraticBezierTo(w * 0.75, h * 0.7, w * 0.65, h * 0.5);
    canvas.drawPath(s2, swirl2);
    // overlap circle (mix point)
    canvas.drawCircle(Offset(w * 0.52, h * 0.48), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // arrows indicating mixing
    final arr = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawArrowLine(canvas, w * 0.2, h * 0.8, w * 0.45, h * 0.72, arr);
    _drawArrowLine(canvas, w * 0.8, h * 0.8, w * 0.55, h * 0.72, arr);
  }

  void _drawMove(Canvas canvas, Size size) {
    // moving box with arrows
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // box
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.32, h * 0.32, w * 0.36, h * 0.32), Radius.circular(w * 0.02)), paint);
    // flaps
    final flapL = Path()
      ..moveTo(w * 0.32, h * 0.32)
      ..lineTo(w * 0.28, h * 0.25)
      ..lineTo(w * 0.5, h * 0.25)
      ..lineTo(w * 0.5, h * 0.32)
      ..close();
    canvas.drawPath(flapL, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    final flapR = Path()
      ..moveTo(w * 0.68, h * 0.32)
      ..lineTo(w * 0.72, h * 0.25)
      ..lineTo(w * 0.5, h * 0.25)
      ..close();
    canvas.drawPath(flapR, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // movement arrows
    final arr = Paint()..color = Colors.white.withOpacity(0.7)..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawArrowLine(canvas, w * 0.15, h * 0.48, w * 0.28, h * 0.48, arr);
    _drawArrowLine(canvas, w * 0.85, h * 0.48, w * 0.72, h * 0.48, arr);
    // speed lines
    final speed = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.1, h * 0.38, w * 0.18, h * 0.38, speed);
    _drawLine(canvas, w * 0.1, h * 0.48, w * 0.16, h * 0.48, speed);
    _drawLine(canvas, w * 0.1, h * 0.58, w * 0.18, h * 0.58, speed);
  }

  void _drawMust(Canvas canvas, Size size) {
    // exclamation mark in a circle
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // circle
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.22, paint);
    // inner circle
    canvas.drawCircle(Offset(w * 0.5, h * 0.45), w * 0.19, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.25)));
    // exclamation line
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.47, h * 0.25, w * 0.06, h * 0.22), Radius.circular(w * 0.03)), Paint()..color = Colors.white);
    // exclamation dot
    canvas.drawCircle(Offset(w * 0.5, h * 0.58), w * 0.03, Paint()..color = Colors.white);
    // urgency lines
    final urg = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2))..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.18, h * 0.3, w * 0.25, h * 0.3, urg);
    _drawLine(canvas, w * 0.75, h * 0.3, w * 0.82, h * 0.3, urg);
    _drawLine(canvas, w * 0.15, h * 0.5, w * 0.22, h * 0.5, urg);
    _drawLine(canvas, w * 0.78, h * 0.5, w * 0.85, h * 0.5, urg);
  }

  void _drawMy(Canvas canvas, Size size) {
    // pointing hand toward self
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // body silhouette
    canvas.drawCircle(Offset(w * 0.5, h * 0.3), w * 0.1, paint);
    // torso
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.4, h * 0.4, w * 0.2, h * 0.25), Radius.circular(w * 0.04)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // pointing hand to chest
    final hand = Paint()..color = _dc(illustration.accent)..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.65, h * 0.48), Offset(w * 0.52, h * 0.5), hand);
    // finger
    canvas.drawLine(Offset(w * 0.52, h * 0.5), Offset(w * 0.5, h * 0.48), hand);
    // thumb
    canvas.drawLine(Offset(w * 0.54, h * 0.49), Offset(w * 0.53, h * 0.46), hand);
    // "ME" text
    final tp = _textPainter('ME', fontSize: w * 0.08, color: Colors.white.withOpacity(0.7));
    tp.paint(canvas, Offset(w * 0.46, h * 0.46));
    // heart at chest
    _drawHeartShape(canvas, w * 0.5, h * 0.5, w * 0.04, h * 0.03, Paint()..color = Colors.white.withOpacity(0.6));
  }

  void _drawNaughty(Canvas canvas, Size size) {
    // mischievous face with horns
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // face
    canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.18, paint);
    // horns
    final hornL = Path()
      ..moveTo(w * 0.36, h * 0.34)
      ..quadraticBezierTo(w * 0.28, h * 0.18, w * 0.32, h * 0.22)
      ..quadraticBezierTo(w * 0.34, h * 0.28, w * 0.4, h * 0.34)
      ..close();
    canvas.drawPath(hornL, paint);
    final hornR = Path()
      ..moveTo(w * 0.64, h * 0.34)
      ..quadraticBezierTo(w * 0.72, h * 0.18, w * 0.68, h * 0.22)
      ..quadraticBezierTo(w * 0.66, h * 0.28, w * 0.6, h * 0.34)
      ..close();
    canvas.drawPath(hornR, paint);
    // mischievous eyes (half-closed)
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.42, h * 0.43), width: w * 0.07, height: h * 0.03), Paint()..color = Colors.white);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.58, h * 0.43), width: w * 0.07, height: h * 0.03), Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * 0.43, h * 0.43), w * 0.012, Paint()..color = Colors.black87);
    canvas.drawCircle(Offset(w * 0.59, h * 0.43), w * 0.012, Paint()..color = Colors.black87);
    // mischievous grin
    final grin = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: Offset(w * 0.5, h * 0.54), radius: w * 0.08), 0.1, pi - 0.2, false, grin);
  }

  void _drawNext(Canvas canvas, Size size) {
    // right arrow or >> symbol
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // double arrows >>
    final arr1 = Path()
      ..moveTo(w * 0.25, h * 0.35)
      ..lineTo(w * 0.42, h * 0.5)
      ..lineTo(w * 0.25, h * 0.65)
      ..close();
    canvas.drawPath(arr1, paint);
    final arr2 = Path()
      ..moveTo(w * 0.45, h * 0.35)
      ..lineTo(w * 0.62, h * 0.5)
      ..lineTo(w * 0.45, h * 0.65)
      ..close();
    canvas.drawPath(arr2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // arrow line
    final line = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.55, h * 0.5), Offset(w * 0.8, h * 0.5), line);
    // arrowhead at end
    _drawArrowLine(canvas, w * 0.7, h * 0.5, w * 0.82, h * 0.5, line);
  }

  void _drawNice(Canvas canvas, Size size) {
    // flower with a smile
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // petals
    final cx = w * 0.5, cy = h * 0.4;
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      canvas.drawOval(Rect.fromCenter(center: Offset(cx + cos(angle) * w * 0.1, cy + sin(angle) * w * 0.1), width: w * 0.12, height: h * 0.1), paint);
    }
    // center
    canvas.drawCircle(Offset(cx, cy), w * 0.08, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    // smile in center
    _drawFace(canvas, cx, cy, w * 0.06, Colors.white, smileFactor: 0.9);
    // stem
    canvas.drawLine(Offset(cx, cy + w * 0.1), Offset(cx, h * 0.78), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 3..strokeCap = StrokeCap.round);
    // leaves
    final leaf = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - w * 0.08, h * 0.62), width: w * 0.1, height: h * 0.04), leaf);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.08, h * 0.55), width: w * 0.1, height: h * 0.04), leaf);
  }

  void _drawOk(Canvas canvas, Size size) {
    // thumbs up
    final w = size.width, h = size.height;
    final paint = Paint()..color = _dc(illustration.accent);
    // thumb
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.42, h * 0.18, w * 0.16, h * 0.28), Radius.circular(w * 0.05)), paint);
    // fist/palm
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.35, h * 0.42, w * 0.3, h * 0.28), Radius.circular(w * 0.04)), paint);
    // fingers
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.37, h * 0.5, w * 0.06, h * 0.2), Radius.circular(w * 0.03)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.45, h * 0.5, w * 0.06, h * 0.22), Radius.circular(w * 0.03)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.53, h * 0.5, w * 0.06, h * 0.2), Radius.circular(w * 0.03)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    // sparkle
    _drawStarShape(canvas, w * 0.78, h * 0.25, w * 0.03, w * 0.015, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    _drawStarShape(canvas, w * 0.22, h * 0.35, w * 0.025, w * 0.012, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
  }

  // ── online: 在线的 ────────────────────────────────────────────────────────
  void _drawOnline(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    final accentP = Paint()..color = _dc(illustration.accent);
    // laptop base
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.2, h * 0.52, w * 0.6, h * 0.06), Radius.circular(w * 0.02)),
      accentP,
    );
    // laptop screen
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.25, h * 0.2, w * 0.5, h * 0.33), Radius.circular(w * 0.03)),
      accentP,
    );
    // screen inner
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.28, h * 0.23, w * 0.44, h * 0.27), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)),
    );
    // wifi arcs
    final wifiP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final r = w * (0.06 + i * 0.05);
      canvas.drawArc(Rect.fromCenter(center: Offset(cx, h * 0.15), width: r * 2, height: r * 2), pi * 1.25, pi * 0.5, false, wifiP);
    }
    // wifi dot
    canvas.drawCircle(Offset(cx, h * 0.15), w * 0.02, accentP);
  }

  // ── orange: 橘子 ──────────────────────────────────────────────────────────
  void _drawOrange(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.48;
    final accentP = Paint()..color = _dc(illustration.accent);
    // orange body
    canvas.drawCircle(Offset(cx, cy), w * 0.22, accentP);
    // texture dots
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      canvas.drawCircle(Offset(cx + cos(angle) * w * 0.12, cy + sin(angle) * w * 0.12), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    }
    // navel
    canvas.drawCircle(Offset(cx, cy - w * 0.18), w * 0.03, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // stem
    final stemP = Paint()..color = const Color(0xFF5D4037)..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy - w * 0.22), Offset(cx + w * 0.02, cy - w * 0.32), stemP);
    // leaf
    final leafPath = Path()
      ..moveTo(cx + w * 0.02, cy - w * 0.3)
      ..quadraticBezierTo(cx + w * 0.12, cy - w * 0.4, cx + w * 0.1, cy - w * 0.28)
      ..quadraticBezierTo(cx + w * 0.06, cy - w * 0.28, cx + w * 0.02, cy - w * 0.3);
    canvas.drawPath(leafPath, Paint()..color = const Color(0xFF4CAF50));
  }

  // ── our: 我们的 ───────────────────────────────────────────────────────────
  void _drawOur(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final color = _dc(illustration.accent);
    // three stick figures holding hands
    _drawStickFigure(canvas, w * 0.25, h * 0.4, w * 0.18, color);
    _drawStickFigure(canvas, w * 0.5, h * 0.36, w * 0.2, color);
    _drawStickFigure(canvas, w * 0.75, h * 0.4, w * 0.18, color);
    // connecting lines (holding hands)
    final handP = Paint()..color = color.withOpacity(0.6)..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.32, h * 0.52), Offset(w * 0.43, h * 0.5), handP);
    canvas.drawLine(Offset(w * 0.57, h * 0.5), Offset(w * 0.68, h * 0.52), handP);
  }

  // ── paint: 绘画 ──────────────────────────────────────────────────────────
  void _drawPaint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // brush handle
    final handleP = Paint()..color = const Color(0xFF795548)..strokeWidth = w * 0.06..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.65, h * 0.15), Offset(w * 0.35, h * 0.65), handleP);
    // brush ferrule
    canvas.drawLine(Offset(w * 0.35, h * 0.65), Offset(w * 0.28, h * 0.78), Paint()..color = const Color(0xFFBDBDBD)..strokeWidth = w * 0.05..strokeCap = StrokeCap.round);
    // brush bristles
    final bristleP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.85))..strokeWidth = w * 0.04..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.28, h * 0.78), Offset(w * 0.2, h * 0.92), bristleP);
    // paint drops
    canvas.drawCircle(Offset(w * 0.72, h * 0.38), w * 0.04, Paint()..color = const Color(0xFFE91E63).withOpacity(0.6));
    canvas.drawCircle(Offset(w * 0.82, h * 0.55), w * 0.03, Paint()..color = const Color(0xFF2196F3).withOpacity(0.6));
    canvas.drawCircle(Offset(w * 0.68, h * 0.58), w * 0.025, Paint()..color = const Color(0xFFFFC107).withOpacity(0.6));
  }

  // ── paper: 纸 ────────────────────────────────────────────────────────────
  void _drawPaper(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // paper body
    final paperPath = Path()
      ..moveTo(w * 0.25, h * 0.12)
      ..lineTo(w * 0.65, h * 0.12)
      ..lineTo(w * 0.75, h * 0.22)
      ..lineTo(w * 0.75, h * 0.82)
      ..lineTo(w * 0.25, h * 0.82)
      ..close();
    canvas.drawPath(paperPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    // folded corner
    final foldPath = Path()
      ..moveTo(w * 0.65, h * 0.12)
      ..lineTo(w * 0.65, h * 0.22)
      ..lineTo(w * 0.75, h * 0.22)
      ..close();
    canvas.drawPath(foldPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // text lines
    final lineP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 5; i++) {
      final y = h * (0.32 + i * 0.1);
      final endX = i == 4 ? w * 0.55 : w * 0.68;
      canvas.drawLine(Offset(w * 0.32, y), Offset(endX, y), lineP);
    }
  }

  // ── pick up: 捡起 ────────────────────────────────────────────────────────
  void _drawPickUp(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // hand/arm reaching down
    final armP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8))..strokeWidth = w * 0.06..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.5, h * 0.12), Offset(w * 0.45, h * 0.45), armP);
    // hand
    canvas.drawCircle(Offset(w * 0.44, h * 0.5), w * 0.06, Paint()..color = _dc(illustration.accent));
    // fingers reaching down
    for (int i = 0; i < 3; i++) {
      final fx = w * (0.38 + i * 0.04);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(fx, h * 0.54, w * 0.025, h * 0.06), Radius.circular(w * 0.01)),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)),
      );
    }
    // small object on ground
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.42, h * 0.72, w * 0.12, h * 0.08), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
    // ground line
    canvas.drawLine(Offset(w * 0.2, h * 0.82), Offset(w * 0.8, h * 0.82), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round);
  }

  // ── pink: 粉色花 ─────────────────────────────────────────────────────────
  void _drawPink(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.4;
    final petalP = Paint()..color = _dc(illustration.accent);
    // petals
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * pi / 5 - pi / 2;
      final px = cx + cos(angle) * w * 0.12;
      final py = cy + sin(angle) * w * 0.12;
      canvas.drawOval(
        Rect.fromCenter(center: Offset(px, py), width: w * 0.16, height: h * 0.14),
        petalP,
      );
    }
    // center
    canvas.drawCircle(Offset(cx, cy), w * 0.06, Paint()..color = const Color(0xFFFFF176));
    // stem
    canvas.drawLine(Offset(cx, cy + w * 0.1), Offset(cx, h * 0.85), Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 3..strokeCap = StrokeCap.round);
    // leaves
    final leafPath = Path()
      ..moveTo(cx, h * 0.62)
      ..quadraticBezierTo(cx + w * 0.15, h * 0.55, cx + w * 0.12, h * 0.65)
      ..quadraticBezierTo(cx + w * 0.06, h * 0.65, cx, h * 0.62);
    canvas.drawPath(leafPath, Paint()..color = const Color(0xFF66BB6A).withOpacity(0.8));
  }

  // ── plastic: 塑料瓶 ──────────────────────────────────────────────────────
  void _drawPlastic(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    final accentP = Paint()..color = _dc(illustration.accent);
    // bottle cap
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.06, h * 0.12, w * 0.12, h * 0.08), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)),
    );
    // bottle neck
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.05, h * 0.2, w * 0.1, h * 0.1), Radius.circular(w * 0.02)),
      accentP,
    );
    // bottle body
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.15, h * 0.3, w * 0.3, h * 0.52), Radius.circular(w * 0.06)),
      accentP,
    );
    // label area
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.12, h * 0.4, w * 0.24, h * 0.2), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)),
    );
    // highlight
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.1, h * 0.32, w * 0.04, h * 0.4), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)),
    );
  }

  // ── pleased: 高兴的 ──────────────────────────────────────────────────────
  void _drawPleased(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    final accentP = Paint()..color = _dc(illustration.accent);
    // face circle
    canvas.drawCircle(Offset(cx, cy), w * 0.24, accentP);
    // eyes (happy squints)
    final eyeP = Paint()..color = Colors.white..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - w * 0.1, cy - h * 0.06), Offset(cx - w * 0.06, cy - h * 0.03), eyeP);
    canvas.drawLine(Offset(cx - w * 0.06, cy - h * 0.03), Offset(cx - w * 0.1, cy), eyeP);
    canvas.drawLine(Offset(cx + w * 0.06, cy - h * 0.06), Offset(cx + w * 0.1, cy - h * 0.03), eyeP);
    canvas.drawLine(Offset(cx + w * 0.1, cy - h * 0.03), Offset(cx + w * 0.06, cy), eyeP);
    // big smile
    final smileP = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + h * 0.04), width: w * 0.2, height: h * 0.12), 0.2, pi - 0.4, false, smileP);
    // blush
    canvas.drawCircle(Offset(cx - w * 0.15, cy + h * 0.04), w * 0.04, Paint()..color = const Color(0xFFFF8A80).withOpacity(0.5));
    canvas.drawCircle(Offset(cx + w * 0.15, cy + h * 0.04), w * 0.04, Paint()..color = const Color(0xFFFF8A80).withOpacity(0.5));
    // sparkles
    _drawStarShape(canvas, w * 0.82, h * 0.2, w * 0.03, w * 0.015, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    _drawStarShape(canvas, w * 0.18, h * 0.25, w * 0.025, w * 0.012, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
  }

  // ── point: 指向 ──────────────────────────────────────────────────────────
  void _drawPoint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final accentP = Paint()..color = _dc(illustration.accent);
    // hand/palm
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.32, h * 0.45, w * 0.2, h * 0.2), Radius.circular(w * 0.04)),
      accentP,
    );
    // pointing finger (extended)
    final fingerPath = Path()
      ..moveTo(w * 0.5, h * 0.48)
      ..lineTo(w * 0.82, h * 0.28)
      ..lineTo(w * 0.85, h * 0.33)
      ..lineTo(w * 0.55, h * 0.52)
      ..close();
    canvas.drawPath(fingerPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.9)));
    // finger tip
    canvas.drawCircle(Offset(w * 0.84, h * 0.3), w * 0.025, accentP);
    // other curled fingers
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(w * (0.35 + i * 0.05), h * 0.55, w * 0.04, h * 0.1), Radius.circular(w * 0.02)),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)),
      );
    }
  }

  // ── poor: 贫穷的 ─────────────────────────────────────────────────────────
  void _drawPoor(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.48;
    final accentP = Paint()..color = _dc(illustration.accent);
    // piggy bank body
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.45, height: h * 0.35), accentP);
    // ears
    canvas.drawOval(Rect.fromCenter(center: Offset(cx - w * 0.15, cy - h * 0.18), width: w * 0.1, height: h * 0.08), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.15, cy - h * 0.18), width: w * 0.1, height: h * 0.08), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    // snout
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.2, cy + h * 0.02), width: w * 0.12, height: h * 0.08), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // nostrils
    canvas.drawCircle(Offset(cx + w * 0.18, cy + h * 0.02), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    canvas.drawCircle(Offset(cx + w * 0.23, cy + h * 0.02), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // coin slot on top
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.04, cy - h * 0.22, w * 0.08, h * 0.03), Radius.circular(w * 0.015)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // cracks showing emptiness
    final crackP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6))..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx - w * 0.05, cy + h * 0.1), Offset(cx + w * 0.02, cy + h * 0.14), crackP);
    canvas.drawLine(Offset(cx + w * 0.05, cy + h * 0.08), Offset(cx + w * 0.1, cy + h * 0.13), crackP);
    // legs
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.15, cy + h * 0.16, w * 0.06, h * 0.08), Radius.circular(w * 0.02)), accentP);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx + w * 0.1, cy + h * 0.16, w * 0.06, h * 0.08), Radius.circular(w * 0.02)), accentP);
  }

  // ── popular: 受欢迎的 ────────────────────────────────────────────────────
  void _drawPopular(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // big center star
    _drawStarShape(canvas, cx, cy, w * 0.18, w * 0.09, 5, Paint()..color = _dc(illustration.accent));
    // small surrounding stars
    final smallStarP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    final angles = [0, pi / 3, 2 * pi / 3, pi, 4 * pi / 3, 5 * pi / 3];
    for (final angle in angles) {
      final sx = cx + cos(angle) * w * 0.3;
      final sy = cy + sin(angle) * w * 0.3;
      _drawStarShape(canvas, sx, sy, w * 0.06, w * 0.03, 5, smallStarP);
    }
    // tiny sparkle dots
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3 + pi / 6;
      canvas.drawCircle(
        Offset(cx + cos(angle) * w * 0.38, cy + sin(angle) * w * 0.38),
        w * 0.015,
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)),
      );
    }
  }

  // ── post: 邮寄 ───────────────────────────────────────────────────────────
  void _drawPost(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    final accentP = Paint()..color = _dc(illustration.accent);
    // mailbox body
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.18, h * 0.3, w * 0.36, h * 0.4), Radius.circular(w * 0.04)),
      accentP,
    );
    // mailbox roof
    final roofPath = Path()
      ..moveTo(cx - w * 0.22, h * 0.3)
      ..lineTo(cx, h * 0.15)
      ..lineTo(cx + w * 0.22, h * 0.3)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    // mail slot
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.1, h * 0.38, w * 0.2, h * 0.05), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)),
    );
    // letter partially inserted
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.08, h * 0.32, w * 0.16, h * 0.1), Radius.circular(w * 0.02)),
      Paint()..color = Colors.white.withOpacity(0.8),
    );
    // flag
    canvas.drawRect(Rect.fromLTWH(cx + w * 0.18, h * 0.25, w * 0.03, h * 0.3), Paint()..color = const Color(0xFF795548));
    canvas.drawRect(Rect.fromLTWH(cx + w * 0.21, h * 0.25, w * 0.1, h * 0.08), Paint()..color = const Color(0xFFF44336));
  }

  // ── practise: 练习 ──────────────────────────────────────────────────────
  void _drawPractise(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // repeat/loop arrows
    final arrowP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3.5..strokeCap = StrokeCap.round;
    // top arc (clockwise arrow)
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.45, height: h * 0.35), -pi * 0.1, pi * 0.7, false, arrowP);
    // arrowhead top
    final topEnd = Offset(cx + w * 0.2, cy - h * 0.12);
    final ahPath1 = Path()
      ..moveTo(topEnd.dx + w * 0.04, topEnd.dy - h * 0.04)
      ..lineTo(topEnd.dx, topEnd.dy)
      ..lineTo(topEnd.dx + w * 0.06, topEnd.dy + h * 0.02);
    canvas.drawPath(ahPath1, arrowP);
    // bottom arc
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.45, height: h * 0.35), pi * 0.9, pi * 0.7, false, arrowP);
    // arrowhead bottom
    final botEnd = Offset(cx - w * 0.2, cy + h * 0.12);
    final ahPath2 = Path()
      ..moveTo(botEnd.dx - w * 0.04, botEnd.dy + h * 0.04)
      ..lineTo(botEnd.dx, botEnd.dy)
      ..lineTo(botEnd.dx - w * 0.06, botEnd.dy - h * 0.02);
    canvas.drawPath(ahPath2, arrowP);
    // center dot
    canvas.drawCircle(Offset(cx, cy), w * 0.04, Paint()..color = _dc(illustration.accent));
  }

  // ── prefer: 更喜欢 ──────────────────────────────────────────────────────
  void _drawPrefer(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // two items (circles)
    canvas.drawCircle(Offset(w * 0.3, h * 0.5), w * 0.12, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    canvas.drawCircle(Offset(w * 0.7, h * 0.5), w * 0.12, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // heart over the preferred one (right)
    _drawHeartShape(canvas, w * 0.7, h * 0.35, w * 0.08, h * 0.07, Paint()..color = _dc(illustration.accent));
    // X over the other one
    final xP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.24, h * 0.44), Offset(w * 0.36, h * 0.56), xP);
    canvas.drawLine(Offset(w * 0.36, h * 0.44), Offset(w * 0.24, h * 0.56), xP);
  }

  // ── prepare: 准备 ───────────────────────────────────────────────────────
  void _drawPrepare(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    final accentP = Paint()..color = _dc(illustration.accent);
    // clipboard
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.2, h * 0.15, w * 0.4, h * 0.6), Radius.circular(w * 0.03)),
      accentP,
    );
    // clip at top
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.06, h * 0.1, w * 0.12, h * 0.08), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)),
    );
    // checklist lines with checkmarks
    final lineP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    final checkP = Paint()..color = Colors.white..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final y = h * (0.3 + i * 0.1);
      // checkbox
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.15, y - h * 0.02, w * 0.06, h * 0.05), Radius.circular(w * 0.01)),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
      );
      // checkmark
      if (i < 3) {
        final ckPath = Path()
          ..moveTo(cx - w * 0.13, y + h * 0.01)
          ..lineTo(cx - w * 0.11, y + h * 0.03)
          ..lineTo(cx - w * 0.08, y - h * 0.02);
        canvas.drawPath(ckPath, checkP);
      }
      // text line
      canvas.drawLine(Offset(cx - w * 0.05, y), Offset(cx + w * 0.13, y), lineP);
    }
  }

  // ── pull: 拉 ─────────────────────────────────────────────────────────────
  void _drawPull(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final accentP = Paint()..color = _dc(illustration.accent);
    // large arrow pointing left (toward viewer)
    final arrowP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round;
    // arrow shaft
    canvas.drawLine(Offset(cx + w * 0.25, cy), Offset(cx - w * 0.1, cy), arrowP);
    // arrowhead (pointing left)
    final headPath = Path()
      ..moveTo(cx - w * 0.1, cy)
      ..lineTo(cx - w * 0.02, cy - h * 0.1)
      ..lineTo(cx - w * 0.02, cy + h * 0.1)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent));
    // hands at left side pulling
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.28, cy - h * 0.06, w * 0.1, h * 0.12), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)),
    );
    // fingers
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.32, cy - h * (0.04 - i * 0.035), w * 0.03, h * 0.04), Radius.circular(w * 0.01)),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)),
      );
    }
    // motion lines
    final motionP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final lx = cx + w * (0.15 + i * 0.06);
      canvas.drawLine(Offset(lx, cy - h * 0.05), Offset(lx, cy + h * 0.05), motionP);
    }
  }

  // ── purple: 紫色葡萄 ────────────────────────────────────────────────────
  void _drawPurple(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    // grape cluster
    final positions = [
      [0.5, 0.3],
      [0.4, 0.42], [0.6, 0.42],
      [0.35, 0.55], [0.5, 0.55], [0.65, 0.55],
      [0.38, 0.68], [0.52, 0.68], [0.66, 0.68],
    ];
    for (final pos in positions) {
      final gx = w * pos[0], gy = h * pos[1];
      canvas.drawCircle(Offset(gx, gy), w * 0.07, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.75)));
      // highlight
      canvas.drawCircle(Offset(gx - w * 0.02, gy - h * 0.02), w * 0.02, Paint()..color = Colors.white.withOpacity(0.2));
    }
    // stem
    canvas.drawLine(Offset(cx, h * 0.15), Offset(cx, h * 0.26), Paint()..color = const Color(0xFF795548)..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    // leaf
    final leafPath = Path()
      ..moveTo(cx, h * 0.2)
      ..quadraticBezierTo(cx + w * 0.12, h * 0.12, cx + w * 0.1, h * 0.22)
      ..quadraticBezierTo(cx + w * 0.05, h * 0.22, cx, h * 0.2);
    canvas.drawPath(leafPath, Paint()..color = const Color(0xFF66BB6A));
  }

  // ── push: 推 ─────────────────────────────────────────────────────────────
  void _drawPush(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final accentP = Paint()..color = _dc(illustration.accent);
    // large arrow pointing right (away from viewer)
    final arrowP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round;
    // arrow shaft
    canvas.drawLine(Offset(cx - w * 0.25, cy), Offset(cx + w * 0.1, cy), arrowP);
    // arrowhead (pointing right)
    final headPath = Path()
      ..moveTo(cx + w * 0.1, cy)
      ..lineTo(cx + w * 0.02, cy - h * 0.1)
      ..lineTo(cx + w * 0.02, cy + h * 0.1)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent));
    // hands at left side pushing
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.32, cy - h * 0.06, w * 0.1, h * 0.12), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)),
    );
    // spread fingers pushing
    for (int i = 0; i < 4; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.24, cy - h * (0.06 - i * 0.035), w * 0.025, h * 0.045), Radius.circular(w * 0.01)),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)),
      );
    }
    // force lines
    final forceP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final lx = cx - w * (0.05 + i * 0.06);
      canvas.drawLine(Offset(lx, cy - h * 0.05), Offset(lx, cy + h * 0.05), forceP);
    }
  }

  // ── put: 放 ──────────────────────────────────────────────────────────────
  void _drawPut(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    final accentP = Paint()..color = _dc(illustration.accent);
    // surface/shelf
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.15, h * 0.55, w * 0.7, h * 0.06), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
    // hand from above
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.08, h * 0.25, w * 0.16, h * 0.12), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)),
    );
    // fingers
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * (0.06 - i * 0.04), h * 0.35, w * 0.025, h * 0.06), Radius.circular(w * 0.01)),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)),
      );
    }
    // object being placed
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.08, h * 0.45, w * 0.16, h * 0.1), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.accent),
    );
    // arrow pointing down
    final arrowP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, h * 0.38), Offset(cx, h * 0.44), arrowP);
  }

  // ── put on: 穿上 ────────────────────────────────────────────────────────
  void _drawPutOn(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final accentP = Paint()..color = _dc(illustration.accent);
    // jacket body
    final jacketPath = Path()
      ..moveTo(cx - w * 0.18, cy - h * 0.2)
      ..lineTo(cx - w * 0.25, cy + h * 0.25)
      ..lineTo(cx - w * 0.08, cy + h * 0.25)
      ..lineTo(cx - w * 0.08, cy - h * 0.05)
      ..lineTo(cx + w * 0.08, cy - h * 0.05)
      ..lineTo(cx + w * 0.08, cy + h * 0.25)
      ..lineTo(cx + w * 0.25, cy + h * 0.25)
      ..lineTo(cx + w * 0.18, cy - h * 0.2)
      ..close();
    canvas.drawPath(jacketPath, accentP);
    // collar
    final collarPath = Path()
      ..moveTo(cx - w * 0.18, cy - h * 0.2)
      ..lineTo(cx - w * 0.05, cy - h * 0.1)
      ..lineTo(cx, cy - h * 0.15)
      ..lineTo(cx + w * 0.05, cy - h * 0.1)
      ..lineTo(cx + w * 0.18, cy - h * 0.2);
    canvas.drawPath(collarPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // left sleeve
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.32, cy - h * 0.12, w * 0.1, h * 0.3), Radius.circular(w * 0.03)),
      accentP,
    );
    // right sleeve
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx + w * 0.22, cy - h * 0.12, w * 0.1, h * 0.3), Radius.circular(w * 0.03)),
      accentP,
    );
    // zipper line
    canvas.drawLine(Offset(cx, cy - h * 0.15), Offset(cx, cy + h * 0.25), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round);
    // buttons
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(cx, cy - i * h * 0.08), w * 0.015, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    }
  }

  // ── quick: 快的 ─────────────────────────────────────────────────────────
  void _drawQuick(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    // lightning bolt
    final boltPath = Path()
      ..moveTo(cx + w * 0.05, h * 0.1)
      ..lineTo(cx - w * 0.12, h * 0.45)
      ..lineTo(cx + w * 0.02, h * 0.43)
      ..lineTo(cx - w * 0.08, h * 0.85)
      ..lineTo(cx + w * 0.15, h * 0.38)
      ..lineTo(cx, h * 0.4)
      ..close();
    canvas.drawPath(boltPath, Paint()..color = _dc(illustration.accent));
    // speed lines
    final speedP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.12, h * 0.25), Offset(w * 0.25, h * 0.25), speedP);
    canvas.drawLine(Offset(w * 0.1, h * 0.4), Offset(w * 0.22, h * 0.4), speedP);
    canvas.drawLine(Offset(w * 0.15, h * 0.55), Offset(w * 0.28, h * 0.55), speedP);
    canvas.drawLine(Offset(w * 0.72, h * 0.3), Offset(w * 0.85, h * 0.3), speedP);
    canvas.drawLine(Offset(w * 0.7, h * 0.48), Offset(w * 0.82, h * 0.48), speedP);
    canvas.drawLine(Offset(w * 0.75, h * 0.62), Offset(w * 0.88, h * 0.62), speedP);
  }

  // ── racing: 赛车 ────────────────────────────────────────────────────────
  void _drawRacing(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cy = h * 0.5;
    // car body
    final bodyPath = Path()
      ..moveTo(w * 0.15, cy)
      ..lineTo(w * 0.25, cy - h * 0.12)
      ..lineTo(w * 0.45, cy - h * 0.18)
      ..lineTo(w * 0.6, cy - h * 0.18)
      ..lineTo(w * 0.72, cy - h * 0.1)
      ..lineTo(w * 0.82, cy)
      ..lineTo(w * 0.82, cy + h * 0.06)
      ..lineTo(w * 0.15, cy + h * 0.06)
      ..close();
    canvas.drawPath(bodyPath, Paint()..color = _dc(illustration.accent));
    // cockpit window
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.38, cy - h * 0.16, w * 0.18, h * 0.1), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
    // wheels
    canvas.drawCircle(Offset(w * 0.28, cy + h * 0.08), w * 0.06, Paint()..color = const Color(0xFF424242));
    canvas.drawCircle(Offset(w * 0.28, cy + h * 0.08), w * 0.03, Paint()..color = const Color(0xFF757575));
    canvas.drawCircle(Offset(w * 0.7, cy + h * 0.08), w * 0.06, Paint()..color = const Color(0xFF424242));
    canvas.drawCircle(Offset(w * 0.7, cy + h * 0.08), w * 0.03, Paint()..color = const Color(0xFF757575));
    // speed lines behind car
    final speedP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35))..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final ly = cy - h * 0.1 + i * h * 0.06;
      canvas.drawLine(Offset(w * 0.02, ly), Offset(w * 0.12, ly), speedP);
    }
    // spoiler
    canvas.drawLine(Offset(w * 0.72, cy - h * 0.1), Offset(w * 0.78, cy - h * 0.16), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8))..strokeWidth = 3..strokeCap = StrokeCap.round);
    canvas.drawLine(Offset(w * 0.74, cy - h * 0.16), Offset(w * 0.82, cy - h * 0.16), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8))..strokeWidth = 2.5..strokeCap = StrokeCap.round);
  }

  // ── ready: 准备好的 ─────────────────────────────────────────────────────
  void _drawReady(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final accentP = Paint()..color = _dc(illustration.accent);
    // circle
    canvas.drawCircle(Offset(cx, cy), w * 0.24, accentP);
    // big checkmark
    final checkPath = Path()
      ..moveTo(cx - w * 0.12, cy)
      ..lineTo(cx - w * 0.02, cy + h * 0.1)
      ..lineTo(cx + w * 0.15, cy - h * 0.12);
    canvas.drawPath(checkPath, Paint()..color = Colors.white..strokeWidth = 4.5..strokeCap = StrokeCap.round..style = PaintingStyle.stroke);
    // sparkles around
    _drawStarShape(canvas, w * 0.2, h * 0.22, w * 0.03, w * 0.015, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    _drawStarShape(canvas, w * 0.82, h * 0.28, w * 0.025, w * 0.012, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    _drawStarShape(canvas, w * 0.15, h * 0.65, w * 0.02, w * 0.01, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    _drawStarShape(canvas, w * 0.85, h * 0.6, w * 0.028, w * 0.014, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.45)));
    // small dots
    canvas.drawCircle(Offset(w * 0.3, h * 0.35), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    canvas.drawCircle(Offset(w * 0.72, h * 0.32), w * 0.012, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25)));
    canvas.drawCircle(Offset(w * 0.25, h * 0.58), w * 0.01, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
  }

  // ── red: 红色 ───────────────────────────────────────────────────────────
  void _drawRed(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // heart shape
    _drawHeartShape(canvas, cx, cy, w * 0.25, h * 0.22, Paint()..color = _dc(illustration.accent));
    // inner highlight
    _drawHeartShape(canvas, cx - w * 0.06, cy - h * 0.06, w * 0.1, h * 0.09, Paint()..color = Colors.white.withOpacity(0.2));
    // small decorative hearts around
    _drawHeartShape(canvas, w * 0.2, h * 0.25, w * 0.04, h * 0.035, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    _drawHeartShape(canvas, w * 0.8, h * 0.3, w * 0.035, h * 0.03, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25)));
    _drawHeartShape(canvas, w * 0.15, h * 0.65, w * 0.03, h * 0.025, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
    _drawHeartShape(canvas, w * 0.82, h * 0.6, w * 0.04, h * 0.035, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
  }

  // ── all: 全部 ─────────────────────────────────────────────────────────────
  void _drawAll(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final positions = [
      [0.25, 0.3], [0.5, 0.25], [0.75, 0.3],
      [0.2, 0.5], [0.45, 0.48], [0.7, 0.5], [0.85, 0.45],
      [0.3, 0.68], [0.55, 0.7], [0.8, 0.68],
      [0.15, 0.45], [0.6, 0.38],
    ];
    final radii = [0.06, 0.07, 0.055, 0.05, 0.065, 0.05, 0.045, 0.055, 0.06, 0.05, 0.04, 0.048];
    for (int i = 0; i < positions.length; i++) {
      final opacity = 0.3 + (i % 3) * 0.15;
      final color = i.isEven ? illustration.accent : illustration.bg;
      canvas.drawCircle(
        Offset(w * positions[i][0], h * positions[i][1]),
        w * radii[i],
        Paint()..color = color.withOpacity(opacity),
      );
    }
  }

  // ── all right: 好吧/好的 ──────────────────────────────────────────────────
  void _drawAllRight(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final fistP = Paint()..color = _dc(illustration.accent);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + h * 0.05), width: w * 0.2, height: h * 0.2),
        Radius.circular(w * 0.04),
      ),
      fistP,
    );
    final thumbPath = Path()
      ..moveTo(cx - w * 0.04, cy - h * 0.05)
      ..lineTo(cx - w * 0.04, cy - h * 0.22)
      ..quadraticBezierTo(cx - w * 0.04, cy - h * 0.28, cx + w * 0.02, cy - h * 0.26)
      ..lineTo(cx + w * 0.06, cy - h * 0.1)
      ..lineTo(cx + w * 0.06, cy - h * 0.05)
      ..close();
    canvas.drawPath(thumbPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.85)));
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.18), width: w * 0.14, height: h * 0.08),
      0, pi, false,
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..style = PaintingStyle.stroke..strokeWidth = 2.5,
    );
  }

  // ── asleep: 睡着的 ───────────────────────────────────────────────────────
  void _drawAsleep(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.48;
    final r = w * 0.18;
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.7)));
    final eyeP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - w * 0.07, cy - h * 0.02), width: w * 0.08, height: h * 0.04),
      0, pi, false, eyeP,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + w * 0.07, cy - h * 0.02), width: w * 0.08, height: h * 0.04),
      0, pi, false, eyeP,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.06), width: w * 0.08, height: h * 0.04),
      0.2, pi - 0.4, false,
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round,
    );
    final zP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    final zz = [[0.72, 0.28, 0.04], [0.78, 0.18, 0.05], [0.82, 0.08, 0.06]];
    for (final z in zz) {
      canvas.drawCircle(Offset(w * z[0], h * z[1]), w * z[2], zP);
    }
    final dotP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35));
    for (final z in zz) {
      canvas.drawCircle(Offset(w * z[0], h * z[1]), w * 0.01, dotP);
    }
  }

  // ── back: 后面/背部 ──────────────────────────────────────────────────────
  void _drawBack(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final mirrorP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w * 0.35, height: h * 0.22),
        Radius.circular(w * 0.06),
      ),
      mirrorP,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w * 0.28, height: h * 0.16),
        Radius.circular(w * 0.04),
      ),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)),
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - w * 0.015, cy + h * 0.11, w * 0.03, h * 0.15),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
    final arrowP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx + w * 0.08, cy, cx - w * 0.06, cy, arrowP);
    final headPath = Path()
      ..moveTo(cx - w * 0.06, cy)
      ..lineTo(cx - w * 0.01, cy - h * 0.04)
      ..lineTo(cx - w * 0.01, cy + h * 0.04)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent));
  }

  // ── be: 是/存在 ──────────────────────────────────────────────────────────
  void _drawBe(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final eqP = Paint()..color = _dc(illustration.accent)..strokeWidth = 4..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.15, cy - h * 0.05, cx + w * 0.15, cy - h * 0.05, eqP);
    _drawLine(canvas, cx - w * 0.15, cy + h * 0.05, cx + w * 0.15, cy + h * 0.05, eqP);
    final sparkP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6));
    final sparks = [
      [0.22, 0.25], [0.78, 0.28], [0.18, 0.65], [0.82, 0.62],
      [0.3, 0.18], [0.7, 0.72], [0.88, 0.42], [0.12, 0.48],
    ];
    for (int i = 0; i < sparks.length; i++) {
      final sz = w * (0.015 + (i % 3) * 0.008);
      canvas.drawCircle(Offset(w * sparks[i][0], h * sparks[i][1]), sz, sparkP);
    }
    for (int i = 0; i < 3; i++) {
      _drawStarShape(canvas, w * (0.25 + i * 0.25), h * (0.2 + i * 0.2), w * 0.025, w * 0.012, 4, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35)));
    }
  }

  // ── be called: 被叫做 ────────────────────────────────────────────────────
  void _drawBeCalled(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final tagP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w * 0.38, height: h * 0.22),
        Radius.circular(w * 0.03),
      ),
      tagP,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + h * 0.02), width: w * 0.32, height: h * 0.12),
        Radius.circular(w * 0.02),
      ),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)),
    );
    final lineP = Paint()..color = _dc(illustration.accent)..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.1, cy - h * 0.01, cx + w * 0.1, cy - h * 0.01, lineP);
    _drawLine(canvas, cx - w * 0.07, cy + h * 0.05, cx + w * 0.07, cy + h * 0.05, lineP..strokeWidth = 2);
    canvas.drawCircle(Offset(cx, cy - h * 0.15), w * 0.025, Paint()..color = _dc(illustration.accent));
  }

  // ── blond(e): 金色头发 ───────────────────────────────────────────────────
  void _drawBlonde(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    final r = w * 0.14;
    canvas.drawCircle(Offset(cx, cy + h * 0.05), r, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6)));
    final hairP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8));
    final hairTop = Path()
      ..moveTo(cx - r * 1.15, cy + h * 0.05)
      ..quadraticBezierTo(cx - r * 1.1, cy - h * 0.2, cx - r * 0.3, cy - h * 0.22)
      ..quadraticBezierTo(cx, cy - h * 0.3, cx + r * 0.3, cy - h * 0.22)
      ..quadraticBezierTo(cx + r * 1.1, cy - h * 0.2, cx + r * 1.15, cy + h * 0.05)
      ..close();
    canvas.drawPath(hairTop, hairP);
    final leftStrand = Path()
      ..moveTo(cx - r * 1.1, cy + h * 0.02)
      ..quadraticBezierTo(cx - r * 1.3, cy + h * 0.2, cx - r * 1.15, cy + h * 0.35)
      ..quadraticBezierTo(cx - r * 1.0, cy + h * 0.25, cx - r * 0.9, cy + h * 0.05)
      ..close();
    canvas.drawPath(leftStrand, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.65)));
    final rightStrand = Path()
      ..moveTo(cx + r * 1.1, cy + h * 0.02)
      ..quadraticBezierTo(cx + r * 1.3, cy + h * 0.2, cx + r * 1.15, cy + h * 0.35)
      ..quadraticBezierTo(cx + r * 1.0, cy + h * 0.25, cx + r * 0.9, cy + h * 0.05)
      ..close();
    canvas.drawPath(rightStrand, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.65)));
    final eyeP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(cx - w * 0.05, cy + h * 0.04), w * 0.02, eyeP);
    canvas.drawCircle(Offset(cx + w * 0.05, cy + h * 0.04), w * 0.02, eyeP);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.1), width: w * 0.08, height: h * 0.04),
      0.2, pi - 0.4, false,
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = 2,
    );
  }

  // ── bottom: 底部 ─────────────────────────────────────────────────────────
  void _drawBottom(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    final baseP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = 3..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.2, h * 0.78, w * 0.8, h * 0.78, baseP);
    final arrowP = Paint()..color = _dc(illustration.accent)..strokeWidth = 3.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, h * 0.18, cx, h * 0.72, arrowP);
    final headPath = Path()
      ..moveTo(cx, h * 0.78)
      ..lineTo(cx - w * 0.07, h * 0.65)
      ..lineTo(cx + w * 0.07, h * 0.65)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, h * 0.85), width: w * 0.2, height: h * 0.06),
        Radius.circular(w * 0.02),
      ),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)),
    );
  }

  // ── camp: 露营 ───────────────────────────────────────────────────────────
  void _drawCamp(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    final tentP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7));
    final tentPath = Path()
      ..moveTo(cx, h * 0.15)
      ..lineTo(cx - w * 0.28, h * 0.72)
      ..lineTo(cx + w * 0.28, h * 0.72)
      ..close();
    canvas.drawPath(tentPath, tentP);
    final openP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5));
    final openPath = Path()
      ..moveTo(cx, h * 0.38)
      ..lineTo(cx - w * 0.1, h * 0.72)
      ..lineTo(cx + w * 0.1, h * 0.72)
      ..close();
    canvas.drawPath(openPath, openP);
    canvas.drawRect(
      Rect.fromLTWH(w * 0.15, h * 0.72, w * 0.7, h * 0.04),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)),
    );
    _drawLine(canvas, cx, h * 0.15, cx, h * 0.06, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 1.5);
    final flagPath = Path()
      ..moveTo(cx, h * 0.06)
      ..lineTo(cx + w * 0.08, h * 0.1)
      ..lineTo(cx, h * 0.14)
      ..close();
    canvas.drawPath(flagPath, Paint()..color = _dc(illustration.accent));
  }

  // ── can: 能/罐 ───────────────────────────────────────────────────────────
  void _drawCan(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w * 0.28, height: h * 0.38),
        Radius.circular(w * 0.03),
      ),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - h * 0.19), width: w * 0.28, height: h * 0.08),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.19), width: w * 0.28, height: h * 0.08),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)),
    );
    canvas.drawRect(
      Rect.fromLTWH(cx - w * 0.14, cy - h * 0.06, w * 0.28, h * 0.12),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35)),
    );
    canvas.drawCircle(Offset(cx + w * 0.03, cy - h * 0.19), w * 0.02, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6)));
  }

  // ── catch (a bus): 赶公交 ─────────────────────────────────────────────────
  void _drawCatchABus(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final busP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.65));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.4, h * 0.3, w * 0.52, h * 0.32),
        Radius.circular(w * 0.03),
      ),
      busP,
    );
    final winP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5));
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * (0.46 + i * 0.15), h * 0.34, w * 0.1, h * 0.1),
          Radius.circular(w * 0.01),
        ),
        winP,
      );
    }
    canvas.drawCircle(Offset(w * 0.52, h * 0.64), w * 0.04, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(w * 0.8, h * 0.64), w * 0.04, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(w * 0.52, h * 0.64), w * 0.02, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    canvas.drawCircle(Offset(w * 0.8, h * 0.64), w * 0.02, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    _drawStickFigure(canvas, w * 0.22, h * 0.3, w * 0.18, illustration.bg,
      leftArmAngle: -1.8, rightArmAngle: 0.8,
      leftLegAngle: 0.6, rightLegAngle: -0.8,
      bodyEndY: 0.85,
    );
    final lineP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.1, h * 0.35, w * 0.18, h * 0.35, lineP);
    _drawLine(canvas, w * 0.08, h * 0.42, w * 0.16, h * 0.42, lineP);
    _drawLine(canvas, w * 0.12, h * 0.49, w * 0.19, h * 0.49, lineP);
  }

  // ── cycle: 骑自行车 ──────────────────────────────────────────────────────
  void _drawCycle(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cy = h * 0.55;
    final wheelP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3;
    canvas.drawCircle(Offset(w * 0.28, cy), w * 0.12, wheelP);
    canvas.drawCircle(Offset(w * 0.72, cy), w * 0.12, wheelP);
    final spokeP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1;
    for (int i = 0; i < 6; i++) {
      final angle = i * pi / 3;
      _drawLine(canvas,
        w * 0.28 + cos(angle) * w * 0.02, cy + sin(angle) * w * 0.02,
        w * 0.28 + cos(angle) * w * 0.11, cy + sin(angle) * w * 0.11,
        spokeP,
      );
      _drawLine(canvas,
        w * 0.72 + cos(angle) * w * 0.02, cy + sin(angle) * w * 0.02,
        w * 0.72 + cos(angle) * w * 0.11, cy + sin(angle) * w * 0.11,
        spokeP,
      );
    }
    final frameP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.28, cy, w * 0.45, cy - h * 0.18, frameP);
    _drawLine(canvas, w * 0.45, cy - h * 0.18, w * 0.72, cy, frameP);
    _drawLine(canvas, w * 0.72, cy, w * 0.72, cy - h * 0.2, frameP);
    _drawLine(canvas, w * 0.68, cy - h * 0.2, w * 0.78, cy - h * 0.22, frameP..strokeWidth = 3);
    _drawLine(canvas, w * 0.42, cy - h * 0.2, w * 0.5, cy - h * 0.2, frameP..strokeWidth = 3);
    canvas.drawCircle(Offset(w * 0.45, cy), w * 0.02, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
  }

  // ── dear: 亲爱的 ─────────────────────────────────────────────────────────
  void _drawDear(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    _drawHeartShape(canvas, cx, cy, w * 0.22, h * 0.2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    final letterP = Paint()..color = Colors.white.withOpacity(0.7)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.03, cy - h * 0.06, cx - w * 0.03, cy + h * 0.06, letterP);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - w * 0.03, cy), width: w * 0.1, height: h * 0.12),
      -pi * 0.5, pi, false, letterP,
    );
    final sparkP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5));
    canvas.drawCircle(Offset(cx - w * 0.2, cy - h * 0.18), w * 0.015, sparkP);
    canvas.drawCircle(Offset(cx + w * 0.22, cy - h * 0.15), w * 0.02, sparkP);
    canvas.drawCircle(Offset(cx + w * 0.15, cy + h * 0.18), w * 0.012, sparkP);
  }

  // ── dress up: 盛装打扮 ───────────────────────────────────────────────────
  void _drawDressUp(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    final bowP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8));
    final leftWing = Path()
      ..moveTo(cx, h * 0.18)
      ..lineTo(cx - w * 0.12, h * 0.13)
      ..lineTo(cx - w * 0.12, h * 0.23)
      ..close();
    canvas.drawPath(leftWing, bowP);
    final rightWing = Path()
      ..moveTo(cx, h * 0.18)
      ..lineTo(cx + w * 0.12, h * 0.13)
      ..lineTo(cx + w * 0.12, h * 0.23)
      ..close();
    canvas.drawPath(rightWing, bowP);
    canvas.drawCircle(Offset(cx, h * 0.18), w * 0.025, Paint()..color = _dc(illustration.accent));
    final dressP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    final dressPath = Path()
      ..moveTo(cx - w * 0.08, h * 0.25)
      ..lineTo(cx - w * 0.25, h * 0.75)
      ..lineTo(cx + w * 0.25, h * 0.75)
      ..lineTo(cx + w * 0.08, h * 0.25)
      ..close();
    canvas.drawPath(dressPath, dressP);
    canvas.drawRect(
      Rect.fromLTWH(cx - w * 0.09, h * 0.32, w * 0.18, h * 0.04),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)),
    );
    _drawStarShape(canvas, cx - w * 0.12, h * 0.5, w * 0.02, w * 0.01, 4, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    _drawStarShape(canvas, cx + w * 0.1, h * 0.55, w * 0.018, w * 0.009, 4, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
  }

  // ── english: 英语 ────────────────────────────────────────────────────────
  void _drawEnglish(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    final bubbleP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.65));
    final bubbleRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, cy), width: w * 0.42, height: h * 0.26),
      Radius.circular(w * 0.06),
    );
    canvas.drawRRect(bubbleRRect, bubbleP);
    final tailPath = Path()
      ..moveTo(cx - w * 0.08, cy + h * 0.13)
      ..lineTo(cx - w * 0.15, cy + h * 0.22)
      ..lineTo(cx + w * 0.02, cy + h * 0.13)
      ..close();
    canvas.drawPath(tailPath, bubbleP);
    final letterP = Paint()..color = Colors.white.withOpacity(0.8);
    final aPath = Path()
      ..moveTo(cx - w * 0.14, cy + h * 0.05)
      ..lineTo(cx - w * 0.1, cy - h * 0.07)
      ..lineTo(cx - w * 0.06, cy + h * 0.05)
      ..close();
    canvas.drawPath(aPath, letterP);
    _drawLine(canvas, cx - w * 0.12, cy + h * 0.01, cx - w * 0.08, cy + h * 0.01,
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7))..strokeWidth = 2);
    canvas.drawCircle(Offset(cx + w * 0.02, cy - h * 0.02), w * 0.025, letterP);
    canvas.drawCircle(Offset(cx + w * 0.02, cy + h * 0.03), w * 0.025, letterP);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + w * 0.14, cy), width: w * 0.06, height: h * 0.1),
      pi * 0.3, pi * 1.4, false,
      Paint()..color = Colors.white.withOpacity(0.8)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round,
    );
  }

  // ── extinct: 灭绝的 ──────────────────────────────────────────────────────
  void _drawExtinct(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final boneP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w * 0.35, height: h * 0.06),
        Radius.circular(w * 0.02),
      ),
      boneP,
    );
    canvas.drawCircle(Offset(cx - w * 0.18, cy - h * 0.03), w * 0.04, boneP);
    canvas.drawCircle(Offset(cx - w * 0.18, cy + h * 0.03), w * 0.04, boneP);
    canvas.drawCircle(Offset(cx + w * 0.18, cy - h * 0.03), w * 0.04, boneP);
    canvas.drawCircle(Offset(cx + w * 0.18, cy + h * 0.03), w * 0.04, boneP);
    final crackP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.05, cy - h * 0.03, cx - w * 0.02, cy + h * 0.03, crackP);
    _drawLine(canvas, cx + w * 0.08, cy - h * 0.02, cx + w * 0.06, cy + h * 0.03, crackP);
    final partP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.25));
    final particles = [[0.3, 0.25], [0.7, 0.28], [0.25, 0.65], [0.75, 0.62], [0.4, 0.2], [0.6, 0.72]];
    for (final p in particles) {
      canvas.drawCircle(Offset(w * p[0], h * p[1]), w * 0.012, partP);
    }
  }

  // ── favourite: 最喜欢的 ──────────────────────────────────────────────────
  void _drawFavourite(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    _drawStarShape(canvas, cx, cy, w * 0.24, w * 0.11, 5, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    _drawHeartShape(canvas, cx, cy + h * 0.02, w * 0.08, h * 0.07, Paint()..color = Colors.white.withOpacity(0.75));
    final sparkP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5));
    _drawStarShape(canvas, cx - w * 0.28, cy - h * 0.15, w * 0.025, w * 0.012, 4, sparkP);
    _drawStarShape(canvas, cx + w * 0.26, cy - h * 0.12, w * 0.02, w * 0.01, 4, sparkP);
    _drawStarShape(canvas, cx + w * 0.2, cy + h * 0.2, w * 0.022, w * 0.011, 4, sparkP);
    _drawStarShape(canvas, cx - w * 0.22, cy + h * 0.18, w * 0.018, w * 0.009, 4, sparkP);
  }

  // ── find out: 查明 ───────────────────────────────────────────────────────
  void _drawFindOut(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.42, cy = h * 0.38;
    final r = w * 0.15;
    final glassP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..style = PaintingStyle.stroke..strokeWidth = 4;
    canvas.drawCircle(Offset(cx, cy), r, glassP);
    canvas.drawCircle(Offset(cx, cy), r - 2, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.2)));
    final handleP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7))..strokeWidth = 4.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx + r * 0.72, cy + r * 0.72, cx + r * 1.4, cy + r * 1.4, handleP);
    canvas.drawCircle(Offset(cx - w * 0.05, cy - h * 0.05), w * 0.015, Paint()..color = Colors.white.withOpacity(0.5));
    final dotP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4));
    canvas.drawCircle(Offset(cx + w * 0.02, cy - h * 0.02), w * 0.015, dotP);
    canvas.drawCircle(Offset(cx + w * 0.02, cy + h * 0.04), w * 0.015, dotP);
    canvas.drawCircle(Offset(cx + w * 0.02, cy + h * 0.1), w * 0.015, dotP);
  }

  // ── frightening: 可怕的 ──────────────────────────────────────────────────
  void _drawFrightening(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final ghostP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    final ghostPath = Path()
      ..moveTo(cx - w * 0.15, cy + h * 0.18)
      ..quadraticBezierTo(cx - w * 0.15, cy - h * 0.18, cx, cy - h * 0.2)
      ..quadraticBezierTo(cx + w * 0.15, cy - h * 0.18, cx + w * 0.15, cy + h * 0.18)
      ..quadraticBezierTo(cx + w * 0.12, cy + h * 0.12, cx + w * 0.08, cy + h * 0.18)
      ..quadraticBezierTo(cx + w * 0.04, cy + h * 0.24, cx, cy + h * 0.18)
      ..quadraticBezierTo(cx - w * 0.04, cy + h * 0.12, cx - w * 0.08, cy + h * 0.18)
      ..quadraticBezierTo(cx - w * 0.12, cy + h * 0.24, cx - w * 0.15, cy + h * 0.18)
      ..close();
    canvas.drawPath(ghostPath, ghostP);
    final eyeP = Paint()..color = Colors.white;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - w * 0.06, cy - h * 0.04), width: w * 0.06, height: h * 0.06),
      eyeP,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + w * 0.06, cy - h * 0.04), width: w * 0.06, height: h * 0.06),
      eyeP,
    );
    final pupilP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(cx - w * 0.06, cy - h * 0.03), w * 0.02, pupilP);
    canvas.drawCircle(Offset(cx + w * 0.06, cy - h * 0.03), w * 0.02, pupilP);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.08), width: w * 0.06, height: h * 0.05),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)),
    );
  }

  // ── front: 前面 ──────────────────────────────────────────────────────────
  void _drawFront(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final frameP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    final framePath = Path()
      ..moveTo(w * 0.15, h * 0.7)
      ..lineTo(w * 0.25, h * 0.2)
      ..lineTo(w * 0.75, h * 0.2)
      ..lineTo(w * 0.85, h * 0.7)
      ..close();
    canvas.drawPath(framePath, frameP);
    final glassPath = Path()
      ..moveTo(w * 0.2, h * 0.65)
      ..lineTo(w * 0.28, h * 0.26)
      ..lineTo(w * 0.72, h * 0.26)
      ..lineTo(w * 0.8, h * 0.65)
      ..close();
    canvas.drawPath(glassPath, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    final arrowP = Paint()..color = _dc(illustration.accent)..strokeWidth = 3..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, cy + h * 0.15, cx, cy - h * 0.12, arrowP);
    final headPath = Path()
      ..moveTo(cx, cy - h * 0.18)
      ..lineTo(cx - w * 0.06, cy - h * 0.08)
      ..lineTo(cx + w * 0.06, cy - h * 0.08)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent));
    final roadP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.02, cy + h * 0.15, cx - w * 0.15, cy + h * 0.3, roadP);
    _drawLine(canvas, cx + w * 0.02, cy + h * 0.15, cx + w * 0.15, cy + h * 0.3, roadP);
  }

  // ── get dressed: 穿衣服 ──────────────────────────────────────────────────
  void _drawGetDressed(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.4;
    final shirtP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.65));
    final shirtPath = Path()
      ..moveTo(cx - w * 0.06, cy - h * 0.15)
      ..quadraticBezierTo(cx, cy - h * 0.1, cx + w * 0.06, cy - h * 0.15)
      ..lineTo(cx + w * 0.14, cy - h * 0.12)
      ..lineTo(cx + w * 0.2, cy - h * 0.02)
      ..lineTo(cx + w * 0.12, cy + h * 0.02)
      ..lineTo(cx + w * 0.1, cy + h * 0.2)
      ..lineTo(cx - w * 0.1, cy + h * 0.2)
      ..lineTo(cx - w * 0.12, cy + h * 0.02)
      ..lineTo(cx - w * 0.2, cy - h * 0.02)
      ..lineTo(cx - w * 0.14, cy - h * 0.12)
      ..close();
    canvas.drawPath(shirtPath, shirtP);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy - h * 0.13), width: w * 0.1, height: h * 0.04),
      0.1, pi - 0.2, false,
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    final btnP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5));
    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(cx, cy - h * 0.06 + i * h * 0.06), w * 0.012, btnP);
    }
  }

  // ── get off: 下车 ────────────────────────────────────────────────────────
  void _drawGetOff(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final doorP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w * 0.3, height: h * 0.5),
        Radius.circular(w * 0.02),
      ),
      doorP,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w * 0.24, height: h * 0.44),
        Radius.circular(w * 0.015),
      ),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)),
    );
    final arrowP = Paint()..color = _dc(illustration.accent)..strokeWidth = 3..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx + w * 0.02, cy, cx - w * 0.12, cy, arrowP);
    final headPath = Path()
      ..moveTo(cx - w * 0.15, cy)
      ..lineTo(cx - w * 0.07, cy - h * 0.05)
      ..lineTo(cx - w * 0.07, cy + h * 0.05)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent));
    _drawStickFigure(canvas, cx + w * 0.04, cy - h * 0.05, w * 0.1, illustration.bg);
    canvas.drawCircle(Offset(cx + w * 0.1, cy), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
  }

  // ── get on: 上车 ─────────────────────────────────────────────────────────
  void _drawGetOn(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final vehicleP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.45, h * 0.15, w * 0.45, h * 0.5),
        Radius.circular(w * 0.03),
      ),
      vehicleP,
    );
    canvas.drawRect(
      Rect.fromLTWH(w * 0.5, h * 0.35, w * 0.15, h * 0.28),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)),
    );
    final stepP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    for (int i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(w * (0.38 - i * 0.06), h * (0.63 - i * 0.08), w * 0.12, h * 0.04),
        stepP,
      );
    }
    final arrowP = Paint()..color = _dc(illustration.accent)..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.32, h * 0.68, w * 0.32, h * 0.35, arrowP);
    final headPath = Path()
      ..moveTo(w * 0.32, h * 0.3)
      ..lineTo(w * 0.28, h * 0.38)
      ..lineTo(w * 0.36, h * 0.38)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent));
    _drawStickFigure(canvas, w * 0.36, h * 0.4, w * 0.1, illustration.bg,
      leftArmAngle: -1.2, rightArmAngle: -0.8,
    );
  }

  // ── get undressed: 脱衣服 ────────────────────────────────────────────────
  void _drawGetUndressed(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.4;
    final shirtP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55));
    final leftHalf = Path()
      ..moveTo(cx - w * 0.06, cy - h * 0.15)
      ..lineTo(cx - w * 0.14, cy - h * 0.12)
      ..lineTo(cx - w * 0.2, cy - h * 0.02)
      ..lineTo(cx - w * 0.12, cy + h * 0.02)
      ..lineTo(cx - w * 0.1, cy + h * 0.2)
      ..lineTo(cx - w * 0.01, cy + h * 0.2)
      ..lineTo(cx - w * 0.01, cy - h * 0.1)
      ..close();
    canvas.drawPath(leftHalf, shirtP);
    final rightHalf = Path()
      ..moveTo(cx + w * 0.06, cy - h * 0.15)
      ..lineTo(cx + w * 0.14, cy - h * 0.12)
      ..lineTo(cx + w * 0.2, cy - h * 0.02)
      ..lineTo(cx + w * 0.12, cy + h * 0.02)
      ..lineTo(cx + w * 0.1, cy + h * 0.2)
      ..lineTo(cx + w * 0.01, cy + h * 0.2)
      ..lineTo(cx + w * 0.01, cy - h * 0.1)
      ..close();
    canvas.drawPath(rightHalf, shirtP);
    final openP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6))..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, cy - h * 0.1, cx, cy + h * 0.2, openP);
    final btnP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    canvas.drawCircle(Offset(cx - w * 0.06, cy + h * 0.25), w * 0.012, btnP);
    canvas.drawCircle(Offset(cx + w * 0.05, cy + h * 0.28), w * 0.012, btnP);
    final arrowP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35))..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.22, cy - h * 0.05, cx - w * 0.3, cy - h * 0.12, arrowP);
    _drawLine(canvas, cx + w * 0.22, cy - h * 0.05, cx + w * 0.3, cy - h * 0.12, arrowP);
  }

  // ── get up: 起床 ────────────────────────────────────────────────────────
  void _drawGetUp(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    final bedP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.5, w * 0.7, h * 0.18),
        Radius.circular(w * 0.03),
      ),
      bedP,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.18, h * 0.48, w * 0.18, h * 0.1),
        Radius.circular(w * 0.03),
      ),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)),
    );
    final blanketP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3));
    final blanketPath = Path()
      ..moveTo(w * 0.38, h * 0.5)
      ..lineTo(w * 0.82, h * 0.5)
      ..lineTo(w * 0.85, h * 0.68)
      ..lineTo(w * 0.5, h * 0.68)
      ..quadraticBezierTo(w * 0.4, h * 0.65, w * 0.38, h * 0.5)
      ..close();
    canvas.drawPath(blanketPath, blanketP);
    _drawStickFigure(canvas, w * 0.35, h * 0.28, w * 0.2, illustration.bg,
      leftArmAngle: 0.5, rightArmAngle: -0.5,
      bodyEndY: 0.75,
    );
    final actP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.28, h * 0.22, w * 0.22, h * 0.15, actP);
    _drawLine(canvas, w * 0.32, h * 0.18, w * 0.28, h * 0.1, actP);
    _drawLine(canvas, w * 0.38, h * 0.2, w * 0.38, h * 0.12, actP);
  }

  // ── glass: 玻璃杯 ───────────────────────────────────────────────────────
  void _drawGlass(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final glassP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.45));
    final glassPath = Path()
      ..moveTo(cx - w * 0.06, cy + h * 0.2)
      ..lineTo(cx - w * 0.14, cy - h * 0.18)
      ..lineTo(cx + w * 0.14, cy - h * 0.18)
      ..lineTo(cx + w * 0.06, cy + h * 0.2)
      ..close();
    canvas.drawPath(glassPath, glassP);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy - h * 0.18), width: w * 0.28, height: h * 0.06),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)),
    );
    final liquidP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35));
    final liquidPath = Path()
      ..moveTo(cx - w * 0.1, cy - h * 0.05)
      ..lineTo(cx - w * 0.06, cy + h * 0.18)
      ..lineTo(cx + w * 0.06, cy + h * 0.18)
      ..lineTo(cx + w * 0.1, cy - h * 0.05)
      ..close();
    canvas.drawPath(liquidPath, liquidP);
    final shineP = Paint()..color = Colors.white.withOpacity(0.3)..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.1, cy - h * 0.1, cx - w * 0.08, cy + h * 0.1, shineP);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.22), width: w * 0.16, height: h * 0.04),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
  }

  // ── go out: 外出 ─────────────────────────────────────────────────────────
  void _drawGoOut(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final frameP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w * 0.32, height: h * 0.55),
        Radius.circular(w * 0.02),
      ),
      frameP,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy), width: w * 0.26, height: h * 0.48),
        Radius.circular(w * 0.015),
      ),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35)),
    );
    final arrowP = Paint()..color = _dc(illustration.accent)..strokeWidth = 3..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.06, cy, cx + w * 0.1, cy, arrowP);
    final headPath = Path()
      ..moveTo(cx + w * 0.14, cy)
      ..lineTo(cx + w * 0.06, cy - h * 0.05)
      ..lineTo(cx + w * 0.06, cy + h * 0.05)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(cx + w * 0.09, cy), w * 0.018, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    canvas.drawCircle(Offset(cx + w * 0.22, cy - h * 0.15), w * 0.03, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    final rayP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.25))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final angle = i * pi / 2 + pi / 4;
      _drawLine(canvas,
        cx + w * 0.22 + cos(angle) * w * 0.04, cy - h * 0.15 + sin(angle) * w * 0.04,
        cx + w * 0.22 + cos(angle) * w * 0.06, cy - h * 0.15 + sin(angle) * w * 0.06,
        rayP,
      );
    }
  }

  // ── untidy: 不整洁的（散乱物品）────────────────────────────────────────
  void _drawUntidy(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final p = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    // scattered items: socks, book, crumpled paper
    canvas.drawOval(Rect.fromLTWH(w * 0.15, h * 0.25, w * 0.12, h * 0.08), p);
    canvas.drawOval(Rect.fromLTWH(w * 0.6, h * 0.15, w * 0.1, h * 0.07), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.45)));
    canvas.drawRect(Rect.fromLTWH(w * 0.35, h * 0.55, w * 0.18, h * 0.12), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    canvas.drawOval(Rect.fromLTWH(w * 0.7, h * 0.5, w * 0.14, h * 0.1), p);
    canvas.drawCircle(Offset(w * 0.25, h * 0.65), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    canvas.drawRect(Rect.fromLTWH(w * 0.55, h * 0.7, w * 0.1, h * 0.15), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
    // zigzag lines for mess
    final zigzagP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.1, h * 0.4, w * 0.2, h * 0.35, zigzagP);
    _drawLine(canvas, w * 0.2, h * 0.35, w * 0.3, h * 0.42, zigzagP);
    _drawLine(canvas, w * 0.7, h * 0.35, w * 0.8, h * 0.3, zigzagP);
    _drawLine(canvas, w * 0.8, h * 0.3, w * 0.9, h * 0.38, zigzagP);
  }

  // ── unusual: 不寻常的（菱形在圆中突出）──────────────────────────────────
  void _drawUnusual(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // circles
    final cp = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3));
    canvas.drawCircle(Offset(w * 0.2, h * 0.3), w * 0.08, cp);
    canvas.drawCircle(Offset(w * 0.75, h * 0.25), w * 0.07, cp);
    canvas.drawCircle(Offset(w * 0.3, h * 0.7), w * 0.09, cp);
    canvas.drawCircle(Offset(w * 0.78, h * 0.68), w * 0.06, cp);
    canvas.drawCircle(Offset(w * 0.15, h * 0.5), w * 0.05, cp);
    // diamond (rotated square) in center
    final dP = Paint()..color = _dc(illustration.accent);
    final path = Path()
      ..moveTo(cx, cy - w * 0.18)
      ..lineTo(cx + w * 0.14, cy)
      ..lineTo(cx, cy + w * 0.18)
      ..lineTo(cx - w * 0.14, cy)
      ..close();
    canvas.drawPath(path, dP);
    // sparkle around diamond
    _drawStarShape(canvas, cx + w * 0.2, cy - h * 0.15, w * 0.025, w * 0.012, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
  }

  // ── use: 使用（手持工具）────────────────────────────────────────────────
  void _drawUse(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // hand/palm
    final handP = Paint()..color = _dc(illustration.accent);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.3, h * 0.35, w * 0.22, h * 0.3), Radius.circular(w * 0.04)),
      handP,
    );
    // thumb
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.28, h * 0.28, w * 0.08, h * 0.14), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.85)),
    );
    // tool (wrench/pen)
    final toolP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6))..strokeWidth = 3..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx + w * 0.02, h * 0.2, cx + w * 0.02, h * 0.75, toolP);
    // tool head
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.02, h * 0.18), width: w * 0.12, height: h * 0.06), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    // fingers
    final fingerP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7));
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(w * (0.33 + i * 0.06), h * 0.55, w * 0.05, h * 0.12), Radius.circular(w * 0.02)),
        fingerP,
      );
    }
  }

  // ── visit: 拜访（门+欢迎垫）────────────────────────────────────────────
  void _drawVisit(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.4;
    // door frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.28, h * 0.1, w * 0.44, h * 0.65), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
    // door
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.32, h * 0.14, w * 0.36, h * 0.58), Radius.circular(w * 0.015)),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.45)),
    );
    // doorknob
    canvas.drawCircle(Offset(w * 0.6, h * 0.42), w * 0.025, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // welcome mat
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.3, h * 0.76, w * 0.4, h * 0.1), Radius.circular(w * 0.015)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)),
    );
    // mat stripes
    final stripeP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..strokeWidth = 1.5;
    for (int i = 0; i < 3; i++) {
      _drawLine(canvas, w * 0.34, h * (0.79 + i * 0.02), w * 0.66, h * (0.79 + i * 0.02), stripeP);
    }
  }

  // ── wake: 醒来（闹钟+感叹号）───────────────────────────────────────────
  void _drawWake(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // alarm clock body
    canvas.drawCircle(Offset(cx, cy), w * 0.22, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    canvas.drawCircle(Offset(cx, cy), w * 0.19, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    // clock hands
    final handP = Paint()..color = _dc(illustration.accent)..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, cy, cx, cy - h * 0.12, handP);
    _drawLine(canvas, cx, cy, cx + w * 0.08, cy + h * 0.04, handP);
    // bells on top
    canvas.drawCircle(Offset(cx - w * 0.16, cy - h * 0.24), w * 0.04, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    canvas.drawCircle(Offset(cx + w * 0.16, cy - h * 0.24), w * 0.04, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // alarm lines
    final alarmP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.02, cy - h * 0.3, cx - w * 0.06, cy - h * 0.38, alarmP);
    _drawLine(canvas, cx + w * 0.02, cy - h * 0.3, cx + w * 0.06, cy - h * 0.38, alarmP);
    _drawLine(canvas, cx, cy - h * 0.3, cx, cy - h * 0.4, alarmP);
    // exclamation mark
    _drawLine(canvas, cx + w * 0.28, cy - h * 0.1, cx + w * 0.28, cy + h * 0.05, Paint()..color = _dc(illustration.accent)..strokeWidth = 3..strokeCap = StrokeCap.round);
    canvas.drawCircle(Offset(cx + w * 0.28, cy + h * 0.1), w * 0.02, Paint()..color = _dc(illustration.accent));
  }

  // ── warm: 温暖的（杯子+蒸汽）──────────────────────────────────────────
  void _drawWarm(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // cup body
    final cupPath = Path()
      ..moveTo(cx - w * 0.15, cy - h * 0.12)
      ..lineTo(cx - w * 0.12, cy + h * 0.15)
      ..lineTo(cx + w * 0.12, cy + h * 0.15)
      ..lineTo(cx + w * 0.15, cy - h * 0.12)
      ..close();
    canvas.drawPath(cupPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // cup rim
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - h * 0.12), width: w * 0.3, height: h * 0.06), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // handle
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + w * 0.2, cy + h * 0.02), width: w * 0.12, height: h * 0.16),
      -pi * 0.4, pi * 0.8, false,
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = 3,
    );
    // steam wisps
    final steamP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final sx = cx - w * 0.06 + i * w * 0.06;
      final wave1 = sin(t * pi * 2 + i) * w * 0.03;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(sx + wave1, cy - h * 0.25), width: w * 0.04, height: h * 0.06),
        0, pi, false, steamP,
      );
      canvas.drawArc(
        Rect.fromCenter(center: Offset(sx - wave1, cy - h * 0.35), width: w * 0.035, height: h * 0.05),
        0, pi, false, steamP,
      );
    }
  }

  // ── water: 水（水滴+涟漪）─────────────────────────────────────────────
  void _drawWater(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.38;
    // water droplet
    final dropPath = Path()
      ..moveTo(cx, cy - h * 0.22)
      ..quadraticBezierTo(cx + w * 0.18, cy + h * 0.05, cx, cy + h * 0.15)
      ..quadraticBezierTo(cx - w * 0.18, cy + h * 0.05, cx, cy - h * 0.22)
      ..close();
    canvas.drawPath(dropPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // inner highlight
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - w * 0.03, cy - h * 0.02), width: w * 0.06, height: h * 0.04),
      Paint()..color = Colors.white.withOpacity(0.3),
    );
    // ripples
    final rippleP = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5;
    for (int i = 0; i < 3; i++) {
      final r = w * (0.12 + i * 0.08) * (1 + sin(t * pi * 2 - i * 0.5) * 0.1);
      canvas.drawCircle(Offset(cx, cy + h * 0.3), r, rippleP..color = illustration.accent.withOpacity(_minOp(0.35 - i * 0.1)));
    }
  }

  // ── well: 好地/井（水井）───────────────────────────────────────────────
  void _drawWell(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // well wall (stone cylinder)
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.25, h * 0.35, w * 0.5, h * 0.3), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
    // roof frame
    _drawLine(canvas, w * 0.3, h * 0.35, w * 0.3, h * 0.12, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..strokeCap = StrokeCap.round);
    _drawLine(canvas, w * 0.7, h * 0.35, w * 0.7, h * 0.12, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 3..strokeCap = StrokeCap.round);
    // roof
    final roofPath = Path()
      ..moveTo(w * 0.2, h * 0.15)
      ..lineTo(w * 0.5, h * 0.02)
      ..lineTo(w * 0.8, h * 0.15)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // bucket
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.44, h * 0.55, w * 0.12, h * 0.1), Radius.circular(w * 0.01)),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)),
    );
    // rope
    final ropeP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.5, h * 0.55, w * 0.5, h * 0.35, ropeP);
  }

  // ── whisper: 低声说（嘴巴+嘘线）────────────────────────────────────────
  void _drawWhisper(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // face circle
    canvas.drawCircle(Offset(cx, cy), w * 0.2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    // eyes
    canvas.drawCircle(Offset(cx - w * 0.08, cy - h * 0.06), w * 0.025, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6)));
    canvas.drawCircle(Offset(cx + w * 0.08, cy - h * 0.06), w * 0.025, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6)));
    // small "o" mouth
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.08), width: w * 0.06, height: h * 0.04),
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = 2,
    );
    // "shh" curved lines
    final shhP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final offset = i * w * 0.05;
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx + w * 0.18 + offset, cy + h * 0.03 - offset), width: w * 0.06, height: h * 0.04),
        -pi * 0.3, pi * 0.6, false, shhP,
      );
    }
  }

  // ── whistle: 吹口哨（嘴巴+音符）────────────────────────────────────────
  void _drawWhistle(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    // face
    canvas.drawCircle(Offset(cx, cy), w * 0.18, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    // puckered mouth
    canvas.drawCircle(Offset(cx, cy + h * 0.06), w * 0.04, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6)));
    // cheeks
    canvas.drawCircle(Offset(cx - w * 0.12, cy + h * 0.04), w * 0.03, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
    canvas.drawCircle(Offset(cx + w * 0.12, cy + h * 0.04), w * 0.03, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
    // musical notes floating up
    final noteP = Paint()..color = _dc(illustration.accent);
    // note 1
    canvas.drawCircle(Offset(cx + w * 0.15, cy - h * 0.2), w * 0.025, noteP);
    _drawLine(canvas, cx + w * 0.175, cy - h * 0.2, cx + w * 0.175, cy - h * 0.32, Paint()..color = _dc(illustration.accent)..strokeWidth = 2);
    // note 2
    canvas.drawCircle(Offset(cx - w * 0.12, cy - h * 0.28), w * 0.02, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    _drawLine(canvas, cx - w * 0.1, cy - h * 0.28, cx - w * 0.1, cy - h * 0.38, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7))..strokeWidth = 2);
    // note 3 (double note flag)
    canvas.drawCircle(Offset(cx + w * 0.05, cy - h * 0.35), w * 0.018, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
  }

  // ── white: 白色（云朵）─────────────────────────────────────────────────
  void _drawWhite(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final cloudP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    // cloud shape from overlapping circles
    canvas.drawCircle(Offset(cx - w * 0.1, cy + h * 0.02), w * 0.12, cloudP);
    canvas.drawCircle(Offset(cx + w * 0.05, cy - h * 0.04), w * 0.14, cloudP);
    canvas.drawCircle(Offset(cx + w * 0.15, cy + h * 0.02), w * 0.1, cloudP);
    canvas.drawCircle(Offset(cx - w * 0.02, cy + h * 0.06), w * 0.11, cloudP);
    // base
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.2, cy + h * 0.02, w * 0.6, h * 0.1), Radius.circular(w * 0.05)),
      cloudP,
    );
    // highlight
    canvas.drawCircle(Offset(cx + w * 0.05, cy - h * 0.06), w * 0.05, Paint()..color = Colors.white.withOpacity(0.2));
  }

  // ── wild: 野生的（狼剪影）──────────────────────────────────────────────
  void _drawWild(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.5;
    final wolfP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    // wolf body silhouette
    final bodyPath = Path()
      ..moveTo(w * 0.15, cy + h * 0.1)   // tail
      ..quadraticBezierTo(w * 0.25, cy - h * 0.05, w * 0.4, cy - h * 0.02)
      ..quadraticBezierTo(w * 0.55, cy + h * 0.02, w * 0.65, cy - h * 0.05)
      ..lineTo(w * 0.7, cy - h * 0.15)    // neck
      ..lineTo(w * 0.75, cy - h * 0.25)    // ear
      ..lineTo(w * 0.73, cy - h * 0.18)
      ..lineTo(w * 0.78, cy - h * 0.22)    // ear
      ..lineTo(w * 0.76, cy - h * 0.12)    // head
      ..lineTo(w * 0.8, cy - h * 0.08)     // nose
      ..lineTo(w * 0.65, cy + h * 0.05)    // chest
      ..lineTo(w * 0.6, cy + h * 0.2)      // front leg
      ..lineTo(w * 0.55, cy + h * 0.05)
      ..lineTo(w * 0.45, cy + h * 0.2)
      ..lineTo(w * 0.4, cy + h * 0.05)
      ..lineTo(w * 0.3, cy + h * 0.15)
      ..lineTo(w * 0.25, cy + h * 0.05)
      ..quadraticBezierTo(w * 0.18, cy + h * 0.08, w * 0.15, cy + h * 0.1)
      ..close();
    canvas.drawPath(bodyPath, wolfP);
    // eye
    canvas.drawCircle(Offset(w * 0.74, cy - h * 0.14), w * 0.015, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.8)));
  }

  // ── win a competition: 赢得比赛（奖杯）─────────────────────────────────
  void _drawWinACompetition(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.4;
    // trophy cup
    final cupPath = Path()
      ..moveTo(cx - w * 0.12, cy - h * 0.2)
      ..lineTo(cx - w * 0.15, cy + h * 0.05)
      ..lineTo(cx + w * 0.15, cy + h * 0.05)
      ..lineTo(cx + w * 0.12, cy - h * 0.2)
      ..close();
    canvas.drawPath(cupPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // cup rim
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy - h * 0.2), width: w * 0.24, height: h * 0.05), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    // handles
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx - w * 0.2, cy - h * 0.1), width: w * 0.12, height: h * 0.18),
      pi * 0.3, pi * 0.6, false,
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = 3,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx + w * 0.2, cy - h * 0.1), width: w * 0.12, height: h * 0.18),
      -pi * 0.9, pi * 0.6, false,
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = 3,
    );
    // stem
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.03, cy + h * 0.05, w * 0.06, h * 0.1), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    // base
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - w * 0.12, cy + h * 0.15, w * 0.24, h * 0.06), Radius.circular(w * 0.02)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
    // star
    _drawStarShape(canvas, cx, cy - h * 0.08, w * 0.05, w * 0.025, 5, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6)));
  }

  // ── windy: 有风的（风旋+叶子）──────────────────────────────────────────
  void _drawWindy(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // wind swirl lines
    final windP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final y = h * (0.25 + i * 0.18);
      final waveOff = sin(t * pi * 2 + i * 1.2) * w * 0.04;
      canvas.drawArc(
        Rect.fromLTWH(w * 0.1 + waveOff, y, w * 0.5, h * 0.08),
        0, pi, false, windP..color = illustration.accent.withOpacity(_minOp(0.45 - i * 0.1)),
      );
      canvas.drawArc(
        Rect.fromLTWH(w * 0.35 + waveOff, y + h * 0.04, w * 0.45, h * 0.07),
        0, pi, false, windP..color = illustration.accent.withOpacity(_minOp(0.35 - i * 0.08)),
      );
    }
    // blown leaves
    final leafP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    for (int i = 0; i < 4; i++) {
      final lx = w * (0.2 + i * 0.2) + sin(t * pi * 2 + i * 1.5) * w * 0.06;
      final ly = h * (0.3 + i * 0.12) + cos(t * pi * 2 + i) * h * 0.03;
      canvas.drawOval(Rect.fromCenter(center: Offset(lx, ly), width: w * 0.05, height: h * 0.025), leafP);
    }
  }

  // ── wish: 希望（流星）──────────────────────────────────────────────────
  void _drawWish(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // shooting star tail
    final tailPath = Path()
      ..moveTo(w * 0.8, h * 0.15)
      ..lineTo(w * 0.25, h * 0.65)
      ..lineTo(w * 0.3, h * 0.58)
      ..close();
    canvas.drawPath(tailPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25)));
    // star head
    _drawStarShape(canvas, w * 0.78, h * 0.17, w * 0.06, w * 0.03, 5, Paint()..color = _dc(illustration.accent));
    // small sparkle stars
    _drawStarShape(canvas, w * 0.15, h * 0.2, w * 0.02, w * 0.01, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    _drawStarShape(canvas, w * 0.6, h * 0.35, w * 0.015, w * 0.008, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    _drawStarShape(canvas, w * 0.4, h * 0.5, w * 0.018, w * 0.009, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    // glow at star head
    canvas.drawCircle(Offset(w * 0.78, h * 0.17), w * 0.08, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.12)));
  }

  // ── wonderful: 精彩的（烟花/星星爆炸）──────────────────────────────────
  void _drawWonderful(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.4;
    // central burst of stars
    final rng = Random(word?.hashCode ?? 0);
    for (int i = 0; i < 12; i++) {
      final angle = i * pi / 6;
      final dist = w * (0.1 + rng.nextDouble() * 0.18);
      final sx = cx + cos(angle) * dist;
      final sy = cy + sin(angle) * dist;
      final starR = w * (0.015 + rng.nextDouble() * 0.025);
      final opacity = 0.3 + rng.nextDouble() * 0.5;
      _drawStarShape(canvas, sx, sy, starR, starR * 0.5, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(opacity)));
    }
    // trailing sparks
    final sparkP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4 + 0.2;
      final r1 = w * 0.22;
      final r2 = w * 0.32;
      _drawLine(canvas, cx + cos(angle) * r1, cy + sin(angle) * r1, cx + cos(angle) * r2, cy + sin(angle) * r2, sparkP);
    }
    // center glow
    canvas.drawCircle(Offset(cx, cy), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
  }

  // ── worried: 担心的（担心脸+汗滴）──────────────────────────────────────
  void _drawWorried(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // face
    canvas.drawCircle(Offset(cx, cy), w * 0.22, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    // worried eyebrows (angled)
    final browP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.14, cy - h * 0.04, cx - w * 0.05, cy - h * 0.08, browP);
    _drawLine(canvas, cx + w * 0.14, cy - h * 0.04, cx + w * 0.05, cy - h * 0.08, browP);
    // worried eyes
    canvas.drawCircle(Offset(cx - w * 0.09, cy - h * 0.01), w * 0.025, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    canvas.drawCircle(Offset(cx + w * 0.09, cy - h * 0.01), w * 0.025, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    // wobbly mouth
    final mouthP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.12), width: w * 0.12, height: h * 0.04),
      pi * 0.2, pi * 0.6, false, mouthP,
    );
    // sweat drop
    final sweatPath = Path()
      ..moveTo(cx + w * 0.2, cy - h * 0.12)
      ..quadraticBezierTo(cx + w * 0.24, cy - h * 0.02, cx + w * 0.2, cy + h * 0.02)
      ..quadraticBezierTo(cx + w * 0.16, cy - h * 0.02, cx + w * 0.2, cy - h * 0.12)
      ..close();
    canvas.drawPath(sweatPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
  }

  // ── worse: 更糟的（向下箭头+减号）──────────────────────────────────────
  void _drawWorse(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // downward arrow
    final arrowP = Paint()..color = _dc(illustration.accent)..strokeWidth = 3.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, cy - h * 0.2, cx, cy + h * 0.12, arrowP);
    // arrow head (pointing down)
    final headPath = Path()
      ..moveTo(cx, cy + h * 0.2)
      ..lineTo(cx - w * 0.08, cy + h * 0.1)
      ..lineTo(cx + w * 0.08, cy + h * 0.1)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent));
    // minus sign
    _drawLine(canvas, cx - w * 0.12, cy - h * 0.26, cx + w * 0.12, cy - h * 0.26,
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = 3..strokeCap = StrokeCap.round);
  }

  // ── worst: 最糟的（断裂向下箭头）───────────────────────────────────────
  void _drawWorst(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.4;
    // broken arrow shaft (two segments with gap)
    final arrowP = Paint()..color = _dc(illustration.accent)..strokeWidth = 3.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, cy - h * 0.22, cx, cy - h * 0.05, arrowP);
    // gap / crack lines
    final crackP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.04, cy - h * 0.03, cx + w * 0.04, cy + h * 0.03, crackP);
    _drawLine(canvas, cx + w * 0.03, cy + h * 0.0, cx - w * 0.02, cy + h * 0.06, crackP);
    // lower segment
    _drawLine(canvas, cx, cy + h * 0.08, cx, cy + h * 0.14, arrowP);
    // arrow head (pointing down, broken)
    final headPath = Path()
      ..moveTo(cx, cy + h * 0.22)
      ..lineTo(cx - w * 0.08, cy + h * 0.12)
      ..lineTo(cx + w * 0.08, cy + h * 0.12)
      ..close();
    canvas.drawPath(headPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.8)));
    // X marks
    final xP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.15, cy - h * 0.28, cx - w * 0.08, cy - h * 0.22, xP);
    _drawLine(canvas, cx - w * 0.08, cy - h * 0.28, cx - w * 0.15, cy - h * 0.22, xP);
  }

  // ── would like: 想要（心形+愿望星）─────────────────────────────────────
  void _drawWouldLike(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // heart
    _drawHeartShape(canvas, cx - w * 0.05, cy, w * 0.2, h * 0.2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // wish star above heart
    _drawStarShape(canvas, cx + w * 0.15, cy - h * 0.2, w * 0.04, w * 0.02, 5, Paint()..color = _dc(illustration.accent));
    // small sparkle stars
    _drawStarShape(canvas, cx + w * 0.22, cy - h * 0.12, w * 0.02, w * 0.01, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    _drawStarShape(canvas, cx - w * 0.2, cy - h * 0.18, w * 0.015, w * 0.008, 4, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    // dotted line from heart to star
    final dotP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3));
    for (int i = 0; i < 4; i++) {
      final t2 = i / 4;
      final dx = cx + w * (0.05 + t2 * 0.1);
      final dy = cy - h * (0.05 + t2 * 0.15);
      canvas.drawCircle(Offset(dx, dy), w * 0.01, dotP);
    }
  }

  // ── wrong: 错误的（圆圈X）──────────────────────────────────────────────
  void _drawWrong(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // circle
    canvas.drawCircle(Offset(cx, cy), w * 0.22,
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..style = PaintingStyle.stroke..strokeWidth = 4);
    // X mark
    final xP = Paint()..color = _dc(illustration.accent)..strokeWidth = 4..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.1, cy - h * 0.1, cx + w * 0.1, cy + h * 0.1, xP);
    _drawLine(canvas, cx + w * 0.1, cy - h * 0.1, cx - w * 0.1, cy + h * 0.1, xP);
  }

  // ── yellow: 黄色（太阳）────────────────────────────────────────────────
  void _drawYellow(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // sun body
    canvas.drawCircle(Offset(cx, cy), w * 0.14, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // sun glow
    canvas.drawCircle(Offset(cx, cy), w * 0.18, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    // rays
    final rayP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      _drawLine(canvas,
        cx + cos(angle) * w * 0.17, cy + sin(angle) * w * 0.17,
        cx + cos(angle) * w * 0.26, cy + sin(angle) * w * 0.26,
        rayP,
      );
    }
    // face on sun
    canvas.drawCircle(Offset(cx - w * 0.05, cy - h * 0.02), w * 0.015, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    canvas.drawCircle(Offset(cx + w * 0.05, cy - h * 0.02), w * 0.015, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy + h * 0.04), width: w * 0.08, height: h * 0.04),
      0.1, pi - 0.2, false,
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4))..style = PaintingStyle.stroke..strokeWidth = 2,
    );
  }

  // ── young: 年轻的（幼苗/新芽）──────────────────────────────────────────
  void _drawYoung(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.6;
    // soil mound
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.12), width: w * 0.4, height: h * 0.1), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    // stem
    final stemP = Paint()..color = _dc(illustration.accent)..strokeWidth = 3..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, cy + h * 0.08, cx, cy - h * 0.15, stemP);
    // left leaf
    final leafPath1 = Path()
      ..moveTo(cx, cy - h * 0.05)
      ..quadraticBezierTo(cx - w * 0.15, cy - h * 0.12, cx - w * 0.1, cy - h * 0.2)
      ..quadraticBezierTo(cx - w * 0.05, cy - h * 0.1, cx, cy - h * 0.05)
      ..close();
    canvas.drawPath(leafPath1, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    // right leaf
    final leafPath2 = Path()
      ..moveTo(cx, cy - h * 0.12)
      ..quadraticBezierTo(cx + w * 0.14, cy - h * 0.18, cx + w * 0.1, cy - h * 0.26)
      ..quadraticBezierTo(cx + w * 0.04, cy - h * 0.16, cx, cy - h * 0.12)
      ..close();
    canvas.drawPath(leafPath2, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55)));
    // tiny bud at top
    canvas.drawCircle(Offset(cx, cy - h * 0.18), w * 0.025, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
  }

  // ── your: 你的（手指向观众）────────────────────────────────────────────
  void _drawYour(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // pointing hand (palm)
    final palmP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.32, h * 0.3, w * 0.22, h * 0.28), Radius.circular(w * 0.04)),
      palmP,
    );
    // index finger pointing up/out
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.48, h * 0.15, w * 0.06, h * 0.22), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.65)),
    );
    // other curled fingers
    final fingerP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.45));
    for (int i = 0; i < 3; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(w * (0.34 + i * 0.055), h * 0.48, w * 0.05, h * 0.1), Radius.circular(w * 0.02)),
        fingerP,
      );
    }
    // thumb
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.3, h * 0.34, w * 0.06, h * 0.12), Radius.circular(w * 0.03)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)),
    );
    // pointer direction lines
    final dirP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.35))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, w * 0.52, h * 0.12, w * 0.52, h * 0.05, dirP);
    _drawLine(canvas, w * 0.49, h * 0.08, w * 0.52, h * 0.05, dirP);
    _drawLine(canvas, w * 0.55, h * 0.08, w * 0.52, h * 0.05, dirP);
  }

  // ── stay: 房子+图钉 ──
  void _drawStay(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.48;
    final p = Paint()..color = _dc(illustration.accent);
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy + h * 0.06), width: w * 0.32, height: h * 0.24), p);
    final roofPath = Path()
      ..moveTo(cx - w * 0.22, cy - h * 0.06)
      ..lineTo(cx, cy - h * 0.24)
      ..lineTo(cx + w * 0.22, cy - h * 0.06)
      ..close();
    canvas.drawPath(roofPath, p);
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy + h * 0.12), width: w * 0.08, height: h * 0.12), Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    canvas.drawCircle(Offset(cx, cy - h * 0.28), w * 0.035, Paint()..color = _dc(illustration.accent));
    final pinPath = Path()
      ..moveTo(cx, cy - h * 0.245)
      ..lineTo(cx - w * 0.015, cy - h * 0.21)
      ..lineTo(cx + w * 0.015, cy - h * 0.21)
      ..close();
    canvas.drawPath(pinPath, Paint()..color = _dc(illustration.accent));
  }

  // ── stop: 八角形停车标志 ──
  void _drawStop(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final r = w * 0.2;
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4 - pi / 8;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) path.moveTo(x, y); else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = _dc(illustration.bg));
    canvas.drawPath(path, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.22, height: h * 0.04), Paint()..color = _dc(illustration.accent));
  }

  // ── straight: 直尺+箭头 ──
  void _drawStraight(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final p = Paint()..color = _dc(illustration.accent)..strokeWidth = 3..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.28, cy, cx + w * 0.28, cy, p);
    final tickP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    for (int i = -3; i <= 3; i++) {
      final x = cx + i * w * 0.08;
      final len = (i == 0) ? h * 0.06 : h * 0.03;
      _drawLine(canvas, x, cy - len, x, cy + len, tickP);
    }
    final arrowPath = Path()
      ..moveTo(cx + w * 0.28, cy)
      ..lineTo(cx + w * 0.2, cy - h * 0.04)
      ..lineTo(cx + w * 0.2, cy + h * 0.04)
      ..close();
    canvas.drawPath(arrowPath, Paint()..color = _dc(illustration.accent));
  }

  // ── strange: 问号+旋涡 ──
  void _drawStrange(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.42;
    final p = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round;
    final qPath = Path()
      ..moveTo(cx - w * 0.04, cy + h * 0.12)
      ..quadraticBezierTo(cx - w * 0.16, cy + h * 0.08, cx - w * 0.1, cy - h * 0.02)
      ..quadraticBezierTo(cx - w * 0.04, cy - h * 0.1, cx + w * 0.04, cy - h * 0.1)
      ..quadraticBezierTo(cx + w * 0.12, cy - h * 0.1, cx + w * 0.08, cy - h * 0.02)
      ..quadraticBezierTo(cx + w * 0.02, cy + h * 0.02, cx, cy + h * 0.06);
    canvas.drawPath(qPath, p);
    canvas.drawCircle(Offset(cx, cy + h * 0.16), w * 0.025, Paint()..color = _dc(illustration.accent));
    final swirlP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final startAngle = i * pi * 0.7;
      final sr = w * 0.06 + i * w * 0.03;
      final sx = cx + w * 0.18 + cos(startAngle) * sr * 0.3;
      final sy = cy - h * 0.05 + sin(startAngle) * sr * 0.3;
      canvas.drawArc(Rect.fromCenter(center: Offset(sx, sy), width: sr, height: sr), startAngle, pi * 0.8, false, swirlP);
    }
  }

  // ── striped: 条纹形状 ──
  void _drawStriped(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final rRect = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.4, height: h * 0.35), Radius.circular(w * 0.05));
    canvas.drawRRect(rRect, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    final stripeP = Paint()..color = _dc(illustration.accent)..strokeWidth = w * 0.035..strokeCap = StrokeCap.round;
    for (int i = -3; i <= 3; i++) {
      final y = cy + i * h * 0.05;
      final halfW = w * 0.16;
      _drawLine(canvas, cx - halfW, y, cx + halfW, y, stripeP);
    }
    canvas.drawRRect(rRect, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  // ── sunny: 太阳+光芒 ──
  void _drawSunny(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final rayP = Paint()..color = _dc(illustration.accent)..strokeWidth = 3..strokeCap = StrokeCap.round;
    for (int i = 0; i < 12; i++) {
      final angle = i * pi / 6;
      final inner = w * 0.14;
      final outer = w * 0.24;
      _drawLine(canvas,
        cx + cos(angle) * inner, cy + sin(angle) * inner,
        cx + cos(angle) * outer, cy + sin(angle) * outer,
        rayP,
      );
    }
    canvas.drawCircle(Offset(cx, cy), w * 0.12, Paint()..color = _dc(illustration.accent));
    _drawFace(canvas, cx, cy, w * 0.1, illustration.bg.withOpacity(_minOp(0.5)), smileFactor: 0.8);
  }

  // ── sure: 勾+圆圈 ──
  void _drawSure(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    canvas.drawCircle(Offset(cx, cy), w * 0.2, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    canvas.drawCircle(Offset(cx, cy), w * 0.2, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 4);
    final checkPath = Path()
      ..moveTo(cx - w * 0.1, cy)
      ..lineTo(cx - w * 0.02, cy + h * 0.08)
      ..lineTo(cx + w * 0.12, cy - h * 0.08);
    canvas.drawPath(checkPath, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 5..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
  }

  // ── surprised: 惊讶的脸 ──
  void _drawSurprised(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    canvas.drawCircle(Offset(cx, cy), w * 0.2, Paint()..color = _dc(illustration.accent));
    final eyeP = Paint()..color = _dc(illustration.bg);
    canvas.drawCircle(Offset(cx - w * 0.08, cy - h * 0.04), w * 0.04, eyeP);
    canvas.drawCircle(Offset(cx + w * 0.08, cy - h * 0.04), w * 0.04, eyeP);
    canvas.drawCircle(Offset(cx - w * 0.08, cy - h * 0.04), w * 0.02, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(cx + w * 0.08, cy - h * 0.04), w * 0.02, Paint()..color = Colors.white);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.08), width: w * 0.08, height: h * 0.06), Paint()..color = _dc(illustration.bg));
    final browP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.13, cy - h * 0.1, cx - w * 0.04, cy - h * 0.12, browP);
    _drawLine(canvas, cx + w * 0.04, cy - h * 0.12, cx + w * 0.13, cy - h * 0.1, browP);
  }

  // ── take off: 飞机起飞 ──
  void _drawTakeOff(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final bodyP = Paint()..color = _dc(illustration.accent);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.35, height: h * 0.06), bodyP);
    final wingPath = Path()
      ..moveTo(cx - w * 0.04, cy)
      ..lineTo(cx - w * 0.12, cy - h * 0.14)
      ..lineTo(cx + w * 0.04, cy - h * 0.02)
      ..close();
    canvas.drawPath(wingPath, bodyP);
    final wingPath2 = Path()
      ..moveTo(cx - w * 0.04, cy)
      ..lineTo(cx - w * 0.1, cy + h * 0.1)
      ..lineTo(cx + w * 0.04, cy + h * 0.02)
      ..close();
    canvas.drawPath(wingPath2, bodyP);
    final tailPath = Path()
      ..moveTo(cx - w * 0.17, cy)
      ..lineTo(cx - w * 0.22, cy - h * 0.08)
      ..lineTo(cx - w * 0.12, cy)
      ..close();
    canvas.drawPath(tailPath, bodyP);
    final trailP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final ox = cx - w * 0.24 - i * w * 0.06;
      canvas.drawCircle(Offset(ox, cy + h * 0.01), w * 0.015 + i * w * 0.005, trailP);
    }
  }

  // ── terrible: 暴风雨+闪电 ──
  void _drawTerrible(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.35;
    final cloudP = Paint()..color = _dc(illustration.accent);
    canvas.drawCircle(Offset(cx - w * 0.08, cy), w * 0.1, cloudP);
    canvas.drawCircle(Offset(cx + w * 0.08, cy), w * 0.1, cloudP);
    canvas.drawCircle(Offset(cx, cy - h * 0.04), w * 0.1, cloudP);
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.18, cy, w * 0.36, h * 0.06), cloudP);
    final boltPath = Path()
      ..moveTo(cx + w * 0.02, cy + h * 0.06)
      ..lineTo(cx - w * 0.06, cy + h * 0.16)
      ..lineTo(cx + w * 0.02, cy + h * 0.14)
      ..lineTo(cx - w * 0.04, cy + h * 0.24)
      ..lineTo(cx + w * 0.08, cy + h * 0.12)
      ..lineTo(cx, cy + h * 0.14)
      ..lineTo(cx + w * 0.06, cy + h * 0.06)
      ..close();
    canvas.drawPath(boltPath, Paint()..color = _dc(illustration.accent));
  }

  // ── thank: 双手合十 ──
  void _drawThank(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final p = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3.5..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final leftHand = Path()
      ..moveTo(cx - w * 0.02, cy + h * 0.18)
      ..quadraticBezierTo(cx - w * 0.14, cy + h * 0.12, cx - w * 0.12, cy - h * 0.02)
      ..quadraticBezierTo(cx - w * 0.1, cy - h * 0.12, cx - w * 0.04, cy - h * 0.16);
    canvas.drawPath(leftHand, p);
    final rightHand = Path()
      ..moveTo(cx + w * 0.02, cy + h * 0.18)
      ..quadraticBezierTo(cx + w * 0.14, cy + h * 0.12, cx + w * 0.12, cy - h * 0.02)
      ..quadraticBezierTo(cx + w * 0.1, cy - h * 0.12, cx + w * 0.04, cy - h * 0.16);
    canvas.drawPath(rightHand, p);
    final fillP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2));
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + h * 0.02), width: w * 0.12, height: h * 0.2), Radius.circular(w * 0.04)), fillP);
    _drawHeartShape(canvas, cx, cy - h * 0.22, w * 0.05, w * 0.05, Paint()..color = _dc(illustration.accent));
  }

  // ── their: 一群人 ──
  void _drawTheir(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cy = h * 0.55;
    _drawStickFigure(canvas, w * 0.3, cy, w * 0.06, illustration.accent);
    _drawStickFigure(canvas, w * 0.5, cy - h * 0.03, w * 0.07, illustration.accent);
    _drawStickFigure(canvas, w * 0.7, cy, w * 0.06, illustration.accent);
    final arcP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.25))..style = PaintingStyle.stroke..strokeWidth = 2;
    canvas.drawArc(Rect.fromCenter(center: Offset(w * 0.5, cy - h * 0.06), width: w * 0.4, height: h * 0.08), pi * 0.1, pi * 0.8, false, arcP);
  }

  // ── thin: 细长线 ──
  void _drawThin(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2;
    final barP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3));
    canvas.drawRect(Rect.fromCenter(center: Offset(cx - w * 0.12, h * 0.45), width: w * 0.08, height: h * 0.35), barP);
    final thinP = Paint()..color = _dc(illustration.accent)..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx + w * 0.04, h * 0.22, cx + w * 0.04, h * 0.68, thinP);
    final arrP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx + w * 0.12, h * 0.32, cx + w * 0.04, h * 0.35, arrP);
    _drawLine(canvas, cx + w * 0.12, h * 0.58, cx + w * 0.04, h * 0.55, arrP);
  }

  // ── third: 铜牌/3 ──
  void _drawThird(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    canvas.drawCircle(Offset(cx, cy + h * 0.04), w * 0.16, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(cx, cy + h * 0.04), w * 0.16, Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 3);
    canvas.drawCircle(Offset(cx, cy + h * 0.04), w * 0.11, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    final threeP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round;
    final threePath = Path()
      ..moveTo(cx - w * 0.04, cy - h * 0.04)
      ..quadraticBezierTo(cx + w * 0.06, cy - h * 0.06, cx + w * 0.04, cy)
      ..quadraticBezierTo(cx + w * 0.02, cy + h * 0.02, cx + w * 0.06, cy + h * 0.04)
      ..quadraticBezierTo(cx + w * 0.06, cy + h * 0.08, cx - w * 0.04, cy + h * 0.06);
    canvas.drawPath(threePath, threeP);
    final ribbonP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    final ribbon1 = Path()
      ..moveTo(cx - w * 0.06, cy - h * 0.12)
      ..lineTo(cx - w * 0.12, cy - h * 0.26)
      ..lineTo(cx - w * 0.02, cy - h * 0.22)
      ..close();
    canvas.drawPath(ribbon1, ribbonP);
    final ribbon2 = Path()
      ..moveTo(cx + w * 0.06, cy - h * 0.12)
      ..lineTo(cx + w * 0.12, cy - h * 0.26)
      ..lineTo(cx + w * 0.02, cy - h * 0.22)
      ..close();
    canvas.drawPath(ribbon2, ribbonP);
  }

  // ── thirsty: 水杯+水滴 ──
  void _drawThirsty(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final glassPath = Path()
      ..moveTo(cx - w * 0.1, cy - h * 0.14)
      ..lineTo(cx - w * 0.07, cy + h * 0.12)
      ..lineTo(cx + w * 0.07, cy + h * 0.12)
      ..lineTo(cx + w * 0.1, cy - h * 0.14)
      ..close();
    canvas.drawPath(glassPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    canvas.drawPath(glassPath, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 2.5);
    final waterPath = Path()
      ..moveTo(cx - w * 0.06, cy + h * 0.02)
      ..lineTo(cx - w * 0.065, cy + h * 0.11)
      ..lineTo(cx + w * 0.065, cy + h * 0.11)
      ..lineTo(cx + w * 0.06, cy + h * 0.02)
      ..close();
    canvas.drawPath(waterPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    _drawWaterDrop(canvas, cx + w * 0.16, cy - h * 0.1, w * 0.025, Paint()..color = _dc(illustration.accent));
    _drawWaterDrop(canvas, cx - w * 0.18, cy - h * 0.02, w * 0.02, Paint()..color = _dc(illustration.accent));
  }

  void _drawWaterDrop(Canvas canvas, double x, double y, double r, Paint paint) {
    final dropPath = Path()
      ..moveTo(x, y - r * 2)
      ..quadraticBezierTo(x + r * 1.5, y, x, y + r)
      ..quadraticBezierTo(x - r * 1.5, y, x, y - r * 2);
    canvas.drawPath(dropPath, paint);
  }

  // ── tidy: 整齐的书堆 ──
  void _drawTidy(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.55;
    for (int i = 0; i < 4; i++) {
      final y = cy - i * h * 0.06;
      final bw = w * (0.25 - i * 0.01);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, y), width: bw, height: h * 0.045), Radius.circular(2)), Paint()..color = _dc(illustration.accent));
    }
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy - h * 0.27), width: w * 0.06, height: h * 0.16), Radius.circular(2)), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    final shelfP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.2, cy + h * 0.1, cx + w * 0.2, cy + h * 0.1, shelfP);
  }

  // ── touch: 手伸向物体 ──
  void _drawTouch(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final p = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final handPath = Path()
      ..moveTo(cx - w * 0.12, cy + h * 0.1)
      ..quadraticBezierTo(cx - w * 0.16, cy, cx - w * 0.1, cy - h * 0.06)
      ..lineTo(cx - w * 0.06, cy - h * 0.12)
      ..lineTo(cx - w * 0.03, cy - h * 0.06)
      ..lineTo(cx, cy - h * 0.14)
      ..lineTo(cx + w * 0.03, cy - h * 0.06)
      ..lineTo(cx + w * 0.06, cy - h * 0.1)
      ..lineTo(cx + w * 0.08, cy - h * 0.04)
      ..lineTo(cx + w * 0.06, cy + h * 0.04)
      ..quadraticBezierTo(cx + w * 0.04, cy + h * 0.1, cx - w * 0.04, cy + h * 0.1);
    canvas.drawPath(handPath, p);
    canvas.drawCircle(Offset(cx + w * 0.18, cy - h * 0.06), w * 0.06, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..style = PaintingStyle.stroke..strokeWidth = 2);
    canvas.drawCircle(Offset(cx + w * 0.18, cy - h * 0.06), w * 0.025, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)));
    final reachP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx + w * 0.08, cy - h * 0.02, cx + w * 0.13, cy - h * 0.04, reachP);
  }

  // ── travel: 地球+飞机 ──
  void _drawTravel(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    canvas.drawCircle(Offset(cx, cy), w * 0.18, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    canvas.drawCircle(Offset(cx, cy), w * 0.18, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 2);
    final lineP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..style = PaintingStyle.stroke..strokeWidth = 1.5;
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.36, height: h * 0.1), lineP);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.28, height: h * 0.18), lineP);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.14, height: h * 0.36), lineP);
    final ap = Paint()..color = _dc(illustration.accent);
    final ax = cx + w * 0.16, ay = cy - h * 0.14;
    final planePath = Path()
      ..moveTo(ax + w * 0.06, ay)
      ..lineTo(ax - w * 0.04, ay - h * 0.02)
      ..lineTo(ax - w * 0.02, ay)
      ..lineTo(ax - w * 0.04, ay + h * 0.02)
      ..close();
    canvas.drawPath(planePath, ap);
  }

  // ── turn: 旋转箭头 ──
  void _drawTurn(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final arcP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 4..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.32, height: h * 0.28), -pi * 0.3, pi * 1.6, false, arcP);
    final endAngle = pi * 1.3 - pi * 0.3;
    final ar = w * 0.16;
    final ax = cx + ar * cos(endAngle);
    final ay = cy + (h * 0.14) * sin(endAngle);
    final tangent = endAngle + pi / 2;
    final arrowPath = Path()
      ..moveTo(ax + cos(tangent) * w * 0.04, ay + sin(tangent) * h * 0.04)
      ..lineTo(ax + cos(endAngle) * w * 0.06, ay + sin(endAngle) * h * 0.06)
      ..lineTo(ax - cos(tangent) * w * 0.04, ay - sin(tangent) * h * 0.04)
      ..close();
    canvas.drawPath(arrowPath, Paint()..color = _dc(illustration.accent));
    canvas.drawCircle(Offset(cx, cy), w * 0.02, Paint()..color = _dc(illustration.accent));
  }

  // ── turn off: 电源按钮 ──
  void _drawTurnOff(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    canvas.drawCircle(Offset(cx, cy), w * 0.18, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.2)));
    canvas.drawCircle(Offset(cx, cy), w * 0.18, Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3);
    final lineP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, cy - h * 0.02, cx, cy + h * 0.1, lineP);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.2, height: h * 0.18), pi * 0.8, pi * 1.4, false, lineP);
  }

  // ── turn on: 亮灯泡 ──
  void _drawTurnOn(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.42;
    canvas.drawCircle(Offset(cx, cy - h * 0.02), w * 0.22, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.15)));
    canvas.drawCircle(Offset(cx, cy - h * 0.02), w * 0.12, Paint()..color = _dc(illustration.accent));
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy + h * 0.12), width: w * 0.1, height: h * 0.06), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy + h * 0.16), width: w * 0.12, height: h * 0.03), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    final filP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    final filPath = Path()
      ..moveTo(cx - w * 0.03, cy + h * 0.04)
      ..lineTo(cx - w * 0.02, cy - h * 0.04)
      ..lineTo(cx, cy)
      ..lineTo(cx + w * 0.02, cy - h * 0.04)
      ..lineTo(cx + w * 0.03, cy + h * 0.04);
    canvas.drawPath(filPath, filP);
    final rayP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 2..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final angle = i * pi / 4;
      _drawLine(canvas,
        cx + cos(angle) * w * 0.16, cy - h * 0.02 + sin(angle) * w * 0.16,
        cx + cos(angle) * w * 0.22, cy - h * 0.02 + sin(angle) * w * 0.22,
        rayP,
      );
    }
  }

  // ── ugly: 皱眉的脸+疣 ──
  void _drawUgly(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    canvas.drawCircle(Offset(cx, cy), w * 0.2, Paint()..color = _dc(illustration.accent));
    final mouthP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + h * 0.1), width: w * 0.14, height: h * 0.06), pi * 0.15, pi * 0.7, false, mouthP);
    final eyeP = Paint()..color = _dc(illustration.bg);
    canvas.drawCircle(Offset(cx - w * 0.08, cy - h * 0.03), w * 0.025, eyeP);
    canvas.drawCircle(Offset(cx + w * 0.08, cy - h * 0.03), w * 0.025, eyeP);
    final browP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.13, cy - h * 0.06, cx - w * 0.04, cy - h * 0.09, browP);
    _drawLine(canvas, cx + w * 0.04, cy - h * 0.09, cx + w * 0.13, cy - h * 0.06, browP);
    canvas.drawCircle(Offset(cx + w * 0.12, cy + h * 0.04), w * 0.02, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
    canvas.drawCircle(Offset(cx - w * 0.1, cy + h * 0.06), w * 0.015, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
  }

  // ── unfriendly: 皱眉+交叉手臂 ──
  void _drawUnfriendly(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.42;
    canvas.drawCircle(Offset(cx, cy - h * 0.06), w * 0.12, Paint()..color = _dc(illustration.accent));
    final mouthP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + h * 0.0), width: w * 0.1, height: h * 0.04), pi * 0.2, pi * 0.6, false, mouthP);
    final eyeP = Paint()..color = _dc(illustration.bg);
    canvas.drawCircle(Offset(cx - w * 0.05, cy - h * 0.08), w * 0.018, eyeP);
    canvas.drawCircle(Offset(cx + w * 0.05, cy - h * 0.08), w * 0.018, eyeP);
    final armP = Paint()..color = _dc(illustration.accent)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.16, cy + h * 0.12, cx + w * 0.08, cy + h * 0.06, armP);
    _drawLine(canvas, cx + w * 0.16, cy + h * 0.12, cx - w * 0.08, cy + h * 0.06, armP);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.18), width: w * 0.2, height: h * 0.12), Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
  }

  // ── unhappy: 悲伤的脸 ──
  void _drawUnhappy(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    canvas.drawCircle(Offset(cx, cy), w * 0.2, Paint()..color = _dc(illustration.accent));
    final mouthP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 3..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy + h * 0.1), width: w * 0.14, height: h * 0.08), pi * 0.2, pi * 0.6, false, mouthP);
    final eyeP = Paint()..color = _dc(illustration.bg);
    canvas.drawCircle(Offset(cx - w * 0.07, cy - h * 0.03), w * 0.025, eyeP);
    canvas.drawCircle(Offset(cx + w * 0.07, cy - h * 0.03), w * 0.025, eyeP);
    final browP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.12, cy - h * 0.08, cx - w * 0.04, cy - h * 0.06, browP);
    _drawLine(canvas, cx + w * 0.04, cy - h * 0.06, cx + w * 0.12, cy - h * 0.08, browP);
    _drawWaterDrop(canvas, cx - w * 0.09, cy + h * 0.02, w * 0.015, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
  }

  // ── unkind: 碎心 ──
  void _drawUnkind(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w / 2, cy = h * 0.45;
    final leftPath = Path()
      ..moveTo(cx - w * 0.02, cy - h * 0.04)
      ..quadraticBezierTo(cx - w * 0.02, cy - h * 0.16, cx - w * 0.12, cy - h * 0.16)
      ..quadraticBezierTo(cx - w * 0.22, cy - h * 0.16, cx - w * 0.16, cy - h * 0.02)
      ..lineTo(cx - w * 0.02, cy + h * 0.12)
      ..close();
    canvas.drawPath(leftPath, Paint()..color = _dc(illustration.accent));
    final rightPath = Path()
      ..moveTo(cx + w * 0.04, cy - h * 0.02)
      ..quadraticBezierTo(cx + w * 0.04, cy - h * 0.14, cx + w * 0.14, cy - h * 0.18)
      ..quadraticBezierTo(cx + w * 0.22, cy - h * 0.18, cx + w * 0.18, cy - h * 0.02)
      ..lineTo(cx + w * 0.04, cy + h * 0.14)
      ..close();
    canvas.drawPath(rightPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.7)));
    final crackP = Paint()..color = _dc(illustration.bg)..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    final crackPath = Path()
      ..moveTo(cx - w * 0.02, cy - h * 0.04)
      ..lineTo(cx + w * 0.01, cy + h * 0.02)
      ..lineTo(cx - w * 0.01, cy + h * 0.06)
      ..lineTo(cx + w * 0.04, cy + h * 0.14);
    canvas.drawPath(crackPath, crackP);
  }

  // helper: draw arrow head
  void _drawArrowHead(Canvas canvas, double x, double y, double angle, double size, Paint paint) {
    final a1 = angle + 2.6;
    final a2 = angle - 2.6;
    final path = Path()
      ..moveTo(x, y)
      ..lineTo(x + cos(a1) * size, y + sin(a1) * size)
      ..moveTo(x, y)
      ..lineTo(x + cos(a2) * size, y + sin(a2) * size);
    canvas.drawPath(path, paint);
  }

  // ── remember: 记忆（大脑/灯泡）────────────────────────────────────────────
  void _drawRemember(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final r = w * 0.16;
    final bulbP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    canvas.drawCircle(Offset(cx, cy - r * 0.3), r, bulbP);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - r * 0.45, cy + r * 0.5, r * 0.9, r * 0.35), Radius.circular(r * 0.1)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - r * 0.35, cy + r * 0.8, r * 0.7, r * 0.2), Radius.circular(r * 0.08)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)),
    );
    final rayP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.8..strokeCap = StrokeCap.round;
    for (int i = 0; i < 8; i++) {
      final a = i * pi / 4;
      _drawLine(canvas, cx + cos(a) * r * 1.2, cy - r * 0.3 + sin(a) * r * 1.2,
          cx + cos(a) * r * 1.55, cy - r * 0.3 + sin(a) * r * 1.55, rayP);
    }
    final filP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5))..strokeWidth = 1.5..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy - r * 0.3), width: r * 0.6, height: r * 0.5), -0.3, pi + 0.6, false, filP);
  }

  // ── repair: 修理（扳手）────────────────────────────────────────────
  void _drawRepair(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final p = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = w * 0.04..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, cy + h * 0.2, cx, cy - h * 0.05, p);
    final jawP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55))..strokeWidth = w * 0.035..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy - h * 0.1), width: w * 0.18, height: w * 0.18), -pi * 0.8, pi * 0.6, false, jawP);
    _drawLine(canvas, cx - w * 0.075, cy - h * 0.17, cx - w * 0.04, cy - h * 0.22, jawP);
    final cogP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(cx + w * 0.15, cy + h * 0.1), w * 0.06, cogP);
    for (int i = 0; i < 6; i++) {
      final a = i * pi / 3;
      _drawLine(canvas, cx + w * 0.15 + cos(a) * w * 0.06, cy + h * 0.1 + sin(a) * w * 0.06,
          cx + w * 0.15 + cos(a) * w * 0.09, cy + h * 0.1 + sin(a) * w * 0.09, cogP);
    }
  }

  // ── repeat: 重复（循环箭头）────────────────────────────────────────────
  void _drawRepeat(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final r = w * 0.18;
    final arcP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55))..strokeWidth = w * 0.03..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: r * 2.2, height: r * 2.2), -pi * 0.3, pi * 1.1, false, arcP);
    final endAngle = -pi * 0.3 + pi * 1.1;
    final ax = cx + cos(endAngle) * r * 1.1;
    final ay = cy + sin(endAngle) * r * 1.1;
    _drawArrowHead(canvas, ax, ay, endAngle + 0.3, w * 0.06, arcP);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: r * 2.2, height: r * 2.2), pi * 0.7, pi * 1.1, false, arcP);
    final endAngle2 = pi * 0.7 + pi * 1.1;
    final ax2 = cx + cos(endAngle2) * r * 1.1;
    final ay2 = cy + sin(endAngle2) * r * 1.1;
    _drawArrowHead(canvas, ax2, ay2, endAngle2 + 0.3, w * 0.06, arcP);
  }

  // ── rich: 富有（金币）────────────────────────────────────────────
  void _drawRich(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final coinP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    for (int i = 0; i < 3; i++) {
      final oy = cy + h * 0.12 - i * h * 0.06;
      canvas.drawOval(Rect.fromCenter(center: Offset(cx + i * 0.5, oy), width: w * 0.22, height: w * 0.07), coinP);
    }
    _drawText(canvas, '\$', cx - w * 0.02, cy - h * 0.04, w * 0.1, illustration.bg.withOpacity(_minOp(0.5)));
    final spP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx + w * 0.2, cy - h * 0.15, cx + w * 0.2, cy - h * 0.22, spP);
    _drawLine(canvas, cx + w * 0.17, cy - h * 0.185, cx + w * 0.23, cy - h * 0.185, spP);
  }

  // ── right: 右边（向右箭头+勾）────────────────────────────────────────────
  void _drawRight(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final arrP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55))..strokeWidth = w * 0.035..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.2, cy, cx + w * 0.15, cy, arrP);
    _drawArrowHead(canvas, cx + w * 0.15, cy, 0, w * 0.08, arrP);
    final chkP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6))..strokeWidth = w * 0.03..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(cx - w * 0.1, cy + h * 0.12)
        ..lineTo(cx - w * 0.02, cy + h * 0.18)
        ..lineTo(cx + w * 0.12, cy + h * 0.06),
      chkP,
    );
  }

  // ── round: 圆形（圆环+球）────────────────────────────────────────────
  void _drawRound(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final r = w * 0.18;
    final outP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35))..strokeWidth = w * 0.025..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(cx, cy), r, outP);
    canvas.drawCircle(Offset(cx, cy), r * 0.65, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    canvas.drawCircle(Offset(cx + r * 0.85, cy - r * 0.3), w * 0.025, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
  }

  // ── safe: 安全（盾牌+勾）────────────────────────────────────────────
  void _drawSafe(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    final shieldP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    final path = Path()
      ..moveTo(cx, cy - h * 0.2)
      ..lineTo(cx + w * 0.18, cy - h * 0.1)
      ..lineTo(cx + w * 0.15, cy + h * 0.08)
      ..quadraticBezierTo(cx, cy + h * 0.22, cx - w * 0.15, cy + h * 0.08)
      ..lineTo(cx - w * 0.18, cy - h * 0.1)
      ..close();
    canvas.drawPath(path, shieldP);
    final chkP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6))..strokeWidth = w * 0.025..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(cx - w * 0.07, cy + h * 0.01)
        ..lineTo(cx - w * 0.01, cy + h * 0.07)
        ..lineTo(cx + w * 0.09, cy - h * 0.06),
      chkP,
    );
  }

  // ── same: 相同（两个重叠方块）────────────────────────────────────────────
  void _drawSame(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final s = w * 0.16;
    canvas.drawRect(Rect.fromCenter(center: Offset(cx + w * 0.04, cy - h * 0.03), width: s, height: s),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
    canvas.drawRect(Rect.fromCenter(center: Offset(cx - w * 0.04, cy + h * 0.03), width: s, height: s),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    _drawLine(canvas, cx - w * 0.06, cy - h * 0.2, cx + w * 0.06, cy - h * 0.2,
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = w * 0.025..strokeCap = StrokeCap.round);
    _drawLine(canvas, cx - w * 0.06, cy - h * 0.14, cx + w * 0.06, cy - h * 0.14,
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = w * 0.025..strokeCap = StrokeCap.round);
  }

  // ── save: 保存（软盘）────────────────────────────────────────────
  void _drawSave(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.44;
    final bodyP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.32, height: w * 0.28), Radius.circular(w * 0.02)),
      bodyP,
    );
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.06, cy - w * 0.14, w * 0.12, w * 0.06),
        Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3)));
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.1, cy + w * 0.01, w * 0.2, w * 0.08),
        Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.2)));
    canvas.drawRect(Rect.fromLTWH(cx + w * 0.09, cy - w * 0.14, w * 0.04, w * 0.05),
        Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.4)));
  }

  // ── scary: 恐怖（鬼脸）────────────────────────────────────────────
  void _drawScary(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    final r = w * 0.18;
    final ghostP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    final path = Path()
      ..addOval(Rect.fromCenter(center: Offset(cx, cy - h * 0.02), width: r * 2, height: r * 1.6));
    path.moveTo(cx - r, cy + r * 0.5);
    path.quadraticBezierTo(cx - r * 0.65, cy + r * 0.9, cx - r * 0.33, cy + r * 0.5);
    path.quadraticBezierTo(cx, cy + r * 0.9, cx + r * 0.33, cy + r * 0.5);
    path.quadraticBezierTo(cx + r * 0.65, cy + r * 0.9, cx + r, cy + r * 0.5);
    canvas.drawPath(path, ghostP);
    canvas.drawCircle(Offset(cx - r * 0.35, cy - h * 0.05), w * 0.025, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6)));
    canvas.drawCircle(Offset(cx + r * 0.35, cy - h * 0.05), w * 0.025, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.6)));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.06), width: w * 0.08, height: w * 0.06),
        Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.5)));
  }

  // ── second: 第二（数字2+时钟）────────────────────────────────────────────
  void _drawSecond(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.44;
    final r = w * 0.18;
    final clockP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = w * 0.02..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(cx, cy), r, clockP);
    final handP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55))..strokeWidth = w * 0.02..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, cy, cx, cy - r * 0.6, handP);
    _drawLine(canvas, cx, cy, cx + r * 0.4, cy + r * 0.15, handP);
    canvas.drawCircle(Offset(cx, cy), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6)));
    _drawText(canvas, '2', cx + w * 0.18, cy - h * 0.15, w * 0.08, illustration.accent.withOpacity(_minOp(0.4)));
  }

  // ── send: 发送（纸飞机）────────────────────────────────────────────
  void _drawSend(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final planeP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    final path = Path()
      ..moveTo(cx - w * 0.2, cy + h * 0.08)
      ..lineTo(cx + w * 0.15, cy - h * 0.1)
      ..lineTo(cx - w * 0.05, cy - h * 0.02)
      ..lineTo(cx + w * 0.05, cy + h * 0.15)
      ..close();
    canvas.drawPath(path, planeP);
    final trailP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.2, cy + h * 0.08, cx - w * 0.28, cy + h * 0.12, trailP);
    _drawLine(canvas, cx - w * 0.18, cy + h * 0.12, cx - w * 0.25, cy + h * 0.17, trailP);
  }

  // ── several: 几个（多个小圆点）────────────────────────────────────────────
  void _drawSeveral(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final positions = [
      [cx - w * 0.14, cy - h * 0.08],
      [cx + w * 0.06, cy - h * 0.12],
      [cx + w * 0.16, cy + h * 0.02],
      [cx - w * 0.08, cy + h * 0.06],
      [cx + w * 0.02, cy + h * 0.14],
      [cx - w * 0.18, cy + h * 0.02],
      [cx + w * 0.12, cy + h * 0.12],
    ];
    for (int i = 0; i < positions.length; i++) {
      final s = w * (0.03 + (i % 3) * 0.008);
      canvas.drawCircle(Offset(positions[i][0], positions[i][1]), s,
          Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4 + (i % 3) * 0.1)));
    }
  }

  // ── shop: 商店（店铺/购物袋）────────────────────────────────────────────
  void _drawShop(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.44;
    final awnP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    final awnPath = Path()
      ..moveTo(cx - w * 0.2, cy - h * 0.05)
      ..lineTo(cx + w * 0.2, cy - h * 0.05)
      ..lineTo(cx + w * 0.18, cy + h * 0.02)
      ..lineTo(cx - w * 0.18, cy + h * 0.02)
      ..close();
    canvas.drawPath(awnPath, awnP);
    final stripeP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.2))..strokeWidth = w * 0.015..style = PaintingStyle.stroke;
    for (int i = -2; i <= 2; i++) {
      _drawLine(canvas, cx + i * w * 0.06, cy - h * 0.05, cx + i * w * 0.06 - w * 0.01, cy + h * 0.02, stripeP);
    }
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.05, cy + h * 0.02, w * 0.1, h * 0.16),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    _drawText(canvas, 'SHOP', cx - w * 0.1, cy - h * 0.17, w * 0.06, illustration.accent.withOpacity(_minOp(0.5)));
  }

  // ── silver: 银色（银条/闪亮）────────────────────────────────────────────
  void _drawSilver(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final topPath = Path()
      ..moveTo(cx - w * 0.14, cy - h * 0.04)
      ..lineTo(cx - w * 0.06, cy - h * 0.1)
      ..lineTo(cx + w * 0.16, cy - h * 0.1)
      ..lineTo(cx + w * 0.08, cy - h * 0.04)
      ..close();
    canvas.drawPath(topPath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.65)));
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.14, cy - h * 0.04, w * 0.22, h * 0.1),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    final sidePath = Path()
      ..moveTo(cx + w * 0.08, cy - h * 0.04)
      ..lineTo(cx + w * 0.16, cy - h * 0.1)
      ..lineTo(cx + w * 0.16, cy + h * 0.02)
      ..lineTo(cx + w * 0.08, cy + h * 0.06)
      ..close();
    canvas.drawPath(sidePath, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)));
    final spP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = 1.5..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx + w * 0.12, cy - h * 0.18, cx + w * 0.12, cy - h * 0.24, spP);
    _drawLine(canvas, cx + w * 0.095, cy - h * 0.21, cx + w * 0.145, cy - h * 0.21, spP);
  }

  // ── soft: 柔软（云朵）────────────────────────────────────────────
  void _drawSoft(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final cloudP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55));
    canvas.drawCircle(Offset(cx - w * 0.1, cy), w * 0.08, cloudP);
    canvas.drawCircle(Offset(cx + w * 0.05, cy - h * 0.04), w * 0.1, cloudP);
    canvas.drawCircle(Offset(cx + w * 0.15, cy + h * 0.01), w * 0.07, cloudP);
    canvas.drawCircle(Offset(cx - w * 0.02, cy + h * 0.04), w * 0.07, cloudP);
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.02, cy + h * 0.03), width: w * 0.34, height: w * 0.12), cloudP);
    _drawText(canvas, 'z', cx + w * 0.2, cy - h * 0.15, w * 0.06, illustration.accent.withOpacity(_minOp(0.35)));
    _drawText(canvas, 'z', cx + w * 0.26, cy - h * 0.21, w * 0.05, illustration.accent.withOpacity(_minOp(0.25)));
  }

  // ── sore: 疼痛（创可贴）────────────────────────────────────────────
  void _drawSore(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final bandP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.36, height: w * 0.14), Radius.circular(w * 0.03)),
      bandP,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.12, height: w * 0.1), Radius.circular(w * 0.015)),
      Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35)),
    );
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;
        canvas.drawCircle(Offset(cx + i * w * 0.1, cy + j * w * 0.035), w * 0.01,
            Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.2)));
      }
    }
  }

  // ── sorry: 抱歉（低头鞠躬）────────────────────────────────────────────
  void _drawSorry(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    // bowed figure: head tilted down
    final bodyP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = w * 0.025..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    // head (lower than normal, tilted forward)
    canvas.drawCircle(Offset(cx + w * 0.03, cy - h * 0.02), w * 0.045, bodyP);
    // body (leaning forward)
    _drawLine(canvas, cx, cy + h * 0.02, cx, cy + h * 0.15, bodyP);
    // arms together in front (bowing gesture)
    _drawLine(canvas, cx, cy + h * 0.06, cx - w * 0.08, cy + h * 0.1, bodyP);
    _drawLine(canvas, cx, cy + h * 0.06, cx + w * 0.08, cy + h * 0.1, bodyP);
    // legs
    _drawLine(canvas, cx, cy + h * 0.15, cx - w * 0.06, cy + h * 0.22, bodyP);
    _drawLine(canvas, cx, cy + h * 0.15, cx + w * 0.06, cy + h * 0.22, bodyP);
    // apology bubble
    final bubP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx + w * 0.18, cy - h * 0.18), width: w * 0.16, height: w * 0.08), bubP);
    _drawText(canvas, 'sorry', cx + w * 0.1, cy - h * 0.2, w * 0.05, illustration.bg.withOpacity(_minOp(0.5)));
  }

  // ── sound: 声音（声波）────────────────────────────────────────────
  void _drawSound(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.38, cy = h * 0.45;
    final spkP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55));
    canvas.drawRect(Rect.fromLTWH(cx - w * 0.06, cy - h * 0.06, w * 0.06, h * 0.12), spkP);
    final conePath = Path()
      ..moveTo(cx, cy - h * 0.06)
      ..lineTo(cx + w * 0.08, cy - h * 0.12)
      ..lineTo(cx + w * 0.08, cy + h * 0.12)
      ..lineTo(cx, cy + h * 0.06)
      ..close();
    canvas.drawPath(conePath, spkP);
    final waveP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = w * 0.02..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    for (int i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCenter(center: Offset(cx + w * 0.08, cy), width: w * 0.1 * i, height: h * 0.12 * i),
        -pi * 0.35, pi * 0.7, false, waveP);
    }
  }

  // ── speak: 说话（嘴巴+声波）────────────────────────────────────────────
  void _drawSpeak(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final mouthP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.2, height: w * 0.1), mouthP);
    canvas.drawArc(Rect.fromCenter(center: Offset(cx, cy), width: w * 0.2, height: w * 0.1), 0.2, pi - 0.4, false,
        Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.3))..strokeWidth = 1.5..style = PaintingStyle.stroke);
    final spP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4))..strokeWidth = w * 0.015..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final angle = -pi * 0.5 + (i - 1) * 0.4;
      final sx = cx + cos(angle) * w * 0.14;
      final sy = cy + sin(angle) * w * 0.12;
      _drawLine(canvas, sx, sy, sx + cos(angle) * w * 0.08, sy + sin(angle) * w * 0.08, spP);
    }
  }

  // ── special: 特别（星星/钻石）────────────────────────────────────────────
  void _drawSpecial(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final starP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    _drawStarShape(canvas, cx, cy, w * 0.18, w * 0.08, 5, starP);
    final spP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35));
    _drawStarShape(canvas, cx - w * 0.2, cy - h * 0.12, w * 0.05, w * 0.02, 4, spP);
    _drawStarShape(canvas, cx + w * 0.22, cy + h * 0.05, w * 0.04, w * 0.015, 4, spP);
    _drawStarShape(canvas, cx + w * 0.1, cy - h * 0.2, w * 0.035, w * 0.012, 4, spP);
    canvas.drawCircle(Offset(cx - w * 0.15, cy + h * 0.12), w * 0.015, Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.3)));
  }

  // ── spend: 花费（硬币+向下箭头）────────────────────────────────────────────
  void _drawSpend(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.42;
    final coinP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55));
    canvas.drawCircle(Offset(cx, cy - h * 0.04), w * 0.12, coinP);
    canvas.drawCircle(Offset(cx, cy - h * 0.04), w * 0.09, Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.2)));
    _drawText(canvas, '\$', cx - w * 0.015, cy - h * 0.07, w * 0.07, illustration.bg.withOpacity(_minOp(0.4)));
    final arrP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = w * 0.025..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx, cy + h * 0.04, cx, cy + h * 0.18, arrP);
    _drawArrowHead(canvas, cx, cy + h * 0.18, pi / 2, w * 0.06, arrP);
  }

  // ── spotted: 有斑点的（豹纹）────────────────────────────────────────────
  void _drawSpotted(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final bodyP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.4));
    canvas.drawOval(Rect.fromCenter(center: Offset(cx, cy + h * 0.02), width: w * 0.28, height: w * 0.18), bodyP);
    canvas.drawCircle(Offset(cx + w * 0.14, cy - h * 0.06), w * 0.07, bodyP);
    final earP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35));
    canvas.drawCircle(Offset(cx + w * 0.12, cy - h * 0.13), w * 0.025, earP);
    canvas.drawCircle(Offset(cx + w * 0.18, cy - h * 0.13), w * 0.025, earP);
    final spotP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.6));
    final spots = [
      [cx - w * 0.08, cy - h * 0.02],
      [cx + w * 0.02, cy + h * 0.05],
      [cx - w * 0.04, cy + h * 0.08],
      [cx + w * 0.06, cy - h * 0.05],
      [cx - w * 0.12, cy + h * 0.03],
    ];
    for (final s in spots) {
      canvas.drawCircle(Offset(s[0], s[1]), w * 0.02, spotP);
    }
    final tailP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.35))..strokeWidth = w * 0.02..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromLTWH(cx - w * 0.22, cy - h * 0.05, w * 0.1, h * 0.15), pi * 0.3, pi * 1.2, false, tailP);
  }

  // ── square: 正方形（方块+网格）────────────────────────────────────────────
  void _drawSquare(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.45;
    final s = w * 0.28;
    canvas.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: s, height: s),
        Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5)));
    final gridP = Paint()..color = _dc(illustration.bg).withOpacity(_minOp(0.25))..strokeWidth = 1.2;
    _drawLine(canvas, cx - s / 2, cy, cx + s / 2, cy, gridP);
    _drawLine(canvas, cx, cy - s / 2, cx, cy + s / 2, gridP);
    final markP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.65))..strokeWidth = w * 0.02..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - s / 2, cy - s / 2, cx - s / 2 + w * 0.04, cy - s / 2, markP);
    _drawLine(canvas, cx - s / 2, cy - s / 2, cx - s / 2, cy - s / 2 + w * 0.04, markP);
    _drawLine(canvas, cx + s / 2, cy + s / 2, cx + s / 2 - w * 0.04, cy + s / 2, markP);
    _drawLine(canvas, cx + s / 2, cy + s / 2, cx + s / 2, cy + s / 2 - w * 0.04, markP);
  }

  // ── start: 开始（起跑线/旗帜）────────────────────────────────────────────
  void _drawStart(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5, cy = h * 0.44;
    final poleP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.5))..strokeWidth = w * 0.025..strokeCap = StrokeCap.round;
    _drawLine(canvas, cx - w * 0.04, cy - h * 0.22, cx - w * 0.04, cy + h * 0.15, poleP);
    final flagP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.55));
    final flagPath = Path()
      ..moveTo(cx - w * 0.04, cy - h * 0.22)
      ..lineTo(cx + w * 0.14, cy - h * 0.17)
      ..lineTo(cx - w * 0.04, cy - h * 0.12)
      ..close();
    canvas.drawPath(flagPath, flagP);
    final chevP = Paint()..color = _dc(illustration.accent).withOpacity(_minOp(0.45))..strokeWidth = w * 0.02..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()
        ..moveTo(cx - w * 0.12, cy + h * 0.08)
        ..lineTo(cx, cy + h * 0.03)
        ..lineTo(cx + w * 0.12, cy + h * 0.08),
      chevP,
    );
  }

  // ── missing helper methods ─────────────────────────────────────────────────

  void _drawBlondE(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    // blonde person: head + hair
    final skin = Paint()..color = const Color(0xFFFFDBAC);
    final hair = Paint()..color = const Color(0xFFFFD700);
    final body = Paint()..color = _dc(illustration.accent);
    // body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.65), width: w * 0.28, height: h * 0.3),
        Radius.circular(w * 0.06),
      ),
      body,
    );
    // head
    canvas.drawCircle(Offset(w * 0.5, h * 0.38), w * 0.1, skin);
    // hair
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.33), width: w * 0.24, height: w * 0.2),
      pi, pi, false,
      hair..style = PaintingStyle.fill,
    );
    // hair side strands
    canvas.drawRect(Rect.fromLTWH(w * 0.37, h * 0.35, w * 0.04, h * 0.12), hair);
    canvas.drawRect(Rect.fromLTWH(w * 0.59, h * 0.35, w * 0.04, h * 0.12), hair);
    // face
    _drawFace(canvas, w * 0.5, h * 0.38, w * 0.08, skin.color);
  }

  void _drawGear(Canvas canvas, double cx, double cy, double r, int teeth, Paint paint) {
    final path = Path();
    final innerR = r * 0.65;
    for (int i = 0; i < teeth; i++) {
      final a1 = i * 2 * pi / teeth;
      final a2 = (i + 0.35) * 2 * pi / teeth;
      final a3 = (i + 0.65) * 2 * pi / teeth;
      final a4 = (i + 1) * 2 * pi / teeth;
      if (i == 0) path.moveTo(cx + cos(a1) * innerR, cy + sin(a1) * innerR);
      path.lineTo(cx + cos(a2) * innerR, cy + sin(a2) * innerR);
      path.lineTo(cx + cos(a2) * r, cy + sin(a2) * r);
      path.lineTo(cx + cos(a3) * r, cy + sin(a3) * r);
      path.lineTo(cx + cos(a3) * innerR, cy + sin(a3) * innerR);
      path.lineTo(cx + cos(a4) * innerR, cy + sin(a4) * innerR);
    }
    path.close();
    canvas.drawPath(path, paint);
    // center hole
    canvas.drawCircle(Offset(cx, cy), r * 0.2, Paint()..color = _dc(illustration.bg));
  }

  void _drawArrowLine(Canvas canvas, double x1, double y1, double x2, double y2, Paint paint) {
    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    // arrowhead
    final angle = atan2(y2 - y1, x2 - x1);
    final headLen = paint.strokeWidth * 4;
    final a1 = angle - pi / 6;
    final a2 = angle + pi / 6;
    final path = Path()
      ..moveTo(x2, y2)
      ..lineTo(x2 - cos(a1) * headLen, y2 - sin(a1) * headLen)
      ..moveTo(x2, y2)
      ..lineTo(x2 - cos(a2) * headLen, y2 - sin(a2) * headLen);
    canvas.drawPath(path, paint);
  }

  TextPainter _textPainter(String text, {double? fontSize, Color? color}) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize ?? 14, color: color ?? Colors.black, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp;
  }

  void _drawFlower(Canvas canvas, double cx, double cy, double r, Color color) {
    final petalPaint = Paint()..color = color;
    for (int i = 0; i < 5; i++) {
      final angle = i * 2 * pi / 5 - pi / 2;
      final px = cx + cos(angle) * r * 0.7;
      final py = cy + sin(angle) * r * 0.7;
      if (isDark) {
        canvas.drawCircle(Offset(px, py), r * 0.52, _outlineP);
      }
      canvas.drawCircle(Offset(px, py), r * 0.5, petalPaint);
    }
    if (isDark) {
      canvas.drawCircle(Offset(cx, cy), r * 0.37, _outlineP);
    }
    canvas.drawCircle(Offset(cx, cy), r * 0.35, Paint()..color = Colors.yellow);
  }

  // ── fallback: 默认圆形 ────────────────────────────────────────────────────
  void _drawFallback(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final r = w * 0.18;
    if (isDark) {
      canvas.drawCircle(Offset(w / 2, h * 0.45), r, _outlineP);
    }
    canvas.drawCircle(
      Offset(w / 2, h * 0.45),
      r,
      Paint()..color = _dc(illustration.bg).withOpacity(_minOp(isDark ? 0.8 : 0.6)),
    );
  }

  @override
  bool shouldRepaint(covariant WordIllustrationPainter old) =>
      old.t != t || old.word != word || old.illustration != illustration || old.isDark != isDark;
}
