import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'speech_stub.dart'
    if (dart.library.html) 'speech_web.dart';

/// 统一 TTS 服务，使用百度翻译发音接口
/// accent: 'us' 美式(lan=en), 'uk' 英式(lan=uk)
/// voice: 0=女声, 1=男声, 3=情感男声, 4=情感女声
class SpeechService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSpeaking = false;
  Completer<void>? _speakCompleter;
  String? _tempDir;
  String accent = 'us';
  int voice = 0; // 默认女声

  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    _tempDir = await getPlatformTempDir();

    _audioPlayer.onPlayerComplete.listen((_) {
      _isSpeaking = false;
      _completeSpeaking();
    });
  }

  void _completeSpeaking() {
    if (_speakCompleter != null && !_speakCompleter!.isCompleted) {
      _speakCompleter!.complete();
    }
    _speakCompleter = null;
  }

  Future<void> speak(String text) async {
    await stop();
    await Future.delayed(const Duration(milliseconds: 50));

    _isSpeaking = true;
    _speakCompleter = Completer<void>();

    try {
      final encoded = Uri.encodeComponent(text);
      final lan = accent == 'uk' ? 'uk' : 'en';
      final url =
          'https://fanyi.baidu.com/gettts?lan=$lan&text=$encoded&spd=3&source=web&per=$voice';

      await playTts(_audioPlayer, url, _tempDir);

      final timeoutSec = (text.length * 0.2 + 8).toInt();
      await _speakCompleter?.future.timeout(
        Duration(seconds: timeoutSec),
        onTimeout: () {
          _isSpeaking = false;
          _completeSpeaking();
        },
      );
    } catch (e) {
      _isSpeaking = false;
      _completeSpeaking();
    }
  }

  Future<void> stop() async {
    _isSpeaking = false;
    _completeSpeaking();
    try {
      await _audioPlayer.stop();
    } catch (_) {}
  }

  void dispose() {
    _isSpeaking = false;
    _completeSpeaking();
    _audioPlayer.dispose();
  }
}
