import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

Future<String?> getPlatformTempDir() async {
  final dir = await Directory.systemTemp.createTemp('tts_');
  return dir.path;
}

Future<void> playTts(
    AudioPlayer player, String url, String? tempDir) async {
  final client = HttpClient();
  client.connectionTimeout = const Duration(seconds: 10);
  final request = await client.getUrl(Uri.parse(url));
  request.headers.set('User-Agent', 'Mozilla/5.0');
  request.headers.set('Referer', 'https://fanyi.baidu.com/');
  final response = await request.close();

  if (response.statusCode == 200) {
    final filePath =
        '$tempDir/tts_${DateTime.now().millisecondsSinceEpoch}.mp3';
    final file = File(filePath);
    final bytes = await response.fold<List<int>>(
        [], (prev, chunk) => prev..addAll(chunk));
    await file.writeAsBytes(bytes);

    if (bytes.length > 100) {
      await player.play(DeviceFileSource(filePath));
    }
  }
  client.close();
}
