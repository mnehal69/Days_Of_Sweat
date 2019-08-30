import 'package:days_of_sweat/src/screen/Database/PlayList.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/common/song.dart';
import 'package:flutter/widgets.dart';
import './../store/main_store.dart';

class AudioPlaying {
  final bool playing;
  final int currentduration;
  AudioPlaying(this.playing, this.currentduration);
  PlayerState audioPlaying(PlayerState prevState, bool playing, int duration) {
    prevState.playing = playing;
    prevState.currentDuration = duration;
    // prevState.changed = false;
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
  dynamic list;
  Player({this.isAlbum, this.index, this.duration = 0, this.list = 0});
  PlayerState intialized(PlayerState prevState, bool isAlbum, int indexno,
      int duration, dynamic list) {
    int index = indexno;
    List listvar;
    if (list == 0) {
      if (isAlbum) {
        listvar = new List<Song>.from(
            prevState.artistSongList[prevState.currentAlbumIndex]);
      } else {
        listvar = new List<Song>.from(prevState.songlist);
      }
    } else {
      listvar = new List<Song>.from(list);
    }
    prevState.currentPlayingList = listvar;
    prevState.isAlbum = isAlbum;
    prevState.index = index;
    prevState.playing = true;
    prevState.currentDuration = 0;
    prevState.last = false;
    prevState.totalDuration = 0;
    prevState.length = listvar.length;
    if (prevState.index > listvar.length - 1) {
      prevState.index = 0;
      prevState.last = true;
      index = 0;
    }
    prevState.changed = true;
    prevState.totalDuration = listvar[index].duration;
    prevState.currentId = listvar[index].id;
    prevState.currentTitle = listvar[index].title;
    prevState.currenturi = listvar[index].uri;
    prevState.currentArtist = listvar[index].artist;
    prevState.currentAlbum = listvar[index].albumArt;

    prevState.advancedPlayer.release();
    prevState.advancedPlayer.play(
      prevState.currenturi,
      isLocal: true,
      stayAwake: true,
      position: Duration(milliseconds: duration),
    );

    return prevState;
  }
}

class ArtistAlbum {
  final List<List<String>> artistList;
  final List<List<Song>> artistSongList;
  final int albumindex;
  ArtistAlbum(this.artistList, this.artistSongList, this.albumindex);
  toJson() {
    return {
      'artistList': this.artistList.toString(),
      "artistSongList": this.artistSongList.toString(),
      "albumIndex": this.albumindex
    };
  }

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
  toJson() {
    return {
      'SongList': this.songlist.toString(),
      "index": this.index,
    };
  }

  PlayerState intialized(PlayerState prevState, List<Song> song, int index) {
    List<Song> shuffled = new List<Song>.from(song);
    prevState.songlist = song;
    prevState.index = index;
    shuffled.shuffle();
    shuffled.shuffle();
    prevState.playList.add(shuffled);
    prevState.type.add("Random");
    return prevState;
  }
}

// List shuffle(List items) {
//   var random = new Random();
//   // Go through all elements.
//   for (var i = items.length - 1; i > 0; i--) {
//     // Pick a pseudorandom number according to the list length
//     var n = random.nextInt(i + 1);
//     var temp = items[i];
//     items[i] = items[n];
//     items[n] = temp;
//   }
//   return items;
// }

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
  final bool isAlbum;
  ScrollBar({this.shown, this.isAlbum = true});
  PlayerState show(PlayerState prevState, bool show, bool isAlbum) {
    prevState.appbarshown = show;
    prevState.isAlbum = isAlbum;
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

class ScreenAction {
  int selected;
  bool subScreen;
  ScreenAction({this.selected, this.subScreen = true});
  PlayerState screen(PlayerState prevState, int select, bool subScreen) {
    if (subScreen) {
      prevState.selected = select;
    } else {
      prevState.screen = select;
    }

    return prevState;
  }
}

class PlayListSection {
  int typeindex;
  List<String> type;
  List<List<Song>> playList;
  List<List<PlayListModel>> playModelList = [];

  PlayListSection({
    this.type,
    this.typeindex = -1,
    this.playList,
    this.playModelList,
  });

  PlayerState clicked(PlayerState prevState, int typeindex, List<String> type,
      List<List<Song>> playList, List<List<PlayListModel>> playModelList) {
    prevState.type = type;
    prevState.typeIndex = typeindex;
    prevState.playList.addAll(playList);
    prevState.type.insert(0, "Random");
    prevState.playModelList = playModelList;
    return prevState;
  }
}

class Like {
  bool like;
  Like({this.like});
  PlayerState isFavourite(PlayerState prevState, bool like) {
    prevState.currentfavourite = like;
    prevState.changed = false;
    return prevState;
  }
}

class RefreshPlayList {
  List<Widget> list;
  RefreshPlayList({this.list});

  PlayerState resfresh(PlayerState prevState, List<Widget> list) {
    prevState.refreshlist = list;
    return prevState;
  }
}
