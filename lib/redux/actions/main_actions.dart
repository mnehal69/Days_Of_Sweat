import './../store/main_store.dart';
import './../../src/screen/widget/Song/song.dart';
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

class Music {
  final List<Song> songlist;
  final int index;
  final bool playing;
  Music(this.songlist, this.index, this.playing);
  PlayerState list(
      PlayerState prevState, List<Song> songlis, int index, bool playing) {
    prevState.songlist = songlis;
    if (index < 0 || index > prevState.songlist.length - 1) {
      prevState.index = 0;
      prevState.playing = !playing;
    } else {
      prevState.index = index;
      prevState.playing = playing;
    }
    prevState.currentDuration = 0;
    if (songlis.isEmpty) {
      prevState.totalDuration = 0;
    } else {
      prevState.totalDuration = prevState.songlist[index].duration;
    }

    return prevState;
  }
}

class Audioplayer {
  int duration;
  int current;
  bool isLocal;
  Audioplayer(this.isLocal, this.current, this.duration);
  PlayerState durationInPlay(
      PlayerState prevState, bool local, int current, int duration) {
    prevState.currentDuration = current;
    prevState.totalDuration = duration;
    prevState.local = isLocal;
    return prevState;
  }
}

class Permission {
  bool storage;
  Permission(this.storage);
  PlayerState isaccesed(PlayerState prevState, bool storage) {
    prevState.storageAccess = storage;
    return prevState;
  }
}

class Expanding {
  final bool expanded;
  final bool dragging;
  Expanding(this.expanded,this.dragging);
  PlayerState expanding(PlayerState prevState, bool expanding,bool drag) {
    prevState.expand = expanding;
    prevState.dragging=drag;
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
    if (next) {
      prevState.index = prevState.index + 1;
      if (prevState.index > prevState.songlist.length - 1) {
        prevState.index = 0;
      }
    } else {
      prevState.index = prevState.index - 1;
      if (prevState.index < 0) {
        prevState.index = 0;
      }
    }
    prevState.currentDuration = 0;
    prevState.totalDuration = prevState.songlist[prevState.index].duration;
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
