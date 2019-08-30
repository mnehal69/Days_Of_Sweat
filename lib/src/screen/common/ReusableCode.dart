import 'dart:async';
import 'dart:math';

import 'package:days_of_sweat/redux/store/main_store.dart';
import 'package:days_of_sweat/src/screen/Database/Database.dart';
import 'package:days_of_sweat/src/screen/Database/PlayList.dart';
import 'package:days_of_sweat/src/screen/MusicPlayer/Local/common/song.dart';
import 'package:flutter/material.dart';
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

  void playingFromintial(
      {context, PlayerState state, bool isAlbum, dynamic list = 0}) async {
    StoreProvider.of<PlayerState>(context)
        .dispatch(Player(index: 0, isAlbum: isAlbum, list: list));
    state.advancedPlayer.onAudioPositionChanged.listen((duration) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
    });
    state.advancedPlayer.onPlayerCompletion.listen((onData) {
      StoreProvider.of<PlayerState>(context).dispatch(
          Player(isAlbum: state.isAlbum, index: state.index, list: list));
    });

    StoreProvider.of<PlayerState>(context)
        .dispatch(NavigateToAction('/player'));
  }

  void random({context, PlayerState state, bool isAlbum}) {
    var randomNo = new Random().nextInt(state.length);
    // print("Random No:$randomNo");
    StoreProvider.of<PlayerState>(context)
        .dispatch(Player(index: randomNo, isAlbum: isAlbum));
    // this.showNotification(state);
    state.advancedPlayer.onAudioPositionChanged.listen((duration) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
    });
    state.advancedPlayer.onPlayerCompletion.listen((onData) {
      var randomNo = new Random().nextInt(state.length);
      StoreProvider.of<PlayerState>(context).dispatch(Player(
        isAlbum: state.isAlbum,
        index: randomNo,
      ));
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

  void playbutton(context, PlayerState state) async {
    StoreProvider.of<PlayerState>(context).dispatch(
      AudioPlaying(!state.playing, state.currentDuration),
    );

    if (state.playing) {
      state.advancedPlayer.resume();
      state.advancedPlayer.seek(Duration(milliseconds: state.currentDuration));
    } else {
      state.advancedPlayer.pause().catchError((onError) {
        print("SOMTHING WRONG:$onError");
        state.advancedPlayer.release();
      });
    }
  }

  void prevNextBtn(context, PlayerState state, int btn) {
    if (btn == -1) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(Player(index: state.index - 1, isAlbum: state.isAlbum));
    } else {
      StoreProvider.of<PlayerState>(context)
          .dispatch(Player(index: state.index + 1, isAlbum: state.isAlbum));
    }

    state.advancedPlayer.onAudioPositionChanged.listen((duration) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(AudioPlaying(state.playing, duration.inMilliseconds));
    });
    state.advancedPlayer.onPlayerCompletion.listen((onData) {
      StoreProvider.of<PlayerState>(context)
          .dispatch(Player(isAlbum: state.isAlbum, index: state.index + 1));
    });
  }

  void creatingPlaylist(dynamic context, List<Song> songs) async {
    // testing();
    DBProvider.db.printTable();
    List<String> type = await DBProvider.db.getType();
    List<List<PlayListModel>> playModelList = [];
    List<List<Song>> playlistAlbum = [];
    // print("type:$type");
    if (type.length > 0) {
      //more than type
      for (int i = 0; i < type.length; i++) {
        playModelList.add(await DBProvider.db.getPlayList(
            type[i])); //get all playlistmodel of that specific type
        // list in which all song of that specific type will be
        List<Song> playlist = [];

        for (int j = 0; j < playModelList[i].length; j++) {
          int id = playModelList[i][j].songID;
          if (contain(id, songs)[0]) {
            playlist.add(contain(id, songs)[1]);
          }
        }
        playlistAlbum.add(playlist);
      }
      // print("PlaylistScreen:${playlistAlbum.toString()}");
    }
    StoreProvider.of<PlayerState>(context).dispatch(PlayListSection(
        type: type, playList: playlistAlbum, playModelList: playModelList));
  }

  dynamic contain(int id, List<Song> song) {
    for (int i = 0; i < song.length; i++) {
      if (id == song[i].id) {
        return [true, song[i]];
      }
    }
    return [false];
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
