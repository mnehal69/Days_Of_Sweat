import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:days_of_sweat/src/screen/Calender/DayModel.dart';
import 'package:days_of_sweat/src/screen/Database/PlayList.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/common/song.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';

import 'package:flutter/material.dart';

class MainState {
  ///////////////////////////////////////////////
  //                                          //
  //             CALENDER STATE               //
  /////////////////////////////////////////////
  List<DayModel> calenderlist = [];
  int calenderSelectedIndex = -1;
  int monthIndex = -1;
  int yearIndex = -1;
  List year = ResusableCode().positiveIntegers.skip(1).take(30).toList();
  var finish = [];
  List<Widget> generatedCalenderList = [];
  ///////////////////////////////////////////////
  //                                          //
  //             PLAYERSTATE                  //
  /////////////////////////////////////////////
  bool playing = false;
  bool nextbuttonPress = false;
  bool prevbuttonPress = false;

  bool volumeBarVisible = false;
  int volume = 100;

  bool fullPlayerDispose = false;
  int counter = -1;
  AudioPlayer advancedPlayer = new AudioPlayer();
  AudioCache audioCache = new AudioCache();

  bool isAlbum = false;
  bool changed = true;
  int currentDuration = 0;
  int totalDuration = 0;
  int currentId = -1;
  String currentTitle = "";
  String currentAlbum = "";
  String currentArtist = "";
  String currenturi = "";
  bool currentfavourite = false;
  int index = -1;
  bool last = false;
  PageController controller = PageController(
    initialPage: 0,
    viewportFraction: 0.8,
  );

  //true
  List<List<String>> artistList = [];
  List<List<Song>> artistSongList = [];

  List<List<String>> playListAlbumArtList = [];
  List<List<Song>> playList = [];
  List<List<PlayListModel>> playModelList = [];
  List<String> type = [];
  int typeIndex = -1;
  List<Widget> refreshlist;

  List<Song> currentPlayingList = [];
  int currentAlbumIndex = 0;
  int length = -1;
  bool local = false;
  bool same = false;
  bool storageAccess = false;

  List<Song> songlist = [];

  String status = 'hidden';
  bool dragging = false;
  bool appbarshown = false;

  int selected = 1;
  int screen = 1;
  toJson() {
    return {
      "playing": this.playing,
      "nextBtn": this.nextbuttonPress,
      "prevBtn": this.prevbuttonPress,
      "volumeBarVisible": this.volumeBarVisible,
      "volume": this.volume,
      "monthIndex": this.monthIndex,
      "yearIndex": this.yearIndex,
      // 'SongList': this.songlist.toString(),
      // "ShuffleList": this.playList[0].toString(),
      "currentAlbumIndex": this.currentAlbumIndex,
      "index": this.index,
      "calenderlist": this.calenderlist.toString(),
      "calenderlistLength": this.calenderlist.length,
      // "artistList": this.artistList.toString(),
      //"artistSongList": this.artistSongList.toString(),
    };
  }
}
