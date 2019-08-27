import 'package:days_of_sweat/src/screen/widget/Song/song.dart';
import 'package:flutter/widgets.dart';
import './../store/main_store.dart';

class AudioPlaying {
  final bool playing;
  final int currentduration;
  AudioPlaying(this.playing, this.currentduration);
  PlayerState audioPlaying(PlayerState prevState, bool playing, int duration) {
    prevState.playing = playing;
    prevState.currentDuration = duration;
    return prevState;
  }
}

class PlayerController {
  final PageController controller;
  PlayerController({this.controller});
  PlayerState isLast(PlayerState prevState, PageController controller) {
    prevState.controller = controller;
    return prevState;
  }
}

class Dispose {
  final bool dispose;
  final int counter;
  Dispose({this.dispose, this.counter});
  PlayerState isDispose(PlayerState prevState, bool dispose, int count) {
    prevState.fullPlayerDispose = dispose;
    prevState.counter = count;
    // if (dispose) {
    //   prevState.advancedPlayer.release();
    // }
    return prevState;
  }
}

//Player
class Player {
  bool isAlbum;
  int index;
  int duration;
  Player({this.isAlbum, this.index, this.duration = 0});
  PlayerState intialized(
      PlayerState prevState, bool isAlbum, int indexno, int duration) {
    int index = indexno;
    // print(
    // "List:${prevState.artistSongList[prevState.currentAlbumIndex].toString()}");
    prevState.isAlbum = isAlbum;
    prevState.index = index;
    prevState.playing = true;
    prevState.currentDuration = 0;
    prevState.last = false;
    prevState.totalDuration = 0;
    if (isAlbum) {
      prevState.length =
          prevState.artistSongList[prevState.currentAlbumIndex].length;
      if (prevState.index >
          prevState.artistSongList[prevState.currentAlbumIndex].length - 1) {
        prevState.index = 0;
        prevState.last = true;
        index = 0;
      }
      prevState.totalDuration =
          prevState.artistSongList[prevState.currentAlbumIndex][index].duration;

      prevState.currentTitle =
          prevState.artistSongList[prevState.currentAlbumIndex][index].title;
      prevState.currenturi =
          prevState.artistSongList[prevState.currentAlbumIndex][index].uri;
      prevState.currentArtist =
          prevState.artistSongList[prevState.currentAlbumIndex][index].artist;
      prevState.currentAlbum =
          prevState.artistSongList[prevState.currentAlbumIndex][index].albumArt;
    } else {
      prevState.length = prevState.songlist.length;
      if (prevState.index > prevState.songlist.length - 1) {
        prevState.index = 0;
        prevState.last = true;
        index = 0;
      }
      prevState.totalDuration = prevState.songlist[index].duration;
      prevState.currentTitle = prevState.songlist[index].title;
      prevState.currenturi = prevState.songlist[index].uri;
      prevState.currentArtist = prevState.songlist[index].artist;
      prevState.currentAlbum = prevState.songlist[index].albumArt;
    }

    prevState.advancedPlayer.release();
    prevState.advancedPlayer.play(
      prevState.currenturi,
      isLocal: true,
      stayAwake: true,
      position: Duration(milliseconds: duration),
    );
    // prevState.advancedPlayer.onPlayerError.listen((msg) {
    //   print('audioPlayer error : $msg');
    //   this.intialized(prevState, isAlbum, 0);
    // });
    return prevState;
  }
}

class ArtistAlbum {
  final List<List<String>> artistList;
  final List<List<Song>> artistSongList;
  final int albumindex;
  ArtistAlbum(this.artistList, this.artistSongList, this.albumindex);

  PlayerState intialized(PlayerState prevState, List<List<Song>> artistSong,
      final List<List<String>> artistList, int albumIndex) {
    prevState.artistSongList = artistSong;
    prevState.artistList = artistList;
    prevState.currentAlbumIndex = albumIndex;
    prevState.length = prevState.artistSongList[albumIndex].length;
    return prevState;
  }
}

//Full Playlist
class SongList {
  final List<Song> songlist;
  final int index;

  SongList(this.songlist, this.index);
  PlayerState intialized(PlayerState prevState, List<Song> song, int index) {
    prevState.songlist = song;
    prevState.index = index;
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

class VolumeControl {
  final bool volumeBarShow;
  final int volume;
  VolumeControl(this.volumeBarShow, this.volume);
  // final playBtnSkew;
  PlayerState volumeControl(PlayerState prevState, bool volumeBar, int volume) {
    prevState.volumeBarVisible = volumeBar;
    if (volume > 100) {
      prevState.volume = 100;
    } else if (prevState.volume < 0) {
      prevState.volume = 0;
    } else {
      prevState.volume = volume;
    }
    prevState.advancedPlayer.setVolume(volume / 100);
    // Volume.setVol(15);
    return prevState;
  }
}

class ScrollBar {
  final bool shown;
  ScrollBar(this.shown);
  PlayerState show(PlayerState prevState, bool show) {
    prevState.appbarshown = show;
    return prevState;
  }
}

class ChangeSong {
  final int btn; //0==none -1 === prev 1==next
  ChangeSong({this.btn});
  PlayerState pressed(PlayerState prevState, int btn) {
    if (btn == 1) {
      prevState.advancedPlayer.release();
      prevState.nextbuttonPress = true;
      prevState.prevbuttonPress = false;
      // prevState.currentDuration = 0;
    } else if (btn == -1) {
      prevState.advancedPlayer.release();
      prevState.nextbuttonPress = false;
      prevState.prevbuttonPress = true;
      // prevState.currentDuration = 0;
    } else {
      prevState.prevbuttonPress = false;
      prevState.nextbuttonPress = false;
    }
    return prevState;
  }
}
