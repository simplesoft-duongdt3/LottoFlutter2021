import 'package:assets_audio_player/assets_audio_player.dart';

class AudioManager {
  Future<void> playAudio(int number, String voice) async {
    final assetsAudioPlayer = AssetsAudioPlayer();

    await assetsAudioPlayer.open(
      Audio("assets/audios/${number}_$voice.mp3"),
      autoStart: true,
    );
  }

  Future<void> playHelloAudio(String voice) async {
    final assetsAudioPlayer = AssetsAudioPlayer();

    await assetsAudioPlayer.open(
      Audio("assets/audios/hello_$voice.mp3"),
      autoStart: true,
    );
  }
}
