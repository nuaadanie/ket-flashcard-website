import 'package:audioplayers/audioplayers.dart';

Future<String?> getPlatformTempDir() async {
  return null;
}

Future<void> playTts(
    AudioPlayer player, String url, String? tempDir) async {
  await player.play(UrlSource(url));
}
