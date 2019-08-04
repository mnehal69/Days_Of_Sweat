 import 'package:audioplayers/audioplayers.dart';
 import 'package:audioplayers/audio_cache.dart';

class PlayerState {
  bool playing = false;
  bool nextbuttonPress = false;
  bool prevbuttonPress = false;
  bool volumeBar = false;
  int volume = 0;
  bool expand = false;
  AudioPlayer advancedPlayer = new AudioPlayer();
   AudioCache audioCache = new AudioCache();
  int currentDuration = 0;
  int totalDuration = 0;
  bool local = true;
}
