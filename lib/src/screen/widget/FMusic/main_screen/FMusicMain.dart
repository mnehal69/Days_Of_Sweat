import 'dart:async';

import 'package:days_of_sweat/redux/actions/main_actions.dart';
import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/PlayerScreen.dart';
import 'package:days_of_sweat/src/screen/widget/FMusic/main_screen/artist/artist_playlist/artist_playlist.dart';
import 'package:days_of_sweat/src/screen/widget/hex_color.dart';
import 'package:days_of_sweat/src/screen/widget/player/PlayerImageSlider.dart';
import 'package:days_of_sweat/src/screen/widget/reuseable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'artist/artist_slider/App_Bar.dart';
import 'artist/artist_slider/Back_bar.dart';
import 'artist/artist_slider/Slider.dart';
import 'artist/artist_slider/Title_bar.dart';

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
      builder: (context, state) {
        // return artist();
        return Material(
          child: Container(
            color: HexColor("#1a1b1f"),
            child: artist(),
          ),
        );
        // return ArtistPlayList();
        // return PlayerScreen();
      },
    );
  }
}
