import 'dart:async';
import 'dart:math';

import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/widget/Song/song.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux_navigation/flutter_redux_navigation.dart';
import 'package:media_notification/media_notification.dart';
import 'package:permission_handler/permission_handler.dart';
import 'hex_color.dart';
import './../../../redux/actions/main_actions.dart';

class ResusableCode {
  //check if the parameter color is hex code or Colors properties and return it.
  //----------------Example----------------------
  //|                                           |
  //|   colorcheck("#3b5998");                  |
  //|   colorcheck(Colors.red);                 |
  //|-------------------------------------------|
  bool permission = false;
  Timer timer;

  dynamic colorcheck(color) {
    if (color is Color) {
      return color;
    } else {
      return HexColor(color);
    }
  }

  String durationfromMilliSeconds(int mili) {
    // int milliseconds = 205427;
    DateTime total = new DateTime.fromMillisecondsSinceEpoch(mili);
    int minutes = total.minute;
    int second = total.second;
    //print("Minutes:$minutes.$second");
    if (second < 10) {
      //print("TOTAL:${second}");
      return "$minutes:0$second";
    }
    return "$minutes:$second";
  }

  void showNotification(PlayerState state) async {
    try {
      await MediaNotification.show(
        title: state.currentTitle,
        author: state.currentArtist,
        play: state.playing,
        albumArt: state.currentAlbum,
      );
    } on PlatformException {}
  }

  void closeNotification() async {
    try {
      await MediaNotification.hide();
    } on PlatformException {}
  }

  void mediaNotification(context, PlayerState state) {
    MediaNotification.setListener('play', () {
      state.advancedPlayer.resume();
      StoreProvider.of<PlayerState>(context).dispatch(
        AudioPlaying(true, state.currentDuration),
      );
    });
    MediaNotification.setListener('pause', () {
      state.advancedPlayer.pause();
      StoreProvider.of<PlayerState>(context).dispatch(
        AudioPlaying(false, state.currentDuration),
      );
    });
    MediaNotification.setListener('prev', () {
      StoreProvider.of<PlayerState>(context).dispatch(
        Player(isAlbum: state.isAlbum, index: state.index - 1),
      );
      state.controller.animateToPage(state.index - 1,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
    });
    MediaNotification.setListener('next', () {
      StoreProvider.of<PlayerState>(context).dispatch(
        Player(isAlbum: state.isAlbum, index: state.index + 1),
      );
      state.controller.animateToPage(state.index + 1,
          curve: Curves.ease, duration: Duration(milliseconds: 500));
    });

    MediaNotification.setListener('closing', () {
      MediaNotification.hide();
      state.advancedPlayer.stop();
      StoreProvider.of<PlayerState>(context)
          .dispatch(AudioPlaying(false, state.currentDuration));
      //print("COOL BITCH");
    });
  }

  void playingFromintial(context, PlayerState state, bool isAlbum) async {
    StoreProvider.of<PlayerState>(context)
        .dispatch(Player(index: 0, isAlbum: isAlbum));
    this.showNotification(state);
    state.advancedPlayer.onAudioPositionChanged.listen((duration) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
    });
    state.advancedPlayer.onPlayerCompletion.listen((onData) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(Player(isAlbum: state.isAlbum, index: state.index));
    });

    StoreProvider.of<PlayerState>(context)
        .dispatch(NavigateToAction('/player'));
  }

  void random(context, PlayerState state, bool isAlbum) {
    var randomNo = new Random().nextInt(state.length);
    // print("Random No:$randomNo");
    StoreProvider.of<PlayerState>(context)
        .dispatch(Player(index: randomNo, isAlbum: isAlbum));

    state.advancedPlayer.onAudioPositionChanged.listen((duration) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
    });
    state.advancedPlayer.onPlayerCompletion.listen((onData) {
      var randomNo = new Random().nextInt(state.length);
      StoreProvider.of<PlayerState>(context)
          .dispatch(Player(isAlbum: state.isAlbum, index: randomNo));
    });
    StoreProvider.of<PlayerState>(context)
        .dispatch(NavigateToAction('/player'));
  }

  void playingFromPosition(
      context, PlayerState state, int position, bool isAlbum) {
    StoreProvider.of<PlayerState>(context)
        .dispatch(Player(index: position, isAlbum: isAlbum));

    state.advancedPlayer.onAudioPositionChanged.listen((duration) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
    });
    state.advancedPlayer.onPlayerCompletion.listen((onData) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(Player(isAlbum: state.isAlbum, index: state.index));
    });

    StoreProvider.of<PlayerState>(context)
        .dispatch(NavigateToAction('/player'));
  }

  void storage_checker(dynamic context) async {
    return await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage)
        .then((onValue) {
      print(onValue);
      if (onValue == PermissionStatus.unknown ||
          onValue == PermissionStatus.denied) {
        PermissionHandler()
            .requestPermissions([PermissionGroup.storage]).then((p) {
          print(p.toString());
          permission = true;
        });
      }
      if (onValue == PermissionStatus.granted) {
        //StoreProvider.of<PlayerState>(context).dispatch(Permission(true));
        permission = true;
      }
    });
  }

  double percentageToNumber(BuildContext context, String val, bool height) {
    //height: percentageToNumber(context, "10%", true), [this is going to adjust 10% with respect to height]
    //width: percentageToNumber(context, "30%", false), [this is going to adjust 30% with respect to width ]
    // you can use with margin,padding,width,height or anything which required some double number.
    //
    //Example::
    //Container(
    //       height: code.percentageToNumber(context, "10%", true),
    //       width: code.percentageToNumber(context, "30%", false),
    //       child: Text("data"),
    //       color: Colors.deepOrangeAccent,
    //     ),

    double no = double.parse(val.substring(0, val.length - 1));
    if (height) {
      return ((no / 100) * MediaQuery.of(context).size.height);
    } else {
      return ((no / 100) * MediaQuery.of(context).size.width);
    }
  }
}
