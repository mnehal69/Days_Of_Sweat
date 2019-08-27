import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:days_of_sweat/src/screen/widget/Song/song.dart';
import 'package:flutter/material.dart';

class PlayerState {
  bool playing = false;
  bool nextbuttonPress = false;
  bool prevbuttonPress = false;

  bool volumeBarVisible = false;
  int volume = 100;

  bool fullPlayerDispose = false;
  AudioPlayer advancedPlayer = new AudioPlayer();
  AudioCache audioCache = new AudioCache();

  bool isAlbum = false;
  //false
  int currentDuration = 0;
  int totalDuration = 0;
  String currentTitle = "";
  String currentAlbum = "";
  String currentArtist = "";
  String currenturi = "";
  int index = -1;
  bool last = false;
  PageController controller = PageController(
    initialPage: 0,
    viewportFraction: 0.8,
  );

  //true
  List<List<String>> artistList = [];
  List<List<Song>> artistSongList = [];
  int currentAlbumIndex = 0;
  int length = -1;
  bool local = false;
  bool same = false;
  bool storageAccess = false;

  List<Song> songlist = [];

  String status = 'hidden';
  bool dragging = false;
  bool appbarshown = false;
}
