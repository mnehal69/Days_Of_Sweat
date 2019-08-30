import 'dart:async';

import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/FMusic/main_screen/playlist/playlistWidget.dart';
import 'package:days_of_sweat/src/screen/common/ReusableCode.dart';
import 'package:days_of_sweat/src/screen/common/hex_color.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'artist/artist_slider/App_Bar.dart';
import 'artist/artist_slider/Back_bar.dart';
import 'artist/artist_slider/Slider.dart';
import 'artist/artist_slider/Title_bar.dart';
import 'music/Music.dart';

class FMusicMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FMusicMainState();
  }
}

class FMusicMainState extends State<FMusicMain> {
  var dragged = true;
  var code = ResusableCode();
  Timer _timer;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        // For iOS
        statusBarBrightness: Brightness.light,
        // For Android M and higher
        statusBarIconBrightness: Brightness.light,
        statusBarColor: HexColor("#1a1b1f"),
      ),
    );
  }

  Widget artist() {
    return Container(
      //color: Colors.blueGrey,
      margin:
          EdgeInsets.only(top: code.percentageToNumber(context, "6%", true)),
      child: Column(
        children: <Widget>[
          FBackBar(),
          FAppBar(),
          FTitleBar(),
          FSlider(),
        ],
      ),
    );
  }

  Widget playlist() {
    return Container(
      //color: Colors.blueGrey,
      margin:
          EdgeInsets.only(top: code.percentageToNumber(context, "6%", true)),
      child: Column(
        children: <Widget>[
          FBackBar(),
          FAppBar(),
          FTitleBar(),
          PlayListWidget(),
        ],
      ),
    );
  }

  Widget music() {
    return Container(
      child: MusicList(),
    );
  }

  local(int selected) {
    if (selected == 1) {
      return artist();
    }
    if (selected == 2) {
      return playlist();
    }
    if (selected == 3) {
      return music();
    }
  }

  Widget online() {
    return Container(
      //color: Colors.blueGrey,
      margin:
          EdgeInsets.only(top: code.percentageToNumber(context, "6%", true)),
      child: Column(
        children: <Widget>[
          FBackBar(),
          FAppBar(),
        ],
      ),
    );
  }

  screen(PlayerState state) {
    if (state.screen == 1) {
      return local(state.selected);
    } else {
      return online();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<PlayerState, PlayerState>(
      converter: (store) => store.state,
      onInit: (state) {
        _timer = new Timer(const Duration(milliseconds: 1000), () {
          setState(() {
            dragged = false;
          });
          _timer.cancel();
        });
      },
      onDispose: (store) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
              // For iOS
              statusBarBrightness: Brightness.dark,
              // For Android M and higher
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: Colors.white),
        );
      },
      builder: (context, state) {
        // return artist();
        return Material(
          child: Container(
            color: HexColor("#1a1b1f"),
            child: screen(state),
          ),
        );
        // return ArtistPlayList();
        // return PlayerScreen();
      },
    );
  }
}
