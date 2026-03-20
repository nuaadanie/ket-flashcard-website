import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

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
    final dir = await getTemporaryDirectory();
    _tempDir = dir.path;

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

      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);
      final request = await client.getUrl(Uri.parse(url));
      request.headers.set('User-Agent', 'Mozilla/5.0');
      request.headers.set('Referer', 'https://fanyi.baidu.com/');
      final response = await request.close();

      if (response.statusCode == 200) {
        final filePath =
            '${_tempDir ?? "/tmp"}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3';
        final file = File(filePath);
        final bytes = await response.fold<List<int>>(
            [], (prev, chunk) => prev..addAll(chunk));
        await file.writeAsBytes(bytes);

        if (bytes.length > 100) {
          await _audioPlayer.play(DeviceFileSource(filePath));
          final timeoutSec = (text.length * 0.2 + 8).toInt();
          await _speakCompleter?.future.timeout(
            Duration(seconds: timeoutSec),
            onTimeout: () {
              _isSpeaking = false;
              _completeSpeaking();
            },
          );
        } else {
          _isSpeaking = false;
          _completeSpeaking();
        }
      } else {
        _isSpeaking = false;
        _completeSpeaking();
      }
      client.close();
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
