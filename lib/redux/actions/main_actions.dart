import './../store/main_store.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audio_cache.dart';

class Player {
  final bool play;

  Player(this.play);
  PlayerState isPlaying(PlayerState prevState, bool play) {
    prevState.playing = play;
    return prevState;
  }
}

class Audioplayer {
  int duration;
  int current;
  bool isLocal;
  Audioplayer(this.isLocal,this.current, this.duration);
  PlayerState durationInPlay(PlayerState prevState,bool local, int current, int duration) {
    prevState.currentDuration = current;
    prevState.totalDuration = duration;
    prevState.local=isLocal;
    return prevState;
  }
}

class Expanding {
  final bool expanded;
  Expanding(this.expanded);
  PlayerState expanding(PlayerState prevState, bool expanding) {
    prevState.expand = expanding;
    return prevState;
  }
}

class SongChooser {
  final bool nextbuttonPress;
  final bool prevbuttonPress;
  SongChooser(this.nextbuttonPress, this.prevbuttonPress);
  PlayerState songNextPrev(PlayerState prevState, bool next, bool prev) {
    prevState.nextbuttonPress = next;
    prevState.prevbuttonPress = prev;
    // print("sadder:${prevState.prevbuttonPress}");
    return prevState;
  }
}

class VolumeC {
  final bool volumeBar;
  final int volume;
  VolumeC(this.volumeBar, this.volume);
  // final playBtnSkew;
  PlayerState volumeControl(PlayerState prevState, bool volumeBar, int volume) {
    prevState.volumeBar = volumeBar;
    if (volume > 100) {
      prevState.volume = 100;
    } else if (prevState.volume < 0) {
      prevState.volume = 0;
    } else {
      prevState.volume = volume;
    }
    return prevState;
  }
}
