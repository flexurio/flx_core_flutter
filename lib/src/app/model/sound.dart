import 'package:just_audio/just_audio.dart';

class Sound {
  static final player = AudioPlayer();

  static Future<void> alert() async {
    await player.setAsset('asset/sound/alert.mp3');
    await player.play();
  }

  // static Future<void> success() async {
  //   await player.setAsset('asset/sound/success.mp3');
  //   await player.play();
  // }

  // static Future<void> fail() async {
  //   await player.setAsset('asset/sound/fail.mp3');
  //   await player.play();
  // }
}
